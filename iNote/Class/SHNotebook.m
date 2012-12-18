//
//  SHNotebook.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "SHNotebook.h"
#import "NSString+SHNSStringForDate.h"

@interface SHNotebook (prvate)
-(void)initAllNil;
@end

@implementation SHNotebook
@synthesize strPath,strNotes_num,strNotebookName;
@synthesize dateCreate_time,dateModify_time;
@synthesize isUpdate,isDelete,nTable_id;

-(void)initAllNil
{
    self.strPath         = nil;
    self.strNotes_num    = nil;
    self.strNotebookName = nil;
    self.dateCreate_time = nil;
    self.dateModify_time = nil;
    
    self.isDelete = NO;
    self.isUpdate = NO;
    self.nTable_id = -1;
    return;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initAllNil];
    }
    return self;
}

- (void)dealloc
{
    [self initAllNil];
    [super dealloc];
}

-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"strPath:%@  strNotes_num:%@  strNotebookName:%@ /nstrCreate_time:%@  strModify_time:%@  isUpdate:%d",self.strPath,self.strNotes_num,self.strNotebookName,self.dateCreate_time,self.dateModify_time,self.isUpdate];
    return (descripton);
}

#pragma mark - method
/*
 name,path,notes_num,modify_time,create_time
 */
+(NSMutableArray*) objectsForJSON:(NSArray*)_arry
{
    if(_arry==NULL || _arry.count <1) return nil;
    
    NSMutableArray *returnVal = [[NSMutableArray alloc]init];
    
    for (NSDictionary *_tempDict in _arry) {
        SHNotebook *_noteBook = [[SHNotebook alloc] init];
        _noteBook.strNotebookName   = [_tempDict objectForKey:@"name"];
        _noteBook.strPath           = [_tempDict objectForKey:@"path"];
        _noteBook.strNotes_num      = [_tempDict objectForKey:@"notes_num"];
        _noteBook.dateCreate_time   = [NSString dateFormatString:[_tempDict objectForKey:@"create_time"]];
        _noteBook.dateModify_time   = [NSString dateFormatString:[_tempDict objectForKey:@"modify_time"]];
        
        [returnVal addObject:_noteBook];
        [_noteBook release];
    }
    return [returnVal autorelease];
}
@end
