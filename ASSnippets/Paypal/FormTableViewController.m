//
//  FormTableViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 8/12/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "FormTableViewController.h"
#import "LabelCell.h"
#import "TextFieldCell.h"

@interface FormTableViewController ()

@end

@implementation FormTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"LabelCell";
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[LabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        switch (indexPath.section) {
                
            case 0:
                cell.titleLabel.text = @"Name:";
                break;
                
            case 1:
                cell.titleLabel.text = @"Email:";
                break;
                
            case 2:
                cell.titleLabel.text = @"Phone:";
                break;
                
            case 3:
                cell.titleLabel.text = @"Blood Group:";
                break;
                
            case 4:
                cell.titleLabel.text = @"Address:";
                break;
                
            case 5:
                cell.titleLabel.text = @"Date:";
                break;
                
            default:
                break;
        }
        
        //[self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            return 35;
            break;
            
        case 1:
            return 40;
            break;
            
        default:
            break;
    }
    return 0.0;
}

@end
