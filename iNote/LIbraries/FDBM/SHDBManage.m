//
//  SHDBManage.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-7.
//
//

#import "SHDBManage.h"

//expand NSString head
#import "NSString+SHNSStringForDate.h"

#ifndef DBMQuickCheck//(SomeBool)
#define DBMQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }
#endif

//log out flag
#ifndef DEBUG_OUT
#define DEBUG_OUT 1
#endif

//0 FALSE
//1 nil
#ifndef DEBUG_DB_ERROR_LOG
#define DEBUG_DB_ERROR_LOG { if(DEBUG_OUT) { if([db hadError]){ NSLog(@"DB ERROR: %@ on line %d",[db lastErrorMessage],__LINE__);return FALSE;}}}
#endif


static SHDBManage *_sharedDBManage = nil;

@interface SHDBManage (private)
-(SHNote*)         analyzingNoteResultSet:(FMResultSet*)rs;
-(SHNotebook*)     analyzingNotebookResultSet:(FMResultSet*)rs;
-(SHNoteRelation*) analyzingNoteRelationResultSet:(FMResultSet*)rs;

//get

//notebook
-(SHNotebook*)     getNotebookWithNOTEBOOK_FIELD:(NOTEBOOK_FIELD)_notebook_field
                                        Value:(NSString*) _value;
-(NSMutableArray*) getNoteBookWithNOTEBOOK_FIELD:(NOTEBOOK_FIELD)_notebook_field
                                           Value:(NSString*)_string;
//note
-(NSMutableArray*) getNoteWithNOTE_FIELD:(NOTE_FIELD)_note_field
                                   Value:(NSString*)_string;
@end


@implementation SHDBManage
@synthesize dbErrorInfo = _dbErrorInfo;

#pragma mark - object init
+(SHDBManage*) sharedDBManage
{
    @synchronized(self)
    {
        if (nil == _sharedDBManage ) {
            [[[self alloc] init] autorelease];
        }
    }
    return _sharedDBManage;
}

