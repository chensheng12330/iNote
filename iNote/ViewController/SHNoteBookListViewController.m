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
#import "SHNoteListViewController.h"

#define TABLE_SECTION_0 @"经常使用"
#define TABLE_SECTION_1 @"最近使用"

@interface SHNoteBookListViewController ()
//-(void) SetMyTableDataSource:(NSMutableArray*) _arry;

-(void)sortArrayWithOftenUsedAndMostRecent;

-(void) backToMainView:(UIBarButtonItem*) sender;
-(void) addNotebookEvent:(UIBarButtonItem*) sender;
@end

@implementation SHNoteBookListViewController
//@synthesize tableView;

#pragma mark - class variable seter

#pragma mark - init
- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) dealloc
{
    [notebookMM         release];
    [myOftenUsed        release];
    [myMostRecentlyUsed release];
    [myTableDataSource  release];
    
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    //本地载入数据
    [super viewDidLoad];
    
    // get all notebooks in db
    
    //notebooks
    notebookMM = [[SHNoteBookModelManager alloc] init];
    
    myTableDataSource = [[notebookMM getAllNotebookFromDB] retain];
    
    //分组排序
    [self sortArrayWithOftenUsedAndMostRecent];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //int a = self.tableView.style;
    //self.tableView sets
    [self.editButtonItem setTitle:@"编辑"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:@"笔记本"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table Method
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        //设置导航左键 add
        [self.editButtonItem setTitle:@"保存"];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNotebookEvent:)] autorelease];
    }
    else
    {
        //设置导航左键为 原来
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //int c1 = myMostRecentlyUsed.count>0;
    //int c2 = myOftenUsed.count>0;
    return 2;//(c1+c2);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0?TABLE_SECTION_0:TABLE_SECTION_1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return section==0?myOftenUsed.count:myMostRecentlyUsed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    SHNotebook *notebook = nil;
    indexPath.section==0? (notebook= [myOftenUsed objectAtIndex:indexPath.row]):(notebook = [myMostRecentlyUsed objectAtIndex:indexPath.row]);
    //SHNotebook *notebook = [myTableDataSource objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:notebook.strNotebookName];
    //cell.backgroundColor = [UIColor grayColor];
    [cell.detailTextLabel setText:notebook.strNotes_num];
    //[cell.detailTextLabel setText:[NSString stringFormatDate:notebook.dateModify_time]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        delIndexPath = [indexPath retain];
        delAlertView  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                   message:@"该笔记本内所有笔记将会被删除!\n确认删除?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"删除",nil];
        [delAlertView show];
        [delAlertView release];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) { //cancal
        
    }
    else if (buttonIndex==1) //ok
    {
        //db delete
        [notebookMM deleteNotebookWithName:[self.tableView cellForRowAtIndexPath:delIndexPath].textLabel.text];
        
        //table datasource delete
        delIndexPath.section==0?[myOftenUsed removeObjectAtIndex:delIndexPath.row]:[myMostRecentlyUsed removeObjectAtIndex:delIndexPath.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delIndexPath]
                              withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    [delIndexPath release];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //get notebook info
    NSString *strNotebookName = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    //push notelist viewcontroller
    
    SHNoteListViewController *notelistViewControl = [[SHNoteListViewController alloc] init];
    [notelistViewControl setEmDataSourceType:NL_SINGLE_NOTEBOOK];
    [notelistViewControl setStrTableHeadString:strNotebookName];
    [self.navigationController pushViewController:notelistViewControl animated:YES];
    
    //release
    [notelistViewControl release];
    return;
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
-(void) sortArrayWithOftenUsedAndMostRecent
{
    assert((myTableDataSource &&myTableDataSource.count>0));
    
    if (myTableDataSource ==NULL || myTableDataSource.count<1) return;
    
    myOftenUsed = [[NSMutableArray alloc] init];
    
    myMostRecentlyUsed = [[NSMutableArray alloc] initWithArray:myTableDataSource];
    
    for (int i=0; i<myMostRecentlyUsed.count; i++) {
        
        SHNotebook *bigNoteBook = [myMostRecentlyUsed lastObject];
        for (SHNotebook* notebook in myMostRecentlyUsed) {
            if ([notebook.strNotes_num intValue]>[bigNoteBook.strNotes_num intValue]) {
                bigNoteBook = notebook;
            }
        }
        [myOftenUsed addObject:bigNoteBook];
        [myMostRecentlyUsed removeObject:bigNoteBook];
        //[myMostRecentlyUsed delete:bigNoteBook];
        
        if(myOftenUsed.count>3) break;
    }
    
    [myMostRecentlyUsed sortUsingComparator:^NSComparisonResult(SHNotebook* obj1, SHNotebook* obj2) {
        
        NSDate *date1 = obj1.dateModify_time;
        NSDate *date2 = obj2.dateModify_time;
        
        //return [date1 compare:date2] == NSOrderedDescending; // 升序
        return [date1 compare:date2] == NSOrderedAscending;  // 降序
    }];
}

#pragma mark -Table_Edit_Add
-(void) backToMainView:(UIBarButtonItem*) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addNotebookEvent:(UIBarButtonItem*) sender
{
    // add notebook process
    SHAddNotebookViewController *addNotebooControl = [[SHAddNotebookViewController alloc] init];
    addNotebooControl.delegate = self;
    [self presentModalViewController:addNotebooControl animated:YES];
    [addNotebooControl release];
    
    //[self.navigationController mo]
}

-(void) viewControl:(SHAddNotebookViewController*)_viewControl
    getNotebookName:(NSString*)_notebookName
{
    //build notebook info
    SHNotebook *fNotebook = [[SHNotebook alloc]init];
    fNotebook.strPath         = @"";
    fNotebook.strNotes_num    = @"0";
    fNotebook.strNotebookName = _notebookName;
    NSDate *nowDate= [NSDate date];
    fNotebook.dateCreate_time = nowDate;
    fNotebook.dateModify_time = nowDate;
    
    //add to table source
    [myMostRecentlyUsed insertObject:fNotebook atIndex:0];
    //[myMostRecentlyUsed addObject:fNotebook];  //分组数据
    [myTableDataSource addObject:fNotebook]; //总数据

    
    //add data to db
    [notebookMM addNotebook:fNotebook];
    [fNotebook release];
    [self.tableView reloadData];
}
@end
