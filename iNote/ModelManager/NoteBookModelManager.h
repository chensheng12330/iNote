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

//down note data from youdao Cloud Server
-(NSMutableArray*) pullCloudDataAndUpdateDB;

-(void) pushDBDataToCloud;
@end