+(id)alloc
{
    @synchronized([SHDBManage class]) //线程访问加锁
    {
        NSAssert(_sharedDBManage == nil, @"Shewin: Attempted to allocate a second instance of a singleton.Please call +[sharedExerciseManage] method.");
        _sharedDBManage  = [super alloc];
        return _sharedDBManage;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        //database init
        db = [[FMDatabase alloc] initWithDBName:@"inote.db"];
        DBMQuickCheck([db open]);
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (nil == _sharedDBManage) {
            _sharedDBManage = [super allocWithZone:zone];
            return _sharedDBManage;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    [_dbErrorInfo release];
    /*
     other property release
     */
    if (db==nil) { return;}
    else         {[db close]; [db release]; db =nil;}
    
    [super dealloc];
    _sharedDBManage = nil;
}

- (oneway void)release
{
    // do nothing
    if(db==nil)
    {
        NSLog(@"SHDBManage: retainCount is 0.");
        return;
    }
    [super release];
    return;
}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax; // This is sooo not zero
}

#pragma mark - SHDBManage_Private_fuction


#pragma mark - NoteUser_fuction_method
/* UserInfoTable
 userid
 user
 total_size
 user_size
 last_login_time
 last_modify_time 
 register_time
 default_notebook
 */

-(SHNoteUser*) getNoteUserInfo
{
    //check parameter 
    //if (_string == nil || [_string isEqualToString:@""]) return nil;
    
    //check db whether NULL
    DBMQuickCheck(db);
    
    //begin sql query
    FMResultSet *rs = [db executeQuery:@"select * from UserInfoTable"];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;

    //get note'user info
    SHNoteUser *fNoteUser = [[[SHNoteUser alloc] init] autorelease];
    if([rs next])
    {
        fNoteUser.strUser       = [rs objectForColumnIndex:1];
        fNoteUser.strTotal_size = [rs objectForColumnIndex:2];
        fNoteUser.strUsed_size  = [rs objectForColumnIndex:3];
        fNoteUser.dateLast_login_time = [NSString dateFormatString:[rs objectForColumnIndex:4]];
        fNoteUser.dateLast_modify_time= [NSString dateFormatString:[rs objectForColumnIndex:5]];
        fNoteUser.dateRegister_time   = [NSString dateFormatString:[rs objectForColumnIndex:6]];
        fNoteUser.strDefault_notebook = [rs objectForColumnIndex:7];
    }
    
    //close the result set.
    [rs close];
    
    // return result
    return fNoteUser;
}

-(BOOL) setNoteUserDataToDB:(SHNoteUser*)_noteUser
{
    if (_noteUser==nil || _noteUser.retainCount<=0) {
        return FALSE;
    }
    
    DBMQuickCheck(db);
    
    //delete user info with _noteUser in db
    [self deleteNoteUserForDB];
    
    //add user info to db
    [db executeUpdate:@"insert into UserInfoTable( \
     user, total_size, \
     used_size, \
     last_login_time,\
     last_modify_time,\
     register_time,\
     default_notebook) \
     values (?, ?, ?, ?, ?, ?, ?)" ,
     _noteUser.strUser,
     _noteUser.strTotal_size,
     _noteUser.strUsed_size,
     [NSString stringFormatDate:_noteUser.dateLast_login_time],
     [NSString stringFormatDate:_noteUser.dateLast_modify_time],
     [NSString stringFormatDate:_noteUser.dateRegister_time],
     _noteUser.strDefault_notebook
    ];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    return YES;
}

-(BOOL) deleteNoteUserForDB
{
    DBMQuickCheck(db);
    return [db executeUpdate:@"delete from UserInfoTable"];
}

#pragma mark - Notebook_fuction
/*NotebookTable
 notebook_id
 path ,
 name ,
 notes_num ,
 create_time ,
 modify_time ,
 is_update
 */
-(BOOL) addNoteBook:(SHNotebook*) _noteBook
{
    //check parameter
    if (NULL == _noteBook || [_noteBook.strNotebookName isEqualToString:@""]) return FALSE;
    
    if([self getNoteBookCountWithName:_noteBook.strNotebookName]) { _dbErrorInfo = @"Record already exists."; return FALSE;}
    
    DBMQuickCheck(db);
    
    //check notebook'name is unique
    
    [db executeUpdate:@"insert into NotebookTable( \
     path, \
     name, \
     notes_num,\
     create_time,\
     modify_time,\
     is_update) \
     values (?, ?, ?, ?, ?, ?)" ,
     _noteBook.strPath,
     _noteBook.strNotebookName,
     _noteBook.strNotes_num,
     [NSString stringFormatDate:_noteBook.dateCreate_time],
     [NSString stringFormatDate:_noteBook.dateModify_time],
     [NSString stringWithFormat:@"%d",_noteBook.isUpdate]];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    return YES;
}

/*
 update NoteBookTable set name='asdf'  path='asdf' where name ='1'
 */

-(BOOL) updateNoteBook:(SHNotebook*)_newNoteBook oldNoteBookName:(NSString*) _stringName
{
    //check parameter
    if (NULL == _newNoteBook) return FALSE;
    
    DBMQuickCheck(db);
    
    //check notebook'name is unique
    
    [db executeUpdate:@"update NoteBookTable set  \
     path=?, \
     name=?, \
     notes_num=?,\
     create_time=?,\
     modify_time=?,\
     is_update=?, \
     is_delete=? \
     where name=?" ,
     _newNoteBook.strPath,
     _newNoteBook.strNotebookName,
     _newNoteBook.strNotes_num,
     [NSString stringFormatDate:_newNoteBook.dateCreate_time],
     [NSString stringFormatDate:_newNoteBook.dateModify_time],
     [NSString stringWithFormat:@"%d",_newNoteBook.isUpdate],
     [NSString stringWithFormat:@"%d",_newNoteBook.isDelete],
     _stringName];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    return YES;
}

//////
-(NSMutableArray*) getNoteBookWithNOTEBOOK_FIELD:(NOTEBOOK_FIELD)_notebook_field
                                           Value:(NSString*)_string
{
    DBMQuickCheck(db);
    FMResultSet *rs =nil;
    
    if (_notebook_field ==NTF_NONE) {
        rs = [db executeQuery:@"select * from NoteBookTable"];
    }
    else if (_notebook_field == NTF_DELETE)
    {
        DBMQuickCheck(_string);
        rs = [db executeQuery:@"select * from NoteBookTable where is_delete=?",_string];
    }
    else if (_notebook_field == NTF_UPDATE)
    {
        DBMQuickCheck(_string);
        rs = [db executeQuery:@"select * from NoteBookTable where is_update=?",_string];
    }
    
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNotebook *fNotebook = [self analyzingNotebookResultSet:rs];
        [returnArrVal addObject:fNotebook];
    }
    
    //close the result set.
    [rs close];
    
    return returnArrVal;
}

