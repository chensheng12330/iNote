//
//  SHINoteUser.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

//用户相关的信息

#import <Foundation/Foundation.h>

@interface SHNoteUser : NSObject
{
    @private
    NSString *strUsableRate;
}

@property (assign)         int      nTable_id;            //数据库表id值
@property (nonatomic,copy) NSString *strUser;             //“test@163.com”, // 用户ID
@property (nonatomic,copy) NSString *strTotal_size;       // “10293736383”, // 用户总的空间大小，单位字节
@property (nonatomic,copy) NSString *strUsed_size;        //“1024” // 用户已经使用了的空间大小，单位字节
@property (nonatomic,copy) NSDate *dateRegister_time;    //“1323310917650” // 用户注册时间，单位毫秒
@property (nonatomic,copy) NSDate *dateLast_login_time;  //“1323310949120” // 用户最后登录时间，单位毫秒
@property (nonatomic,copy) NSDate *dateLast_modify_time; //“1323310978120” // 用户最后修改时间，单位毫秒
@property (nonatomic,copy) NSString *strDefault_notebook; //“/AB384D734” // 该应用的默认笔记本


-(id) initWithJSON:(NSDictionary*) _dict;
-(NSString*) objectWithIndex:(int)_index;


@end
