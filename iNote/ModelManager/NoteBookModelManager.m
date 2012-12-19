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

@implementation NoteBookModelManager
@synthesize _dbManage;
@synthesize _noteClient;

- (id)init
{
    self = [super init];
    if (self) {
        _dbManage   = [SHDBManage sharedDBManage];
        _noteClient = [SHNoteClient shareNoteClient:self];
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
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
    
    //
    NSMutableArray *noteBookArrayWeb = [SHNotebook objectsForJSON:dic];
    
    for (NSDictionary *tempDict in dic) {
        //时间对比，> = <
        //只下载新数据   //只上传新数据，update数据
        NSString *strName = [tempDict objectForKey:JK_NOTEBOOK_NAME];
        
        //search from db
        SHNotebook *dbTempNotebook = [_dbManage getNoteBookInfoWithNoteBookName:strName];
        if (dbTempNotebook==NULL) { //no record in db
            //add current record to db
            [_dbManage addNoteBook:dbTempNotebook];
        }
        else
        {
            // compare modify time
            NSDate *tempDate = [NSString ToNSDateWithNSDecimalNumber:[tempDict objectForKey:JK_NOTEBOOK_MODIFYTIME] precision:PRECISION_DEFAULT];
            
            if ([dbTempNotebook.dateModify_time compare:tempDate]) {
                //update record
                SHNotebook *webNoteBook = [[SHNotebook alloc] initWithJSON:tempDict];
                webNoteBook.nTable_id   = dbTempNotebook.nTable_id;  //set tabelid
                [_dbManage updateNoteBook:webNoteBook oldNoteBookName:dbTempNotebook.strNotebookName];
                [webNoteBook release];
            }
        }
    }
    
    //synchronization finish
    //now db's notebook is newest
    
    //get all notebook from db
    return [_dbManage getAllNoteBooks];
}

#pragma mark - noteClient delegate
//success
- (void)requestFinished:(SHNoteClient *)_noteClient object:(id)_obj
{
    
}

//fail
- (void)requestFailed:  (SHNoteClient *)request
{
    
}
@end
