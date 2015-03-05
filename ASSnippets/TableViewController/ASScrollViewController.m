//
//  ASScrollViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASScrollViewController.h"

@interface ASScrollViewController ()

@end

@implementation ASScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataModel = [[GDIMockDataModel alloc] init];
    self.title = @"Scroll Table View";
    
    
     UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sideMenu)];
    self.navigationItem.leftBarButtonItem = shareItem;
    
    //Add a top swipe gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    //Add a right swipe gesture recognizer
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.scrollView addGestureRecognizer:recognizer];
    
}

- (void)sideMenu {
    [[AppDelegate appDelegate].sideMenuController toggleMenuAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.dataModel.sectionNames.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSString *letter = [self.dataModel.sectionNames objectAtIndex:section];
//    NSArray *namesByLetter = [self.dataModel.data objectForKey:letter];
//    return namesByLetter.count;
    return [self.dataModel.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
//    NSString *letter = [self.dataModel.sectionNames objectAtIndex:indexPath.section];
//    NSArray *namesByLetter = [self.dataModel.data objectForKey:letter];
//    cell.textLabel.text = [namesByLetter objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [self.dataModel.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %@",(long)indexPath.row,[self.dataModel.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - ScrollView

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
   // CGFloat velocity = [(UISwipeGestureRecognizer *)gestureRecognizer velocity];
    
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //Check if index path is valid
    if(indexPath)
    {
        //Get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //Update the cell or model
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //same code for getting UITableViewCell like before
}

- (void) handleSwipes:(UISwipeGestureRecognizer *)paramSender{
    if (paramSender.direction & UISwipeGestureRecognizerDirectionDown){ NSLog(@"Swiped Down.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"Swiped Left.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionRight){ NSLog(@"Swiped Right.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionUp){
        NSLog(@"Swiped Up.");
    }
}

@end
