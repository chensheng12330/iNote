//
//  SHNoteModelManager.m
//  iNote
//
//  Created by sherwin.chen on 12-12-26.
//
//
#import "JSON.h"
#import "Header.h"
#import "NSString+SHNSStringForDate.h"
#import "SHNoteModelManager.h"

@implementation SHNoteModelManager
-(void) pullCloudDataAndUpdateDBWith:(id)aDelegate action:(SEL)anAction
{
}

//同步请求
-(NSMutableArray*) pullCloudDataAndUpdateDB
{
    return nil;
}


-(NSMutableArray*) getAllNoteFromDB
{
    return [_dbManage getAllNotes];
}

-(BOOL) addNote:(SHNote*)_note
{
    SHArgumCheck(_note);
    return [_dbManage addNote:_note];
}

-(BOOL) deleteNoteWithName:(NSString*)_noteName
{
    SHArgumCheck(_noteName);
    //return [_dbManage deleteLogicNoteWithNOTE_FIELD:<#(NOTE_FIELD)#> Value:<#(NSString *)#>]
}
@end
