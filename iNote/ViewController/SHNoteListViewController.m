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

@interface SHNoteListViewController ()
-(void)bottomMenuViewDidLoad;
@end

@implementation SHNoteListViewController
@synthesize tableView,youkuMenuView;
@synthesize mySearchBar = _mySearchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteMM = [[SHNoteModelManager alloc] init];
    myTableDataSource = [[noteMM getAllNoteFromDB] retain];
    
    [self bottomMenuViewDidLoad];
    
    //add search bar
    [_mySearchBar setHidden:YES];
    [self.view addSubview:_mySearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
        [youkuMenuView  showOrHideMenu];
        [self showOrHideSearchBar];
        [self performSelector:@selector(showMeunButton) withObject:nil afterDelay:1];
    }
}

- (void)showMeunButton
{
    UIView *button = [self.view viewWithTag:111];
    button.hidden = NO;
}
-(void) bottomMenuView:(SHBottomMenuView*) botMenuView SelectButton:(MENU_KIND)_menu_kind
{
    if (_menu_kind == MK_HOME) {
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_menu_kind == MK_FIND) {
        //[self.view addSubview:_mySearchBar];
        [self showOrHideSearchBar];
    }
}

#pragma mark - SearchBar_Delegate

- (void)showOrHideSearchBar
{
    [UIView beginAnimations:@"present-countdown" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:_mySearchBar];
    //[UIView setAnimationDidStopSelector:@selector(hideMenuAnimationStop)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_mySearchBar setHidden:!_mySearchBar.hidden];
    [UIView commitAnimations];
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
    
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar // called when search results button pressed
{
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
@end
