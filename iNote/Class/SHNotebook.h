//
//  SHNotebook.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//
//笔记本相关信息

#import <Foundation/Foundation.h>

@interface SHNotebook : NSObject


@property (nonatomic,copy) NSString *strNotebookName;  //“笔记本1”, // 笔记本的名称
@property (nonatomic,copy) NSString *strPath;          //“/4AF64012E9864C”, // 笔记本的路径
@property (nonatomic,copy) NSString *strNotes_num;     // “3” // 该笔记本中笔记的数目
@property (nonatomic,copy) NSString *strCreate_time;   //“1323310917” // 笔记本的创建时间，单位秒
@property (nonatomic,copy) NSString *strModify_time;   //“1323310949” // 笔记本的最后修改时间，单位秒
@end