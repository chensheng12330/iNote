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

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    //style = UITableViewStyleGrouped;
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteMM = [[SHNoteModelManager alloc] init];
    myTableDataSource = [[noteMM getAllNoteFromDB] retain];
    
    [self bottomMenuViewDidLoad];
}

-(void)dealloc
{
    [noteMM release];
    [myTableDataSource  release];
    [youkuMenuView      release];
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
    return 80;
}




- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static int i = 0;
    static NSString *CellIdentif = @"friends-cell";
    UITableViewCell *cell =(UITableViewCell *)[TableView dequeueReusableCellWithIdentifier:CellIdentif];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentif] autorelease];
    }
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
	
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    [subviews release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
    button.frame = CGRectMake(250.0, 5.0, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView  addSubview:button];
    // cell.imageView.image = [UIImage imageNamed:@"sms_share.png"];
    cell.textLabel.text = @"点击后面的图片看动画";
    i++;
    if (i == 8)
    {
        i = 0;
    }
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    SHNoteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[SHNoteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier height:66];
//    }
//    
//    SHNote *note = [myTableDataSource objectAtIndex:indexPath.row];
//    //cell set1
//
//    [cell.labTitle  setText:note.strTitle];
//    [cell.labDetail setText:note.strContent];
//    [cell.labTime   setText:[NSString stringFormatDateV1:note.dateModify_time]];
//    [cell.labSourceUrl setText:note.strSource];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}
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

#pragma mark - youkuButtonMenu
- (void)bottomMenuViewDidLoad
{
    self.view.backgroundColor  = [UIColor blueColor];
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0.0,-800,320,800)];
    tempView.backgroundColor = [UIColor grayColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20.0, 720.0, 60, 69)];
    imageview.image = [UIImage imageNamed:@"6.png"];
    [tempView addSubview:imageview];
    
    //[tableView addSubview:tempView];
    [tableView release];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 0.0f, 0.0f);
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"hidemenu.png"];
    button.frame = CGRectMake(0.0,self.view.frame.size.height - 18, 320,17);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMeun:) forControlEvents:UIControlEventTouchDown];
    button.tag = 111;
    [self.view addSubview:button];
    
    youkuMenuView = [[HHYoukuMenuView alloc]initWithFrame:[HHYoukuMenuView getFrame]];
    [self.view addSubview:youkuMenuView];
    [youkuMenuView release];

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
        [self performSelector:@selector(showMeunButton) withObject:nil afterDelay:1];
    }
}
- (void)showMeunButton
{
    UIView *button = [self.view viewWithTag:111];
    button.hidden = NO;
}

@end
