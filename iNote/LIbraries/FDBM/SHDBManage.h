//
//  SHDBManage.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-7.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

/*
 class property: Singleton model
*/

@interface SHDBManage : NSObject
{
@private
    FMDatabase *db;
}

//***************************************
//object init Method

/*
 初使化对象唯一方法
 */
+(SHDBManage*) sharedExerciseManage;
@end
