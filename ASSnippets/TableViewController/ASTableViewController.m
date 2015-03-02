//
//  ASTableViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/25/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASTableViewCell.h"
#import "ASTableViewController.h"

@interface ASTableViewController ()

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
    
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.trivia count];
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
        heightCalculate += [ASUtility getLabelHeight:cell.aLabel];
    
    if (![cell.bLabel.text isEqualToString: @"B"] || cell.bLabel.text != nil)
        heightCalculate += [ASUtility getLabelHeight:cell.bLabel];
        
    return heightCalculate;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
        cell.backgroundColor = color;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _tableViewSectionHeaderView;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //Even if the method is empty you should be seeing both rearrangement icon and animation.
}


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
