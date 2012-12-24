//
//  NSString+SHNSStringForDate.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-6.
//
//

#import <Foundation/Foundation.h>

#define PRECISION_DEFAULT   (1.0f)

@interface NSString (SHNSStringForDate)

+(NSDate*)   dateFormatString:(NSString*)_string;
+(NSString*) stringFormatDate:(NSDate*)_date;

+(NSString*)ToStringWithNSDecimalNumber:(NSDecimalNumber*)_num;
+(NSDate*)  ToNSDateWithNSDecimalNumber:(NSDecimalNumber*)_num
                              precision:(float) _precision;
@end
