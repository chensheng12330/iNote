//
//  Header.h
//  iNote
//
//  Created by sherwin.chen on 12-12-17.
//
//

#ifndef iNote_Header_h
#define iNote_Header_h

// 有道云词典
#define kOAuthConsumerKey				@"448412811a0a2fcac811ca08b8b2c258"		//REPLACE ME
#define kOAuthConsumerSecret			@"10c6d13eec190b97248591e51b2abe0d"		//REPLACE ME

#define OAUTH_SAVE_KEY  @"YDauthData"
// end

//JK = JSON KEY

//NoteUser node with JSON
#define JK_NOTEUSER_USER            (@"user")
#define JK_NOTEUSER_TOTALSIZE       (@"total_size")
#define JK_NOTEUSER_USEDSIZE        (@"used_size")
#define JK_NOTEUSER_REGISTERTIME    (@"register_time")
#define JK_NOTEUSER_LASTLOGINTIME   (@"last_login_time")
#define JK_NOTEUSER_LASTMODIFYTIME  (@"last_modify_time")
#define JK_NOTEUSER_DEFAULTNOTEBOOK (@"default_notebook")

//Note node with JSON
#define JK_NOTEBOOK_PATH        (@"path")
#define JK_NOTEBOOK_NAME        (@"name")
#define JK_NOTEBOOK_NOTESNUM    (@"notes_num")
#define JK_NOTEBOOK_CREATETIME  (@"create_time")
#define JK_NOTEBOOK_MODIFYTIME  (@"modify_time")

//NoteBook node with JSON
#define JK_NOTE_TITLE       (@"title")
#define JK_NOTE_AUTHOR      (@"author")
#define JK_NOTE_SOURCE      (@"source")
#define JK_NOTE_SIZE        (@"size")
#define JK_NOTE_CREATE_TIME (@"create_time")
#define JK_NOTE_MODIFY_TIME (@"modify_time")
#define JK_NOTE_CONTENT     (@"content")

#endif
