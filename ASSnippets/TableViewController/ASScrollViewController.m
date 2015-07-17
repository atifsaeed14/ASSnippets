//
//  ASScrollViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASScrollViewController.h"
#import "ASProtocol.h"
#import "ASViewController.h"

@interface ASScrollViewController () <ASProtocol>

@property (nonatomic, strong) NSArray *indexTitlesArray;
@property (nonatomic, strong) NSMutableArray *indexTitles;
@end

@implementation ASScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataModel = [[GDIMockDataModel alloc] init];
    self.title = @"Scroll Table View";
    
    NSString *numbers = @"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15";
    self.indexTitlesArray = [numbers componentsSeparatedByString:@" "];
    
    
    self.indexTitles = [NSMutableArray new];
    
    for (int i = 1; i < [self.dataModel.dataArray count]; i++) {
        [self.indexTitles addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
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
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"TableView" style:UIBarButtonItemStyleDone target:self action:@selector(showViewController)];
    leftBarButton.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem = leftBarButton;

}

- (void)showViewController {
    
    ASViewController *vc = [ASViewController new];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
  
}

- (void)didSelectViewController:(id)VC {
    
    [VC dismissViewControllerAnimated:YES completion:^{
       
        
        
        
    }];
    
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
    //return [self.dataModel.dataArray count];
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataModel.dataArray count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexTitlesArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.indexTitlesArray indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // http://stackoverflow.com/questions/3770019/uiswitch-in-a-uitableview-cell
        UISwitch *switchView = [[UISwitch alloc] init];
           switchView.frame = CGRectMake(10, 0, switchView.frame.size.height, switchView.frame.size.width);
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
//    NSString *letter = [self.dataModel.sectionNames objectAtIndex:indexPath.section];
//    NSArray *namesByLetter = [self.dataModel.data objectForKey:letter];
//    cell.textLabel.text = [namesByLetter objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [self.dataModel.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@     ", [self.dataModel.dataArray objectAtIndex:indexPath.section]];
    return cell;
}

//self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 210, 0);
//[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
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