-(SHNotebook*) analyzingNotebookResultSet:(FMResultSet*)rs
{
    DBMQuickCheck(rs);
    
    SHNotebook *fNotebook = [[SHNotebook alloc] init];
    fNotebook.nTable_id       = [rs intForColumnIndex:0];
    fNotebook.strPath         = [rs objectForColumnIndex:1];
    fNotebook.strNotebookName = [rs objectForColumnIndex:2];
    fNotebook.strNotes_num    = [rs objectForColumnIndex:3];
    fNotebook.dateCreate_time = [NSString dateFormatString:[rs objectForColumnIndex:4]];
    fNotebook.dateModify_time = [NSString dateFormatString:[rs objectForColumnIndex:5]];
    fNotebook.isUpdate        = [[rs objectForColumnIndex:6] boolValue];
    
    return [fNotebook autorelease];
}

-(NSMutableArray*) getAllNoteBooks
{
    return [self getNoteBookWithNOTEBOOK_FIELD:NTF_DELETE Value:@"0"];
}

/*
 //查询note_path为 "path1" 的所有笔记
  select path from NoteTable where
 */
//逻辑删除
-(BOOL) deleteLogicNotebookWithNotebookPath:(NSString*)_path
{
    if(_path==NULL || [_path isEqualToString:@""]) return NO;
    DBMQuickCheck(db);
    
    //使用事物管理
    BOOL isSuc = NO;
    if(![db beginTransaction]) return NO;
    //1、逻辑删除该笔记本下所有笔记
    isSuc = [db executeUpdate:@"update  NoteTable set is_delete=? where path in \
     (select note_path from NoteRelationTable where notebook_path=?)",@"1",_path];
    
    if(!isSuc) {[db commit]; return NO;}
    
    //2、逻辑删除该笔记本
    isSuc = [db executeUpdate:@"update NoteBookTable set is_delete=?  where path = ? ",@"1",_path];
    
    //3、如果失败，则回滚
    if (!isSuc) [db rollback];
    
    [db commit];//结束事物
    return isSuc;
}

//物理删除
-(BOOL) deletePhysicsNotebookWithNotebookPath:(NSString*)_path
{
    if(_path==NULL || [_path isEqualToString:@""]) return NO;
    
    DBMQuickCheck(db);
    
    //使用事物管理
    BOOL isSuc = NO;
    if(![db beginTransaction]) return NO;
    //1、物理删除该笔记本下所有笔记
    isSuc = [db executeUpdate:@"delete from  NoteTable where path in \
             (select note_path from NoteRelationTable where notebook_path=?)",_path];
    
    if(!isSuc) {[db commit]; return NO;}
    
    //2、物理删除该笔记关系表记录
    isSuc = [db executeUpdate:@"delete from NoteRelationTable where notebook_path = ? ",_path];
    if(!isSuc) {[db rollback]; return NO;}
    
    //3、物理删除该笔记本
    isSuc = [db executeUpdate:@"delete from NoteBookTable where path = ? ",_path];
    if(!isSuc) {[db rollback]; return NO;}
    
    //4、事物提交
    [db commit];//结束事物
    return isSuc;
}

-(int) getNoteBookCountWithName:(NSString *)_stringName
{
    if (_stringName==NULL || [_stringName isEqualToString:@""]) return 0;
    
    DBMQuickCheck(db);
    NSInteger row_num = 0;
    FMResultSet *rs = [db executeQuery:@"select count(name) from NoteBookTable where name=?",_stringName];
    
    if ([rs next]) row_num=[rs intForColumnIndex:0];
    
    [rs close];
    return row_num;
}

