//
//  SHModelManagerBase.h
//  iNote
//
//  Created by sherwin.chen on 12-12-26.
//
//

#import <Foundation/Foundation.h>
#import "SHDBManage.h"
#import "SHNoteClient.h"

@interface SHModelManagerBase : NSObject<SHNoteClientDelegate>
{
    SHDBManage   *_dbManage;
    SHNoteClient *_noteClient;
}

@property (readonly) SHDBManage   *_dbManage;
@property (readonly) SHNoteClient *_noteClient;

@end
