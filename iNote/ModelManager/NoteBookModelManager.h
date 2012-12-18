//
//  NoteBookModelManager.h
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#import <Foundation/Foundation.h>

#import "SHDBManage.h"
#import "SHNoteClient.h"

@interface NoteBookModelManager : NSObject<SHNoteClientDelegate>
{
    SHDBManage   *_dbManage;
    SHNoteClient *_noteClient;
}

@property (readonly) SHDBManage   *_dbManage;
@property (readonly) SHNoteClient *_noteClient;

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