-(SHNotebook*) getNotebookWithNOTEBOOK_FIELD:(NOTEBOOK_FIELD)_notebook_field Value:(NSString*) _value
{
    DBMQuickCheck(db);
    FMResultSet *rs =nil;
    
    if (_notebook_field == NTF_BOOKNAME)
    {
        DBMQuickCheck(_value);
        rs = [db executeQuery:@"select * from NoteBookTable where name=?",_value];
    }
    else if (_notebook_field == NTF_BOOKPATH)
    {
        DBMQuickCheck(_value);
        rs = [db executeQuery:@"select * from NoteBookTable where path=?",_value];
    }
    else
    {
        return nil;
    }
    
    
    DEBUG_DB_ERROR_LOG;
    
    SHNotebook *notebook =nil;
    if([rs next])
    {
        notebook = [self analyzingNotebookResultSet:rs];
    }
    [rs close];
    return notebook;
}

-(SHNotebook*) getNoteBookInfoWithNoteBookPath:(NSString*) _stringName
{
    if (_stringName==NULL || [_stringName isEqualToString:@""]) return nil;
    return [self getNotebookWithNOTEBOOK_FIELD:NTF_BOOKPATH Value:_stringName];
}
-(SHNotebook*) getNoteBookInfoWithNoteBookName:(NSString*) _stringName
{
    if (_stringName==NULL || [_stringName isEqualToString:@""]) return nil;
    return [self getNotebookWithNOTEBOOK_FIELD:NTF_BOOKNAME Value:_stringName];
}

-(void) synchronizationNoteBooK:(NSArray*) _arryData
{
    if(_arryData==nil || _arryData.count<1) return;
    DBMQuickCheck(db);
}


#pragma mark - NoteRelation
-(SHNoteRelation*) analyzingNoteRelationResultSet:(FMResultSet*)rs
{
    SHNoteRelation *fNoteRelation = [[[SHNoteRelation alloc] init] autorelease];
    fNoteRelation.strNotebookPath = [rs stringForColumnIndex:1];
    fNoteRelation.strNotePath     = [rs stringForColumnIndex:2];
    
    return fNoteRelation;
}

-(NSMutableArray*) getNoteRelations
{
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteRelationTable"];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNoteRelation *fNoteRelation = [self analyzingNoteRelationResultSet:rs];
        [returnArrVal addObject:fNoteRelation];
    }
    //close the result set.
    [rs close];
    
    return returnArrVal;
}

-(NSMutableArray*) getNoteRelationWithNotebookPath:(NSString*)_path
{
    if(_path ==NULL || [_path isEqualToString:@""]) return NULL;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteRelationTable where notebook_path=? ",_path];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNoteRelation *fNoteRelation = [self analyzingNoteRelationResultSet:rs];
        [returnArrVal addObject:fNoteRelation];
    }
    //close the result set.
    [rs close];
    
    return returnArrVal;
}

-(SHNoteRelation*) getNoteRelationWithNotePath:(NSString *)_path
{
    if(_path ==NULL || [_path isEqualToString:@""]) return NULL;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteRelationTable where note_path=? ",_path];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    SHNoteRelation *returnArrVal = NULL;
    //get note'user info
    if ([rs next])
    {
        returnArrVal = [self analyzingNoteRelationResultSet:rs];
    }
    [rs close];
    
    return returnArrVal;
}

-(BOOL) addNoteRelation:(SHNoteRelation*)_noteRelation
{
    if (_noteRelation ==NULL || _noteRelation.retainCount <1) return NO;
    DBMQuickCheck(db);
    
    //add to noteTable
    [db executeUpdate:@"insert into NoteRelationTable( \
     notebook_path,\
     note_path) \
     values (?,?)",
     _noteRelation.strNotebookPath,
     _noteRelation.strNotePath];
    
    DEBUG_DB_ERROR_LOG;
    return TRUE;
}

-(BOOL) deleteNoteRelationWithNotebookPath:(NSString*)_path
{
    if(_path ==NULL || [_path isEqualToString:@""]) return NO;
    
    DBMQuickCheck(db);
    
    BOOL bExe = [db executeUpdate:@"delete from NoteRelationTable where \
                 notebook_path=?",_path];
    
    DEBUG_DB_ERROR_LOG;
    
    return bExe;
}

