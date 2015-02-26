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

@interface ASViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
