//
//  SHINoteUser.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "SHNoteUser.h"


@interface SHNoteUser (private)
-(void)initAllNil;
@end


@implementation SHNoteUser
@synthesize strUser,strUsed_size,strTotal_size,strRegister_time;
@synthesize strDefault_notebook,strLast_login_time,strLast_modify_time;

-(void)initAllNil
{
    self.strUser = nil;
    self.strUsed_size = nil;
    self.strTotal_size= nil;
    self.strRegister_time = nil;
    self.strLast_modify_time = nil;
    self.strLast_login_time  = nil;
    self.strDefault_notebook = nil;
    
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
