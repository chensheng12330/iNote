//
//  NoteBookModelManager.m
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import "JSON.h"
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
    //同步 ,
    
    //get data from web cloud
    NSData * _data = [_noteClient getNoteBooksWithRequesMode:Reques_Syn];
    if (_data ==NULL) return nil;
    
    NSString *strRep = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSMutableArray* dic = [strRep JSONValue];
    
    NSMutableArray *noteBookArrayWeb = [SHNotebook objectsForJSON:dic];
    
    for (NSDictionary *tempDict in noteBookArrayWeb) {
        //时间对比，> = <
        //只下载新数据   //只上传新数据，update数据
        //NSString *strName =
    }
    
    if (noteBookArrayWeb) {
        //synchronization db for noteBook
        
        
        //_dbManage
    }
    return nil;
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
