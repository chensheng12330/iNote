//
//  SHNote.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "SHNote.h"
@interface SHNote (private)
-(void)initAllNil;
@end

@implementation SHNote
@synthesize strTitle,strAuthor,strSource;
@synthesize strContent,strNoteSize,dateCreate_time,dateModify_time;
@synthesize strNotebookName,strPath;
@synthesize nTable_id,isDelete,isUpdate;

-(void)initAllNil
{
    self.strPath     = nil;
    self.strTitle    = nil;
    self.strAuthor   = nil;
    self.strSource   = nil;
    self.strContent  = nil;
    self.strNoteSize = nil;
    self.nTable_id   = -1;
    self.strNotebookName= nil;
    self.dateCreate_time = nil;
    self.dateModify_time = nil;
    
    self.isDelete =0;
    self.isUpdate =0;
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
    NSString *descripton=[NSString stringWithFormat:@" note_id:%d\n strTitle:%@\n strNotebookName:%@\n strPath:%@\n strAuthor:%@\n strSource:%@\n dateCreate_time:%@\n dateModify_time:%@\n strNoteSize:%@\n",self.nTable_id,self.strTitle,self.strNotebookName,self.strPath, self.strAuthor,self.strSource,self.dateCreate_time,self.dateModify_time,self.strNoteSize];
    return (descripton);
}
@end
