//
//  SHNoteBookModelManager.m
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import "JSON.h"
#import "Header.h"
#import "NSString+SHNSStringForDate.h"
#import "SHNoteBookModelManager.h"


@interface SHNoteBookModelManager (Private)
-(void)comparePullData:(NSMutableArray*)_array;
-(void)comparePushData:(NSMutableArray*)_array;
@end

@implementation SHNoteBookModelManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc
{
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
//更新本地
-(NSMutableArray*) pullCloudDataAndUpdateDB
{
    
//    [_dbManage deleteLogicNotebookWithNotebookPath:@"1"];
//    [_dbManage deletePhysicsNotebookWithNotebookPath:@"1"];
//    return nil;
    //synchronization db for noteBook
    
    //get data from web cloud
    NSData * _data = [_noteClient getNoteBooksWithRequesMode:Reques_Syn];
    //NSData * _data = [_noteClient getNotesPathWithNotebookPath:@"123" RequesMode:Reques_Syn];
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
    //[_noteClient getNotesWithNotebookPath:@"" RequesMode:Reques_Asyn];
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

#pragma mark - selfMethod
-(BOOL) isAtForNotebookName:(NSString*) _notebookName
{
    SHArgumCheck(_notebookName);
    return [_dbManage getNoteBookCountWithName:_notebookName];
}

-(NSMutableArray*) getAllNotebookFromDB
{
    return [_dbManage getAllNoteBooks];
}

-(BOOL) addNotebook:(SHNotebook*)_notebook
{
    SHArgumCheck(_notebook);
    return [_dbManage addNoteBook:_notebook];
}

-(BOOL) deleteNotebookWithName:(NSString*)_notebookName
{
    SHArgumCheck(_notebookName);
    SHNotebook *fNotebook = [_dbManage getNoteBookInfoWithNoteBookName:_notebookName];
    if(fNotebook) return [_dbManage deleteLogicNotebookWithNotebookPath:fNotebook.strPath];
    return NO;
}

@end
