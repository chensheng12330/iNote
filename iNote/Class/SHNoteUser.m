//
//  SHINoteUser.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "SHNoteUser.h"
#import "NSString+SHNSStringForDate.h"

@interface SHNoteUser (private)
-(void)initAllNil;
@end


@implementation SHNoteUser
@synthesize 
strUser          = _strUser,
strUsed_size     = _strUsed_size,
strTotal_size    = _strTotal_size,
dateRegister_time= _dateRegister_time,
nTable_id        = _nTable_id;

@synthesize strDefault_notebook =_strDefault_notebook,dateLast_login_time=_dateLast_login_time,dateLast_modify_time=_dateLast_modify_time;

-(void)initAllNil
{
    self.strUser = nil;
    self.strUsed_size = nil;
    self.strTotal_size= nil;
    self.dateRegister_time = nil;
    self.dateLast_modify_time = nil;
    self.dateLast_login_time  = nil;
    self.strDefault_notebook = nil;
    _nTable_id = -1;
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
    return [NSString stringWithFormat:@"%.2lf",_dnum];
}

-(NSDate*)ToNSDateWithNSDecimalNumber:(NSDecimalNumber*)_num
{
    double _dnum = [_num doubleValue]/1000.0;
    //NSString *str = [NSString stringWithFormat:@"%.lf",(_dnum/1000.0)];
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:_dnum];
    return data;
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
        self.strTotal_size = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"total_size"]];
        self.strUsed_size  = [self ToStringWithNSDecimalNumber:[_dict objectForKey:@"used_size"]];
        self.dateRegister_time    = [self ToNSDateWithNSDecimalNumber:[_dict objectForKey:@"register_time"]];
        self.dateLast_modify_time = [self ToNSDateWithNSDecimalNumber:[_dict objectForKey:@"last_login_time"]];
        self.dateLast_login_time  = [self ToNSDateWithNSDecimalNumber:[_dict objectForKey:@"last_modify_time"]];
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
    ltotal_size = [_strTotal_size doubleValue];
    lused_size  = [_strUsed_size  doubleValue];
    
    switch (_index) {
        case 0:  //账户
            return self.strUser;
        case 1:
            dRate       = lused_size/ltotal_size;
            strUsableRate = [NSString stringWithFormat:@"%f",dRate];
            return strUsableRate;
        case 2: //已使用空间
            return [NSString stringWithFormat:@"%.2lfMB",(lused_size/1024.0/1024.0)];
        case 3: //总空间
            return [NSString stringWithFormat:@"%.2lfMB",(ltotal_size/1024.0/1024.0)];;
        case 4: //最后登录时间
            return [NSString stringFormatDate:self.dateLast_login_time];
        case 5: //最近修改时间
            return [NSString stringFormatDate:self.dateLast_modify_time];
        default:
            return @"";
    }
    return @"";
}

-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"strUser:%@  strTotal_size:%@  strUsed_size:%@ /ndateRegister_time:%@  dateLast_login_time:%@  dateLast_modify_time:%@  strDefault_notebook:%@ ",self.strUser,self.strTotal_size,self.strUsed_size,self.dateRegister_time,self.dateLast_login_time,self.dateLast_modify_time,self.strDefault_notebook];
    return (descripton);
}

- (void)dealloc
{
    [self initAllNil];
    [super dealloc];
}
@end
