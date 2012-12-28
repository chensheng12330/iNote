//
//  SHINoteUser.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "Header.h"
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

-(id) initWithJSON:(NSDictionary*) _dict
{
    self = [super init];
    if (self) {
        if (_dict==nil || [_dict count]==0) {
            [self initAllNil];
            return self;
        }
        
        // all values
        self.strUser            = [_dict objectForKey:JK_NOTEUSER_USER];
        self.strTotal_size      = [NSString ToStringWithNSDecimalNumber:[_dict objectForKey:JK_NOTEUSER_TOTALSIZE]];
        self.strUsed_size       = [NSString ToStringWithNSDecimalNumber:[_dict objectForKey:JK_NOTEUSER_USEDSIZE]];
        
        //精确到秒 unix time /1000
        self.dateRegister_time  = [NSString ToNSDateWithNSDecimalNumber:[_dict objectForKey:JK_NOTEUSER_REGISTERTIME]
                                                                precision:1000.0];
        self.dateLast_modify_time = [NSString ToNSDateWithNSDecimalNumber:[_dict objectForKey:JK_NOTEUSER_LASTLOGINTIME]
                                                                precision:1000.0];
        self.dateLast_login_time  = [NSString ToNSDateWithNSDecimalNumber:[_dict objectForKey:JK_NOTEUSER_LASTMODIFYTIME]
                                                                precision:1000.0];
        self.strDefault_notebook = [_dict objectForKey:JK_NOTEUSER_DEFAULTNOTEBOOK];
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
    NSString *descripton=[NSString stringWithFormat:@" strUser:%@\n strTotal_size:%@\n strUsed_size:%@\n dateRegister_time:%@\n dateLast_login_time:%@\n dateLast_modify_time:%@\n strDefault_notebook:%@\n ",self.strUser,self.strTotal_size,self.strUsed_size,self.dateRegister_time,self.dateLast_login_time,self.dateLast_modify_time,self.strDefault_notebook];
    return (descripton);
}

- (void)dealloc
{
    [self initAllNil];
    [super dealloc];
}
@end
