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
@synthesize strUser = _strUser,strUsed_size = _strUsed_size,strTotal_size =_strTotal_size,strRegister_time= _strRegister_time;

@synthesize strDefault_notebook =_strDefault_notebook,strLast_login_time=_strLast_login_time,strLast_modify_time=_strLast_modify_time;

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

-(NSString*)ToStringWithNSDecimalNumber:(NSDecimalNumber*)_num
{
    double _dnum = [_num doubleValue];
    return [NSString stringWithFormat:@"%lf",_dnum];
}

-(id) initWithJSON:(NSDictionary*) _dict
{
    self = [super init];
    if (self) {
        if (_dict==nil || [_dict count]==0) {
            [self initAllNil];
            return self;
        }
        
        // all values
        self.strUser = [_dict objectForKey:@"user"];
        self.strUsed_size = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"total_size"]];
        self.strTotal_size= [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"used_size"]];
        self.strRegister_time    = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"register_time"]];
        self.strLast_modify_time = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"last_login_time"]];
        self.strLast_login_time  = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"last_modify_time"]];
        self.strDefault_notebook = [_dict objectForKey:@"default_notebook"];
    }
    
    return self;
}

-(NSString*) objectWithIndex:(int)_index
{
    if (_index<0) {
        return @"";
    }
    
    double ltotal_size=0.0, lused_size =0.0, dRate =0.0;
    
    switch (_index) {
        case 0:  //账户
            return self.strUser;
        case 1:
            ltotal_size = [_strTotal_size longLongValue];
            lused_size  = [_strUsed_size  longLongValue];
            dRate       = 1-lused_size/ltotal_size;
            strUsableRate = [NSString stringWithFormat:@"%.2f",dRate];
            return strUsableRate;
        case 2: //已使用空间
            return self.strUsed_size;
        case 3: //总空间
            return self.strTotal_size;
        case 4: //最后登录时间
            return self.strLast_login_time;
        case 5: //最近修改时间
            return self.strLast_modify_time;
        default:
            return @"";
    }
    return @"";
}

-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"strUser:%@  strTotal_size:%@  strUsed_size:%@ /nstrRegister_time:%@  strLast_login_time:%@  strLast_modify_time:%@  strDefault_notebook:%@ ",self.strUser,self.strTotal_size,self.strUsed_size,self.strRegister_time,self.strLast_login_time,self.strLast_modify_time,self.strDefault_notebook];
    return (descripton);
}

- (void)dealloc
{
    [self initAllNil];
    [super dealloc];
}
@end
