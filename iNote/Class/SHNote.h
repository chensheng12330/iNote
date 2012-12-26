//
//  SHNote.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

//笔记相关的信息

#import <Foundation/Foundation.h>

@interface SHNote : NSObject

@property (assign) BOOL    isDelete;                //是否删除
@property (nonatomic,copy) NSString *strNotebookName;  //“笔记本1”, // 笔记本的名称
@property (nonatomic,copy) NSString *strPath;          //“/4AF64012E9864C”, // 笔记的路径

@property (nonatomic,copy) NSString *strTitle;      //“工作记录”, // 笔记标题
@property (nonatomic,copy) NSString *strAuthor;     //“Tom”, // 笔记作者
@property (nonatomic,copy) NSString *strSource;     //“http://note.youdao.com”, // 笔记来源URL
@property (nonatomic,copy) NSString *strNoteSize;   // 笔记大小，包括笔记正文及附件
@property (nonatomic,copy) NSString *strModify_time;//“1323310917” // 笔记的创建时间，单位秒
@property (nonatomic,copy) NSString *strCreate_time;//“1323310949” // 笔记的最后修改时间，单位秒
@property (nonatomic,copy) NSString *strContent;    //“<p>This is a test note</p> // 笔记正文

@end

