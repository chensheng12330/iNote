//
//  SHModelManagerBase.m
//  iNote
//
//  Created by sherwin.chen on 12-12-26.
//
//

#import "SHModelManagerBase.h"

@implementation SHModelManagerBase
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

#pragma mark - noteClient delegate
//success
- (void)requestFinished:(SHNoteClient *)_noteClient object:(id)_obj
{}

//fail
- (void)requestFailed:  (SHNoteClient *)request
{}
@end
