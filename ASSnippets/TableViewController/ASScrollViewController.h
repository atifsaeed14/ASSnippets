//
//  ASScrollViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIMockDataModel.h"

@interface ASScrollViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *scrollView;

/*!
 * Mock data source for the table view and index bar.
 */
@property (strong, nonatomic) GDIMockDataModel *dataModel;

@end
