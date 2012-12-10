//
//  NSString+SHNSStringForDate.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-6.
//
//

#import <Foundation/Foundation.h>

@interface NSString (SHNSStringForDate)

+(NSDate*)   dateFormatString:(NSString*)_string;
+(NSString*) stringFormatDate:(NSDate*)_date;

@end
