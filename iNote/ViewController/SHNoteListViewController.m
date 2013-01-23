//
//  SHNoteListViewController.m
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import "SHNoteListViewController.h"
#import "SHNoteTableCell.h"
#import "NSString+SHNSStringForDate.h"
#import "SHFTAnimationExample.h"
#import "SHNoteWatchViewController.h"

@interface SHNoteListViewController ()
-(void) bottomMenuViewDidLoad;
-(void) showOrHideSearchBar;
-(void) pinHeaderView;
-(void) unpinHeaderView;
@end

@implementation SHNoteListViewController
@synthesize tableView,youkuMenuView;
@synthesize mySearchBar = _mySearchBar;
@synthesize myTableDataSource;
@synthesize strTableHeadString = _strTableHeadString;
@synthesize emDataSourceType   = _emDataSourceType;

- (id)init
{
    self = [super init];
    if (self) {
        _emDataSourceType = NL_ALL_NOTEBOOK;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteMM = [[SHNoteModelManager alloc] init];

    // set tableview datasourece
    if (_emDataSourceType == NL_ALL_NOTEBOOK) {
        //all notebook's notes
        myTableDataSource = [[noteMM getAllNoteFromDB] retain];
        self.strTableHeadString = @"所有笔记";
    }
    else if (_emDataSourceType == NL_SINGLE_NOTEBOOK)
    {
        //singl notebook's notes
        myTableDataSource = [[noteMM getNotesWithNotebookName:_strTableHeadString] retain];
    }
    else if (_emDataSourceType == NL_SEARCH_NOTES)
    {
        // search result
    }
    
    //add bottom Menu view
    [self bottomMenuViewDidLoad];
    
    //add search bar
    [_mySearchBar setHidden:YES];
    //tableView.tableFooterView = _mySearchBar;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];   
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self  showOrHideSearchBar];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc
{
    [noteMM release];
    
    [_mySearchBar       release];
    [myTableDataSource  release];
    [youkuMenuView      release];
    [tableView          release];
    [_strTableHeadString release];
    [super dealloc];
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
    return nil;
    return _strTableHeadString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return myTableDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SHNoteTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHNoteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier height:65] autorelease];
    }
    
    SHNote *note = [myTableDataSource objectAtIndex:indexPath.row];
    //cell set1

    [cell.labTitle  setText:note.strTitle];
    [cell.labDetail setText:note.strContent];
    [cell.labTime   setText:[NSString stringFormatDateV1:note.dateModify_time]];
    [cell.labSourceUrl setText:note.strSource];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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

    SHNote *note = [myTableDataSource objectAtIndex:indexPath.row];
     SHNoteWatchViewController *detailViewController = [[SHNoteWatchViewController alloc] initWithNote:note];
    //[detailViewController openURL:[NSURL URLWithString:@"www.baidu.com"]];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}

#pragma mark - youkuButtonMenu
- (void)bottomMenuViewDidLoad
{
    self.view.backgroundColor  = [UIColor blueColor];
    //[tableView release];
    //tableView.backgroundColor = [UIColor whiteColor];
    //tableView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 0.0f, 0.0f);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"hidemenu.png"];
    button.frame = CGRectMake(0.0,self.view.frame.size.height - 18, 320,17);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMeun:) forControlEvents:UIControlEventTouchDown];
    button.tag = 111;
    [self.view addSubview:button];
    
    youkuMenuView = [[SHBottomMenuView alloc]initWithFrame:[SHBottomMenuView getFrame]];
    youkuMenuView.delegate = self;
    [self.view addSubview:youkuMenuView];
}

- (void)showMeun:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.hidden = YES;
    [youkuMenuView  showOrHideMenu];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![youkuMenuView  getisMenuHide]&&!scrollView.decelerating)
    {
        //Hide SearchBar
        //[self unpinHeaderView];
        //[_mySearchBar setHidden:YES];
        
        [youkuMenuView  showOrHideMenu];
        [self performSelector:@selector(showMeunButton) withObject:nil afterDelay:1];
        
        
    }
}

- (void)showMeunButton
{
    UIView *button = [self.view viewWithTag:111];
    button.hidden = NO;
}

- (void) pinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.tableHeaderView = _mySearchBar;
        self.tableView.contentInset = UIEdgeInsetsMake(_mySearchBar.frame.origin.x+4, 0, 0.0f, 0.0f);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.tableHeaderView = nil;
    }];
}

-(void) bottomMenuView:(SHBottomMenuView*) botMenuView SelectButton:(MENU_KIND)_menu_kind
{
    if (_menu_kind == MK_HOME) {
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_menu_kind == MK_FIND) {
        [self showOrHideSearchBar];
    }
    if (_menu_kind == MK_INFO) {
        //[SHFTAnimationExample ControlViewMove:_mySearchBar];
    }
}

#pragma mark - SearchBar_Delegate

- (void)showOrHideSearchBar
{    
    //tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (!_mySearchBar.hidden) { //搜索条隐藏
        [SHFTAnimationExample BackInOut:kFTAnimationTop mainView:_mySearchBar inView:tableView withFade:YES duration:0.6 delegate:nil startSelector:nil stopSelector:nil];
        
        [self performSelector:@selector(unpinHeaderView) withObject:nil afterDelay:0.5];
    }
    else
    {
        [SHFTAnimationExample BackInOut:kFTAnimationTop mainView:_mySearchBar inView:tableView withFade:YES duration:0.8 delegate:nil startSelector:@selector(pinHeaderView) stopSelector:nil];
        
        [self pinHeaderView];
    }
    
    return;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                     // called when text starts editing
{
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar                        // return NO to not resign first responder
{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text  // called before text changes
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
    
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar                   // called when bookmark button pressed
{
    return;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    [searchBar resignFirstResponder];
    //[SHFTAnimationExample FadeBackgroundColorInOut:FADE_BACOLOR_INOUT_DURA mainView:searchBar delegate:nil startSelector:nil stopSelector:nil];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar // called when search results button pressed
{
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
@end
