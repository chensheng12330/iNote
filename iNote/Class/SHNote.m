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
@synthesize strContent,strNoteSize,strCreate_time;


-(void)initAllNil
{
    self.strTitle    = nil;
    self.strAuthor   = nil;
    self.strSource   = nil;
    self.strContent  = nil;
    self.strNoteSize = nil;
    self.strCreate_time = nil;
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
@end
