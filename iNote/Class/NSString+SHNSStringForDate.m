//
//  NSString+SHNSStringForDate.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-6.
//
//

#import "NSString+SHNSStringForDate.h"

@implementation NSString (SHNSStringForDate)

+(NSString*) stringFormatDate:(NSDate *)_date
{
    NSAssert(_date != nil, @"Sherwin: SHNSStringForDate.stringFormatDate parmant is nil.");
    if (_date == nil) {
        
        return nil;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    
    NSString *_tempstring = [format stringFromDate:_date];
    [format release];
    
    return _tempstring;
}

+(NSDate*) dateFormatString:(NSString*)_string
{
    NSAssert(_string != nil, @"Sherwin: SHNSStringForDate.stringFormatDate parmant is nil.");
    if ([_string isEqualToString:@""]) {
        return nil;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    
    NSDate *_date = [format dateFromString:_string];
    [format release];
    
    return _date;
}

//////
+(NSString*)ToStringWithNSDecimalNumber:(NSDecimalNumber*)_num
{
    double _dnum = [_num doubleValue];
    return [NSString stringWithFormat:@"%.2lf",_dnum];
}


+(NSDate*)ToNSDateWithNSDecimalNumber:(NSDecimalNumber*)_num precision:(float) _precision
{
    double _dnum = [_num doubleValue]/_precision;
    //NSString *str = [NSString stringWithFormat:@"%.lf",(_dnum/1000.0)];
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:_dnum];
    return data;
}

-(BOOL) stringIsNumeral
{
    if ([self isEqualToString:@""]) return NO;
    unichar ch0 ='0' , ch9 = '9';
    
    for (int i=0; i<[self length]; i++) {
        unichar ch = [self characterAtIndex:i];
        if (ch<ch0 || ch>ch9) {
            return NO;
        }
    }
    return YES;
}
@end
