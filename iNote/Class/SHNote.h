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

@property (nonatomic,copy) NSString *strTitle;      //“工作记录”, // 笔记标题
@property (nonatomic,copy) NSString *strAuthor;     //“Tom”, // 笔记作者
@property (nonatomic,copy) NSString *strSource;     //“http://note.youdao.com”, // 笔记来源URL
@property (nonatomic,copy) NSString *strNoteSize;   //“1323310917” // 笔记的创建时间，单位秒
@property (nonatomic,copy) NSString *strCreate_time;//“1323310949” // 笔记的最后修改时间，单位秒
@property (nonatomic,copy) NSString *strContent;    //“<p>This is a test note</p> // 笔记正文

@end

