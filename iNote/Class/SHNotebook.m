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
@synthesize strCreate_time,strModify_time;

-(void)initAllNil
{
    self.strPath = nil;
    self.strNotes_num   = nil;
    self.strNotebookName= nil;
    self.strCreate_time = nil;
    self.strModify_time = nil;
    
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
    NSString *descripton=[NSString stringWithFormat:@"strPath:%@  strNotes_num:%@  strNotebookName:%@ /nstrCreate_time:%@  strModify_time:%@  ",self.strPath,self.strNotes_num,self.strNotebookName,self.strCreate_time,self.strModify_time];
    return (descripton);
}
@end