-(BOOL) deleteNoteRelationWithNotePath:(NSString*)_path
{
    if(_path ==NULL || [_path isEqualToString:@""]) return NO;
    
    DBMQuickCheck(db);
    
    BOOL bExe = [db executeUpdate:@"delete from NoteRelationTable where \
                 note_path=?",_path];
    
    DEBUG_DB_ERROR_LOG;
    
    return bExe;
}


#pragma mark - NoteTable 
-(NSMutableArray*) getNoteWithNOTE_FIELD:(NOTE_FIELD)_note_field
                                   Value:(NSString*)_string
{
    DBMQuickCheck((_note_field>NF_NOTE_ID && _note_field< NF_NONE));
    
    FMResultSet *rs = nil;
    
    if (_note_field == NF_NONE) {
       rs = [db executeQuery:@"select * from NoteTable"];
    }
    else if (_note_field == NF_NOTE_DELETE)
    {
        rs = [db executeQuery:@"select * from NoteTable where is_delete =?",_string];
    }
    else if (_note_field == NF_NOTE_UPDATE)
    {
        rs = [db executeQuery:@"select * from NoteTable where is_update =?",_string];
    }
    
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNote *fNote = [self analyzingNoteResultSet:rs];
        [returnArrVal addObject:fNote];
    }
    
    //close the result set.
    [rs close];
    
    return returnArrVal;
}

-(SHNote*) analyzingNoteResultSet:(FMResultSet*)rs
{
    if(rs ==NULL) return nil;
    
    SHNote *fNote = [[SHNote alloc] init];
    fNote.nTable_id         = [rs intForColumnIndex:0];
    fNote.strTitle          = [rs objectForColumnIndex:1];
    fNote.strAuthor         = [rs objectForColumnIndex:2];
    fNote.strSource         = [rs objectAtIndexedSubscript:3];
    fNote.strNoteSize       = [rs objectForColumnIndex:4];
    fNote.dateCreate_time   = [NSString dateFormatString:[rs objectForColumnIndex:5]];
    fNote.dateModify_time   = [NSString dateFormatString:[rs objectForColumnIndex:6]];
    fNote.strContent        = [rs objectForColumnIndex:7];
    fNote.strNotebookName   = [rs objectAtIndexedSubscript:8];
    fNote.strPath           = [rs objectForColumnIndex:9];
    fNote.isUpdate          = [[rs stringForColumnIndex:10] boolValue];
    fNote.isDelete          = [[rs stringForColumnIndex:11] boolValue];

    return [fNote autorelease];
}

-(NSMutableArray*)getAllNotes
{
    return [self getNoteWithNOTE_FIELD:NF_NOTE_DELETE Value:@"0"]; //获取未逻辑删除的数据
}

-(SHNote*)getNoteWithNoteID:(int)_note_id
{
    if(_note_id<1) return nil;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteTable where note_id=?",
                       [NSNumber numberWithInt:_note_id]];
    
    SHNote *fNote = nil;
    if([rs next])
    {
        fNote = [self analyzingNoteResultSet:rs];
    }
    //get query db log
    DEBUG_DB_ERROR_LOG;
    [rs close];
    return fNote;
}

-(SHNote*)getNoteWithNotePath:(NSString*)_notepath
{
    if(_notepath==NULL || _notepath.retainCount<1) return nil;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteTable where path=?",_notepath];
    
    SHNote *fNote = nil;
    if([rs next])
    {
        fNote = [self analyzingNoteResultSet:rs];
    }
    //get query db log
    DEBUG_DB_ERROR_LOG;
    [rs close];
    return fNote;
}

