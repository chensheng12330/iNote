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

@property (assign) BOOL    isUpdate;                   //是否更新
@property (assign) BOOL    isDelete;                   //是否删除
@property (assign) int     nTable_id;                  //数据库表id值
@property (nonatomic,copy) NSString *strNotebookName;  //“笔记本1”, // 笔记本的名称
@property (nonatomic,copy) NSString *strPath;          //“/4AF64012E9864C”, // 笔记本的路径
@property (nonatomic,copy) NSString *strNotes_num;     // “3” // 该笔记本中笔记的数目
@property (nonatomic,copy) NSDate *dateCreate_time;    //“1323310917” // 笔记本的创建时间，单位秒
@property (nonatomic,copy) NSDate *dateModify_time;    //“1323310949” // 笔记本的最后修改时间，单位秒

-(id) initWithJSON:(NSDictionary*) _dict;
+(NSMutableArray*) objectsForJSON:(NSArray*)_arry;
@end
