//
//  SHNoteBookListViewController.m
//  iNote
//
//  Created by sherwin.chen on 12-12-11.
//
//

#import "SHNoteBookListViewController.h"
#import "NSString+SHNSStringForDate.h"
#import "SHNotebook.h"
#import "NoteBookModelManager.h"

#define TABLE_SECTION_0 @"经常使用"
#define TABLE_SECTION_1 @"最近使用"

@interface SHNoteBookListViewController ()
-(void) SetMyTableDataSource:(NSMutableArray*) _arry;

-(void) sortArrayWithNumber;
-(void) sortArrayWithModfiyTime;
@end

@implementation SHNoteBookListViewController

#pragma mark - class variable seter
-(void) SetMyTableDataSource:(NSMutableArray*) _arry
{
    if (_arry == myTableDataSource) return;
    
    [myTableDataSource release];
    myTableDataSource = [_arry retain];
    return;
}

#pragma mark - init
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    [myOftenUsed        release];
    [myMostRecentlyUsed release];
    [myTableDataSource  release];
    
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myOftenUsed       = [[NSMutableArray alloc] init];
    myMostRecentlyUsed= [[NSMutableArray alloc] init];
    myTableDataSource = [[NSMutableArray alloc] init];
    
    
    
    dbManage = [SHDBManage sharedDBManage];  //db manage
    
    // get all notebooks in db
    [self SetMyTableDataSource:nil];  //数据分组，同步问题
    
    //notebooks
    NoteBookModelManager *notebookMM = [[NoteBookModelManager alloc] init];
    myTableDataSource = [[notebookMM pullCloudDataAndUpdateDB] retain];
    //[notebookMM pullCloudDataAndUpdateDBWith:self action:@selector(didLoadBookList:)];
    //[notebookMM release];
    
    //myTableDataSource = [[dbManage getAllNoteBooks] retain];
    
    //排序
    [self sortArrayWithModfiyTime];
    
    return;
    //
    
    
    //myTableDataSource =
    
//    SHNotebook *bk = [dbManage getNoteBookInfoWithNoteBookName:@"aa"];
//    SHNotebook *notebook = [[SHNotebook alloc] init];
//    notebook.strNotebookName = @"ios devlpoment";
//    notebook.strNotes_num    = @"8";
//    notebook.strPath = @"11";
//    notebook.dateCreate_time = [NSString dateFormatString:@"2012-12-12 09:26:02"];
//    notebook.dateModify_time = [NSString dateFormatString:@"2012-12-12 09:26:02"];
//    notebook.isUpdate = YES;
    
    //BOOL b =[dbManage addNoteBook:notebook];
    //[dbManage updateNoteBook:notebook oldNoteBookName:@"aa"];
    //id pid = [dbManage getAllNoteBooks];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"testing";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [myTableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    SHNotebook *notebook = [myTableDataSource objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:notebook.strNotebookName];
    //[cell.detailTextLabel setText:notebook.strNotes_num];
    [cell.detailTextLabel setText:[NSString stringFormatDate:notebook.dateModify_time]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Datasource
-(void) didLoadBookList:(NSMutableArray*) _array
{
    [myTableDataSource release];
    
    //myTableDataSource = [NSMutableArray all
    if(_array==NULL) return;
    
    //[myTableDataSource release];
    myTableDataSource = [_array retain];
    [self.tableView reloadData];
}

#pragma mark - private_Method
-(void) sortArrayWithNumber
{
    if (myTableDataSource ==NULL || myTableDataSource.count<1) return;
    
    [myOftenUsed removeAllObjects];
    
    NSMutableArray *tempAry = [NSMutableArray arrayWithArray:myTableDataSource];
    
    for (int i=0; i<tempAry.count; i++) {
        
        SHNotebook *bigNoteBook = [tempAry lastObject];
        for (SHNotebook* notebook in tempAry) {
            if ([notebook.strNotes_num intValue]>[bigNoteBook.strNotes_num intValue]) {
                bigNoteBook = notebook;
            }
        }
        [myOftenUsed addObject:bigNoteBook];
        [tempAry delete:bigNoteBook];
        
        if(myOftenUsed.count>3) break;
    }
    
}

-(void) sortArrayWithModfiyTime
{
    if (myTableDataSource ==NULL || myTableDataSource.count<1) return;
    
    [myTableDataSource sortUsingComparator:^NSComparisonResult(SHNotebook* obj1, SHNotebook* obj2) {
    
        NSDate *date1 = obj1.dateModify_time;
        NSDate *date2 = obj2.dateModify_time;

        //return [date1 compare:date2] == NSOrderedDescending; // 升序
        return [date1 compare:date2] == NSOrderedAscending;  // 降序
    }];
}
@end
