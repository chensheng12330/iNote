//
//  SHSynSettingViewController.m
//  iNote
//
//  Created by sherwin.chen on 12-12-10.
//
//

#import "SHSynSettingViewController.h"

@interface SHSynSettingViewController ()

@end

@implementation SHSynSettingViewController
@synthesize myCell1 = _myCell1;
@synthesize myCell2 = _myCell2;
@synthesize myCell3 = _myCell3;
@synthesize myCell4 = _myCell4;
@synthesize myCell5 = _myCell5;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //polymerize all cell
    arCells = [[NSArray alloc] initWithObjects:_myCell1,_myCell2,_myCell3,_myCell4,_myCell5, nil];
    
    [self.navigationItem setTitle:@"同步设置"];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    @try {
        cell = [arCells objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"CRASH: %@", exception);
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dealloc {
    [_myCell1 release];
    [_myCell2 release];
    [_myCell3 release];
    [_myCell4 release];
    [_myCell5 release];
    
    [arCells  release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyCell1:nil];
    [self setMyCell2:nil];
    [self setMyCell3:nil];
    [self setMyCell4:nil];
    [self setMyCell5:nil];
    [super viewDidUnload];
}
@end
