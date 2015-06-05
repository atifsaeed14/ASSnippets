//
//  ASTableViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/25/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASTableViewCell.h"
#import "ASTableViewController.h"

@interface ASTableViewController () {
    BOOL isRefreshing;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, copy) NSArray *trivia;
@property (nonatomic, strong) NSMutableArray *heights;

@end

@implementation ASTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Table View";
    
    /* Load data from text file */
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"trivia" withExtension:@"txt"];
    NSString *textFileData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *arrData = [[textFileData componentsSeparatedByString:@"\n"] mutableCopy];
    [arrData removeLastObject];
    self.trivia = arrData;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setEditing:NO animated:YES];
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    /* add refresh control */
    //http://stackoverflow.com/questions/12607015/uirefreshcontrol-ios-6-xcode
    refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl setTintColor:[UIColor colorWithRed:139.0/255.0 green:174.0/255.0 blue:214.0/255.0 alpha:1.0]];
    [refreshControl setTintColor:[UIColor redColor]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Last UPdated at 02/02/2014 05:00 PM"];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
    
    /* point to get index in tableview
    CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *selectedIndex = [self.tableView indexPathForRowAtPoint:buttonPoint]; */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh Data
- (void)refreshData:(id)sender{
    
    if(!isRefreshing) {
        isRefreshing = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [refreshControl endRefreshing];
        isRefreshing = NO;
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
    return [self.trivia count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return 1; break;
        case 1: return 15; break;
    }
   return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ASTableViewCell";
    /* method 1
    ASTableViewCell *cell = (ASTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ASTableViewCell" owner:nil options:nil] objectAtIndex:0];
    } */
    
    /* method 2 */
    ASTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ASTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.aLabel.text = [self.trivia objectAtIndex:indexPath.row];
    cell.bLabel.text = [self.trivia objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASTableViewCell *cell = (ASTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat heightCalculate = 0.0;
    
    if (![cell.aLabel.text isEqualToString: @"A"])
        heightCalculate += [ASUtility getLabelHeight:cell.aLabel]+10;
    
    if (![cell.bLabel.text isEqualToString: @"B"] || cell.bLabel.text != nil)
        heightCalculate += [ASUtility getLabelHeight:cell.bLabel];
        
    return heightCalculate;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
        cell.backgroundColor = color;
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //This function is where all the magic happens
    
    
       // http://ios-blog.co.uk/tutorials/animating-uitableview-cells/
    
        //1. Setup the CATransform3D structure
        
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
        rotation.m34 = 1.0/ -600;
    
        
        //2. Define the initial state (Before the animation)
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
        
        //3. Define the final state (After the animation) and commit the animation
        
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.8];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        
      
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1)
        return 60.0f;
    return 0.0f;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1)
        return _tableViewSectionHeaderView;
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    //Even if the method is empty you should be seeing both rearrangement icon and animation.
//}


//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    [label1array exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//    [label2array exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//    [label3array exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
