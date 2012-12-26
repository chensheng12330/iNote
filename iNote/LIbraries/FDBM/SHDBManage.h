//
//  SHDBManage.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-7.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "SHNoteUser.h"
#import "SHNotebook.h"
#import "SHNote.h"
/*
 class property: Singleton model
*/

@interface SHDBManage : NSObject
{
@private
    FMDatabase *db;
}

@property(readonly) NSString *dbErrorInfo;
//***************************************
//object init Method

/*
 初使化对象唯一方法
 */
+(SHDBManage*) sharedDBManage;

//********///
// NoteUser 
// get note user all info
-(SHNoteUser*) getNoteUserInfo;

// set note user info with SHNoteUser object [id user unique]
-(BOOL) setNoteUserDataToDB:(SHNoteUser*)_noteUser;

//delete Note User Data
-(BOOL) deleteNoteUserForDB;
////////////

//*********////
//Notebook info
//get notebook of all
//array for SHNoteBook class
-(NSMutableArray*) getAllNoteBooks;

//synchronization notebook table
-(void) synchronizationNoteBooK:(NSArray*) _arryData;

//notebook edit
-(BOOL) addNoteBook:(SHNotebook*) _noteBook;
-(BOOL) updateNoteBook:(SHNotebook*)_newNoteBook oldNoteBookName:(NSString*) _stringName;
-(BOOL) deleteNotebookWithName:(NSString*)_stringName;

//get notebook count with notebook name;
-(int) getNoteBookCountWithName:(NSString *)_stringName;
-(SHNotebook*) getNoteBookInfoWithNoteBookName:(NSString*) _stringName;
//*************End/////

//*************////
//Note info
-(BOOL) addNote:(SHNote*) _note;
-(BOOL) updateNote;
-(BOOL) deleteNote;
@end
