//
//  SHNotebook.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-3.
//
//

#import "Header.h"
#import "SHNotebook.h"
#import "NSString+SHNSStringForDate.h"


@implementation SHNoteRelation
@synthesize strNotebookPath,strNotePath;
@end


@interface SHNotebook (prvate)
-(void)initAllNil;
@end

@implementation SHNotebook
@synthesize strPath,strNotes_num,strNotebookName;
@synthesize dateCreate_time,dateModify_time;
@synthesize isUpdate,isDelete,nTable_id;

-(void)initAllNil
{
    self.strPath         = nil;
    self.strNotes_num    = nil;
    self.strNotebookName = nil;
    self.dateCreate_time = nil;
    self.dateModify_time = nil;
    
    self.isDelete = NO;
    self.isUpdate = NO;
    self.nTable_id = -1;
    return;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initAllNil];
    }
    return self;
}

- (void)dealloc
{
    [self initAllNil];
    [super dealloc];
}

-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"strPath:%@\n strNotes_num:%@\n strNotebookName:%@\n strCreate_time:%@\n strModify_time:%@\n isUpdate:%d",self.strPath,self.strNotes_num,self.strNotebookName,self.dateCreate_time,self.dateModify_time,self.isUpdate];
    return (descripton);
}

-(void) setStrNotes_num:(NSString *)_strNotes_num
{
    if (_strNotes_num ==self.strNotes_num) return;
    
    [self.strNotes_num release];
    
    //setting
    if(![_strNotes_num stringIsNumeral]) self.strNotes_num = [[NSString alloc] initWithString:@"0"];
    
    //ok copy
    self.strNotes_num = [_strNotes_num copy];
}
#pragma mark - method

-(id) initWithJSON:(NSDictionary*) _dict
{
    self = [super init];
    if (self) {
        if (_dict==nil || [_dict count]==0) {
            [self initAllNil];
            return self;
        }
        
        //set all value
        self.strNotebookName   = [_dict objectForKey:JK_NOTEBOOK_NAME];
        self.strPath           = [_dict objectForKey:JK_NOTEBOOK_PATH];
        self.strNotes_num      = [_dict objectForKey:JK_NOTEBOOK_NOTESNUM];
        self.dateCreate_time   = [NSString ToNSDateWithNSDecimalNumber:[_dict objectForKey:JK_NOTEBOOK_CREATETIME]
                                                             precision:PRECISION_DEFAULT];
        self.dateModify_time   = [NSString ToNSDateWithNSDecimalNumber:[_dict objectForKey:JK_NOTEBOOK_MODIFYTIME]
                                                             precision:PRECISION_DEFAULT];
    }
    return self;
}
/*
 name,path,notes_num,modify_time,create_time
 */
+(NSMutableArray*) objectsForJSON:(NSArray*)_arry
{
    if(_arry==NULL || _arry.count <1) return nil;
    
    NSMutableArray *returnVal = [[NSMutableArray alloc]init];
    
    for (NSDictionary *_tempDict in _arry) {
        SHNotebook *_noteBook = [[SHNotebook alloc] initWithJSON:_tempDict];
        [returnVal addObject:_noteBook];
        [_noteBook release];
    }
    return [returnVal autorelease];
}
@end