//以note_id做为主键，对象唯一标识
-(BOOL) addNote:(SHNote*) _note
{
    if (_note ==NULL || _note.retainCount <1) return NO;
    DBMQuickCheck(db);
    
    //get add note_id value
    int seq_num=0;
    FMResultSet *rs = [db executeQuery:@"select max(note_id) from NoteTable"];
    if([rs next]) seq_num = [rs intForColumnIndex:0]+1;
    [rs close];
    
    _note.nTable_id = seq_num;
    
    //add to noteTable
    [db executeUpdate:@"insert into NoteTable( \
     note_id, \
     title, \
     author,\
     source_url,\
     note_size,\
     create_time,\
     modify_time,\
     content,\
     notebook_name,\
     path,\
     is_update,\
     is_delete ) \
     values (?,?,?,?, ?, ?, ?, ?, ?, ?, ?,?)",
     [NSNumber numberWithInt:_note.nTable_id],
     _note.strTitle,
     _note.strAuthor,
     _note.strSource,
     _note.strNoteSize,
     [NSString stringFormatDate:_note.dateCreate_time],
     [NSString stringFormatDate:_note.dateModify_time],
     _note.strContent,
     _note.strNotebookName,
     _note.strPath,
     [NSString stringWithFormat:@"%d",_note.isUpdate],
     [NSString stringWithFormat:@"%d",_note.isDelete]
     ];
    
    //get add db log
    DEBUG_DB_ERROR_LOG;
    return TRUE;
}

-(BOOL) updateNote:(SHNote*) _note
{
    if (_note ==NULL || _note.retainCount <1) return NO;
    
    DBMQuickCheck(db);
    
    [db executeUpdate:@"update NoteTable set \
     title=?, \
     author=?,\
     source_url=?,\
     note_size=?,\
     create_time=?,\
     modify_time=?,\
     content=?,\
     notebook_name=?,\
     path=?,\
     is_update=?,\
     is_delete=? \
     where note_id=?",
     _note.strTitle,
     _note.strAuthor,
     _note.strSource,
     _note.strNoteSize,
     [NSString stringFormatDate:_note.dateCreate_time],
     [NSString stringFormatDate:_note.dateModify_time],
     _note.strContent,
     _note.strNotebookName,
     _note.strPath,
     [NSString stringWithFormat:@"%d",_note.isUpdate],
     [NSString stringWithFormat:@"%d",_note.isDelete],
     [NSNumber numberWithInt:_note.nTable_id]];

    //get update db log
    DEBUG_DB_ERROR_LOG;
    return YES;
}

// logic delete
-(BOOL) deleteLogicNoteWithNOTE_FIELD:(NOTE_FIELD)_note_fd Value:(NSString*) _value
{
    if(_note_fd < NF_NOTE_ID || _note_fd > NF_NOTE_PATH) return NO;
    DBMQuickCheck(db);
    
    //NS
    BOOL bExe = NO;
    
    if (_note_fd == NF_NOTE_ID) {
        NSString *sql = [NSString stringWithFormat:@"update NoteTable set is_delete=\"1\" where note_id=%@",_value];
        bExe = [db executeUpdate:sql];
    }
    else if (_note_fd == NF_NOTE_PATH){
        bExe = [db executeUpdate:@"update NoteTable set \
                is_delete=? where path=?",@"1",_value];
    }
    else if (_note_fd == NF_NOTEBOOK_NAME){
        bExe = [db executeUpdate:@"update NoteTable set \
                is_delete=? where notebook_name=?",@"1",_value];
    }
    
    DEBUG_DB_ERROR_LOG;
    
    return bExe;
}

-(BOOL) deletePhysicsNoteWithNOTE_FIELD:(NOTE_FIELD)_note_fd Value:(NSString*) _value
{
    if(_note_fd < NF_NOTE_ID || _note_fd > NF_NOTE_PATH) return NO;
    DBMQuickCheck(db);
    
    BOOL bExe = NO;
    if (_note_fd == NF_NOTE_ID) {
        NSString *sql = [NSString stringWithFormat:@"delete from NoteTable where note_id=%@",_value];
        bExe = [db executeUpdate:sql];
    }
    else if (_note_fd == NF_NOTE_PATH){
        bExe = [db executeUpdate:@"delete from NoteTable where \
                path=?",_value];
    }
    else if (_note_fd == NF_NOTEBOOK_NAME){
        bExe = [db executeUpdate:@"delete from NoteTable where \
                notebook_name=?",_value];
    }
    
    DEBUG_DB_ERROR_LOG;
    return bExe;
}

@end
