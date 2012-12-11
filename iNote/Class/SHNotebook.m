//
//  SHNotebook.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "SHNotebook.h"
@interface SHNotebook (prvate)
-(void)initAllNil;
@end

@implementation SHNotebook
@synthesize strPath,strNotes_num,strNotebookName;
@synthesize dateCreate_time,dateModify_time;
@synthesize isUpdate;

-(void)initAllNil
{
    self.strPath = nil;
    self.strNotes_num   = nil;
    self.strNotebookName= nil;
    self.dateCreate_time = nil;
    self.dateModify_time = nil;
    self.isUpdate = NO;
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
@end
