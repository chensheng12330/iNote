//
//  NoteBookModelManager.m
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import "JSON.h"
#import "Header.h"
#import "NSString+SHNSStringForDate.h"
#import "NoteBookModelManager.h"


@interface NoteBookModelManager (Private)
-(void)comparePullData:(NSMutableArray*)_array;
-(void)comparePushData:(NSMutableArray*)_array;
@end

@implementation NoteBookModelManager
@synthesize _dbManage;
@synthesize _noteClient;

- (id)init
{
    self = [super init];
    if (self) {
        _dbManage   = [SHDBManage sharedDBManage];
        _noteClient = [[SHNoteClient shareNoteClient:self] retain];
        //_noteClient.noteClienDelegate = self;
    }
    return self;
}
- (void)dealloc
{
    _dbManage = nil;
    [_noteClient release]; _noteClient = nil;
    [super dealloc];
}

#pragma mark -private interface
-(void)comparePullData:(NSMutableArray*)_array
{
    if (_array==NULL || _array.count <1) return;
    
    for (NSDictionary *tempDict in _array) {
        //时间对比，> = <
        //只下载新数据   //只上传新数据，update数据
        NSString    *strName       = [tempDict objectForKey:JK_NOTEBOOK_NAME];
        SHNotebook  *webNoteBook   = [[SHNotebook alloc] initWithJSON:tempDict];
        
        //search from db
        SHNotebook *dbTempNotebook = [_dbManage getNoteBookInfoWithNoteBookName:strName];
        if (dbTempNotebook==NULL) { //no record in db
            //add current record to db
            [_dbManage addNoteBook:webNoteBook];
        }
        else
        {
            // compare modify time
            NSDate *tempDate = [NSString ToNSDateWithNSDecimalNumber:[tempDict objectForKey:JK_NOTEBOOK_MODIFYTIME] precision:PRECISION_DEFAULT];
            
            if ([tempDate compare:dbTempNotebook.dateModify_time]>NSOrderedAscending) {
                //update record
                webNoteBook.nTable_id   = dbTempNotebook.nTable_id;  //set tabelid
                [_dbManage updateNoteBook:webNoteBook oldNoteBookName:dbTempNotebook.strNotebookName];
            }
        }
        
        [webNoteBook release];
    }
    return;
}

-(void)comparePushData:(NSMutableArray*)_array
{
    return;
}

#pragma mark -Peripheral Interface
-(NSMutableArray*) pullCloudDataAndUpdateDB
{
    //synchronization db for noteBook
    
    //get data from web cloud
    NSData * _data = [_noteClient getNoteBooksWithRequesMode:Reques_Syn];
    if (_data ==NULL) return nil;
    
    NSString *strRep = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSMutableArray* dic = [strRep JSONValue];
    [strRep release];
    //
    //NSMutableArray *noteBookArrayWeb = [SHNotebook objectsForJSON:dic];
    [self comparePullData:dic];
    
    //synchronization finish
    //now db's notebook is newest
    
    //get all notebook from db
    return [_dbManage getAllNoteBooks];
}

-(void) pullCloudDataAndUpdateDBWith:(id)aDelegate action:(SEL)anAction
{
    if (aDelegate==NULL || anAction == NULL || ![aDelegate respondsToSelector:anAction]) return;
    
    _anAction    = anAction;
    _objDelegate = aDelegate;
    
    //satrt request
    [_noteClient getNoteBooksWithRequesMode:Reques_Asyn];
}
#pragma mark - noteClient delegate
//success
- (void)requestFinished:(SHNoteClient *)_noteClient object:(id)_obj
{
    if (_anAction==NULL || _objDelegate==NULL) return;
    
    // process request object
    [self comparePullData:_obj];
    
    NSMutableArray* _marry = [_dbManage getAllNoteBooks];
    [_objDelegate performSelector:_anAction withObject:_marry];
    return;
}

//fail
- (void)requestFailed:  (SHNoteClient *)request
{
    if (_anAction==NULL || _objDelegate==NULL) return;
    [_objDelegate performSelector:_anAction withObject:nil];
}
@end
