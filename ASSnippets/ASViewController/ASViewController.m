//
//  ASViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASViewController.h"
#import "ASCompassViewController.h"
#import "ASTableViewController.h"
#import "ASNavigationHeader.h"

@interface ASViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ASNavigationHeader *navigationHeader;

@end

@implementation ASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigation Controller

- (void)setUpNavigationBar {
    
    self.navigationHeader = [[ASNavigationHeader alloc] initWithFrame:CGRectZero];
    self.navigationHeader.titleLable.text = kApplicationTitle;
    [self.navigationItem setTitleView:self.navigationHeader];
    
    UIImage *menuImage = [[UIImage imageNamed:@"icn_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"LeftBTN" style:UIBarButtonItemStyleDone target:self action:nil];
    leftBarButton.tintColor = kThemeColor;
    
    NSArray *leftButtonItems = @[menuBarButton, leftBarButton];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];

    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setTitle:@"Today's" forState:UIControlStateNormal];
    [todayButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [todayButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [todayButton setFrame:CGRectMake(0, 0, 60, 30)];
    [todayButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *todayBarButton =[[UIBarButtonItem alloc] initWithCustomView:todayButton];
    todayBarButton.tintColor = kThemeColor;
    
    NSArray *actionButtonItems = @[shareItem, todayBarButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kASActionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
            
        case kASActionTableView:
            cell.textLabel.text = @"TableView";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kASActionCompass:
            cell.textLabel.text = @"Compass";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            cell.textLabel.text = @"N/A";
            break;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case kASActionTableView:
            [self showTableViewViewController];
            break;
            
        case kASActionCompass:
            [self showCompassViewController];
            break;
            
        default:
            break;
    }
}


#pragma mark - Action Methods

- (void)showTableViewViewController {
    ASTableViewController *tableViewController = [ASTableViewController new];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)showCompassViewController {
    ASCompassViewController *compassViewController = [ASCompassViewController new];
    [self.navigationController pushViewController:compassViewController animated:YES];
}


@end
