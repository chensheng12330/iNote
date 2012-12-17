//
//  NoteBookModelManager.m
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import "NoteBookModelManager.h"

@implementation NoteBookModelManager
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
