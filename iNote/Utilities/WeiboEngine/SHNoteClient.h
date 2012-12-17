#import <UIKit/UIKit.h>
#import "URLConnection.h"


typedef enum {
    WEIBO_REQUEST_TIMELINE,
    WEIBO_REQUEST_REPLIES,
    WEIBO_REQUEST_MESSAGES,
    WEIBO_REQUEST_SENT,
    WEIBO_REQUEST_FAVORITE,
    WEIBO_REQUEST_DESTROY_FAVORITE,
    WEIBO_REQUEST_CREATE_FRIENDSHIP,
    WEIBO_REQUEST_DESTROY_FRIENDSHIP,
    WEIBO_REQUEST_FRIENDSHIP_EXISTS,
} RequestType;

@class SHNoteClient;

@protocol SHNoteClientDelegate<NSObject>
@required
- (void)Auth
- (void)requestFinished:(SHNoteClient *)_noteClient object:(id)_obj;
- (void)requestFailed:  (SHNoteClient *)request;
@end

@interface SHNoteClient : URLConnection
{
    RequestType request;
    id          context;
    SEL         action;
    BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;

    BOOL _secureConnection;
}

@property(nonatomic, readonly) RequestType request;
@property(nonatomic, assign) id context;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;
@property(assign) id<SHNoteClientDelegate> noteClienDelegate;

+(SHNoteClient*) shareNoteClient;

- (id)initWithTarget:(id)aDelegate engine:(OAuthEngine *)__engine;
//获取用户信息
-(NSData*)getUseInfoWithRequesMode:(Reques_Mode)_requesMode;

//查看用户全部笔记本 :post
-(void)getNoteBooks;

//列出笔记本下的笔记 :post
-(void)getNoteDetail;

//创建笔记本
-(void) createNoteBook;

//删除笔记本
-(void) deleteNoteBook;

//创建笔记
//-(void)

//查看笔记

//修改笔记

//移动笔记

//删除笔记 http://[baseURL]/yws/open/note/delete.json

//上传附件或图片 http://[baseURL]/yws/open/resource/upload.json

//下载附件/图片/图标 http://[baseURL]/yws/open/resource/download/...  :GET
//- (void)alert;

@end
