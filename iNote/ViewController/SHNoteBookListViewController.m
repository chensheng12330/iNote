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

@interface SHNoteBookListViewController ()
-(void) SetMyTableDataSource:(NSMutableArray*) _arry;
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
    [myTableDataSource release];
    
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbManage = [SHDBManage sharedDBManage];  //db manage
    
    // get all notebooks in db
    [self SetMyTableDataSource:nil];  //数据分组，同步问题
    
    //notebooks
    NoteBookModelManager *notebookMM = [[NoteBookModelManager alloc] init];
    myTableDataSource = [[notebookMM pullCloudDataAndUpdateDB] retain];
    [notebookMM release];
    
    //myTableDataSource = [[dbManage getAllNoteBooks] retain];
    
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
    [cell.detailTextLabel setText:notebook.strNotes_num];
    
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

@end
