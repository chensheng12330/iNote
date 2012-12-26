//
//  SHNoteModelManager.h
//  iNote
//
//  Created by sherwin.chen on 12-12-26.
//
//

#import <Foundation/Foundation.h>
#import "SHModelManagerBase.h"

@interface SHNoteModelManager : SHModelManagerBase
{
    //Asyn
    id  _objDelegate;
    SEL _anAction;
}

//异步请求
-(void) pullCloudDataAndUpdateDBWith:(id)aDelegate action:(SEL)anAction;

//同步请求
-(NSMutableArray*) pullCloudDataAndUpdateDB;

@end