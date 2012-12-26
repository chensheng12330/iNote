//
//  NoteBookModelManager.h
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import <Foundation/Foundation.h>
#import "SHModelManagerBase.h"


@interface NoteBookModelManager : SHModelManagerBase
{
    //Asyn
    id  _objDelegate;
    SEL _anAction;
}



/*
 (id)aDelegate engine:(OAuthEngine *)__engine action:(SEL)anAction
 */
//down note data from youdao Cloud Server
//异步请求
-(void) pullCloudDataAndUpdateDBWith:(id)aDelegate action:(SEL)anAction;

//同步请求
-(NSMutableArray*) pullCloudDataAndUpdateDB;

-(void) pushDBDataToCloud;
@end
