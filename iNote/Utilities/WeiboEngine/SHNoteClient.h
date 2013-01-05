#import <UIKit/UIKit.h>
#import "URLConnection.h"
#import "SHNotebook.h"
#import "SHNote.h"

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
- (void)requestFinished:(SHNoteClient *)_noteClient object:(id)_obj;
- (void)requestFailed:  (SHNoteClient *)request;

@optional
- (void)CancelAuthentication:(SHNoteClient*) _noteClient;
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

+(SHNoteClient*) shareNoteClient:(id)_delegate;

- (id)initWithTarget:(id)aDelegate engine:(OAuthEngine *)__engine;
//获取用户信息
-(NSData*)getUseInfoWithRequesMode:(Reques_Mode)_requesMode;

//查看用户全部笔记本 :post
//1、获取成功，把每个笔记本所对应笔记path进行网络请求
//2、对所获取当前笔记本内的笔记path进行db存储
//3、path_table 增加、删除、修改
//4、每个笔记保存一份相关的path
-(NSData*)getNoteBooksWithRequesMode:(Reques_Mode)_requesMode;

//列出笔记本下的所有笔记 :post
/*列出笔记本下的笔记
 l URL：http://[baseURL]/yws/open/notebook/list.json
 l 请求方式：POST
 l Content-Type：application/x-www-form-urlencoded
 l 支持格式：JSON
 l 是否需要用户认证：是 (关于登录授权，参见请求用户授权)
 l 请求参数：笔记本路径
 l 返回结果：操作成功时http状态为200，并返回该笔记本下的笔记列表（只有笔记路径，笔记内容需要通过笔记接口获取
*/
-(NSData*)getNotesPathWithNotebookPath:(NSString*)_path
                        RequesMode:(Reques_Mode)_requesMode;

//创建笔记本
/*
 URL： http://[baseURL]/yws/open/notebook/create.json
 l 请求方式：POST
 l Content-Type：application/x-www-form-urlencoded
 l 支持格式：JSON
 l 是否需要用户认证：是 (关于登录授权，参见请求用户授权)
 l 请求参数：name 笔记本名称
 l 返回结果：操作成功时http状态200，并返回新创建笔记本的路径；失败时http状态500并返回错误码和错误信息
 */
-(NSData*) createNotebook:(NSString*) _notebookName
            RequesMode:(Reques_Mode)_requesMode;

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
