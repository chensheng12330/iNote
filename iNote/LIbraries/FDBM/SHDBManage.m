//
//  SHDBManage.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-7.
//
//

#import "SHDBManage.h"

static SHDBManage *_sharedDBManage = nil;

@implementation SHDBManage

#pragma mark - object init
+(SHDBManage*) sharedExerciseManage
{
    @synchronized(self)
    {
        if (nil == _sharedDBManage ) {
            [[self alloc] init];
        }
    }
    return _sharedDBManage;
}

+(id)alloc
{
    @synchronized([SHDBManage class]) //线程访问加锁
    {
        NSAssert(_sharedDBManage == nil, @"Shewin: Attempted to allocate a second instance of a singleton.Please call +[sharedExerciseManage] method.");
        _sharedDBManage  = [super alloc];
        return _sharedDBManage;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        //database init
        db = [[FMDatabase alloc] initWithPath:@"inote.db"];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (nil == _sharedDBManage) {
            _sharedDBManage = [super allocWithZone:zone];
            return _sharedDBManage;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    /*
     other property release
     */
    if (db==nil) { return;}
    else         {[db release]; db =nil;}
    
    [super dealloc];
    _sharedDBManage = nil;
}

- (oneway void)release
{
    // do nothing
    if(db==nil)
    {
        NSLog(@"SHDBManage: retainCount is 0.");
        return;
    }
    [super release];
    return;
}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax; // This is sooo not zero
}

#pragma mark - fuction method
@end
