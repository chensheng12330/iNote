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
#define DEBUG_DB_ERROR_LOG { if(DEBUG_OUT) { if([db hadError]){ NSLog(@"DB ERROR: %@",[db lastErrorMessage]);return FALSE;}}}
#endif


static SHDBManage *_sharedDBManage = nil;

@interface SHDBManage (private)


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
    if (NULL == _noteBook) return FALSE;
    
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
     is_update=? \
     where name=?" ,
     _newNoteBook.strPath,
     _newNoteBook.strNotebookName,
     _newNoteBook.strNotes_num,
     [NSString stringFormatDate:_newNoteBook.dateCreate_time],
     [NSString stringFormatDate:_newNoteBook.dateModify_time],
     [NSString stringWithFormat:@"%d",_newNoteBook.isUpdate],
     _stringName];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    return YES;
}

-(NSMutableArray*) getAllNoteBooks
{
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteBookTable"];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNotebook *fNotebook = [[SHNotebook alloc] init];
        fNotebook.nTable_id       = [rs intForColumnIndex:0];
        fNotebook.strPath         = [rs objectForColumnIndex:1];
        fNotebook.strNotebookName = [rs objectForColumnIndex:2];
        fNotebook.strNotes_num    = [rs objectForColumnIndex:3];
        fNotebook.dateCreate_time = [NSString dateFormatString:[rs objectForColumnIndex:4]];
        fNotebook.dateModify_time = [NSString dateFormatString:[rs objectForColumnIndex:5]];
        fNotebook.isUpdate        = [[rs objectForColumnIndex:6] boolValue];
        
        [returnArrVal addObject:fNotebook];
        [fNotebook release];
    }
    
    //close the result set.
    [rs close];
    
    return returnArrVal;
}


-(BOOL) deleteNotebookWithName:(NSString*)_stringName
{
    //使用事物管理
    
    //delete notebook
    //delete all notes
    return true;
}

-(int) getNoteBookCountWithName:(NSString *)_stringName
{
    if (_stringName==NULL || [_stringName isEqualToString:@""]) return 0;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select name from NoteBookTable where name=?",_stringName];
    NSInteger row_num = [rs rowDataCount];
    [rs close];
    
    return row_num;
}

-(SHNotebook*) getNoteBookInfoWithNoteBookName:(NSString*) _stringName
{
    if (_stringName==NULL || [_stringName isEqualToString:@""]) return nil;
    
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteBookTable where name=?",_stringName];
    
    DEBUG_DB_ERROR_LOG;
    
    SHNotebook *notebook =nil;
    if([rs next])
    {
        notebook = [[[SHNotebook alloc] init] autorelease];
        notebook.nTable_id      = [rs intForColumnIndex:0];
        notebook.strPath        = [rs stringForColumnIndex:1];
        notebook.strNotebookName= [rs stringForColumnIndex:2];
        notebook.strNotes_num   = [rs stringForColumnIndex:3];
        notebook.dateCreate_time= [NSString dateFormatString:[rs objectForColumnIndex:4]];
        notebook.dateModify_time= [NSString dateFormatString:[rs objectForColumnIndex:5]];
        notebook.isUpdate       = [[rs stringForColumnIndex:6] boolValue];
    }
    return notebook;
}

-(void) synchronizationNoteBooK:(NSArray*) _arryData
{
    if(_arryData==nil || _arryData.count<1) return;
    DBMQuickCheck(db);
}

#pragma mark - NoteTable 
-(NSMutableArray*)getAllNotes
{
    DBMQuickCheck(db);
    FMResultSet *rs = [db executeQuery:@"select * from NoteTable"];
    
    //get query db log
    DEBUG_DB_ERROR_LOG;
    
    NSMutableArray *returnArrVal = [[[NSMutableArray alloc]init] autorelease];
    //get note'user info
    while ([rs next])
    {
        SHNotebook *fNotebook = [[SHNotebook alloc] init];
        fNotebook.nTable_id       = [rs intForColumnIndex:0];
        fNotebook.strPath         = [rs objectForColumnIndex:1];
        fNotebook.strNotebookName = [rs objectForColumnIndex:2];
        fNotebook.strNotes_num    = [rs objectForColumnIndex:3];
        fNotebook.dateCreate_time = [NSString dateFormatString:[rs objectForColumnIndex:4]];
        fNotebook.dateModify_time = [NSString dateFormatString:[rs objectForColumnIndex:5]];
        fNotebook.isUpdate        = [[rs objectForColumnIndex:6] boolValue];
        
        [returnArrVal addObject:fNotebook];
        [fNotebook release];
    }
    
    //close the result set.
    [rs close];
    
    return returnArrVal;
}
-(SHNote*)getNoteWithNoteID:(int)_note_id
{
    return nil;
}
-(SHNote*)getNoteWithNotePath:(NSString*)_notepath
{
    return nil;
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
    
    _note.nTable_id = seq_num;
    
    //add to noteTable
    [db executeUpdate:@"insert into NoteTable \
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
     is_update) \
     values (?, ?, ?, ?, ?, ?)" ,
     _note.nTable_id,
     _note.strTitle,
     _note.strAuthor,
     _note.strSource,
     [NSString stringFormatDate:_note.dateCreate_time],
     [NSString stringFormatDate:_note.dateModify_time],
     _note.strContent,
     _note.strNotebookName,
     _note.strPath,
     [NSString stringWithFormat:@"%d",_note.isUpdate]];
    
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
     is_update=? \
     where note_id=?",
     _note.strTitle,
     _note.strAuthor,
     _note.strSource,
     [NSString stringFormatDate:_note.dateCreate_time],
     [NSString stringFormatDate:_note.dateModify_time],
     _note.strContent,
     _note.strNotebookName,
     _note.strPath,
     [NSString stringWithFormat:@"%d",_note.isUpdate],
     _note.nTable_id];

    //get update db log
    DEBUG_DB_ERROR_LOG;

    return YES;
}

// logic delete
-(BOOL) logicDeleteNoteWithNoteID:(int)_note_id
{
    if (_note_id < 1) return NO;
    
    DBMQuickCheck(db);
    
    BOOL bExe = [db executeUpdate:@"update NoteTable set \
     is_delete=? ",
     "1"];
    
    DEBUG_DB_ERROR_LOG;
    
    return bExe;
}

-(BOOL) physicsDeleteNoteWithNoteID:(int)_note_id
{
    if(_note_id <1) return NO;
    DBMQuickCheck(db);
    
    BOOL bExe = [db executeUpdate:@"delete from NoteTable where \
                 note_id=?",_note_id];
    
    DEBUG_DB_ERROR_LOG;
    return YES;
}

@end
