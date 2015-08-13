//
//  FormViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 8/12/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "FormViewController.h"
#import "LabelCell.h"
#import "TextFieldCell.h"

@interface FormViewController () {
    NSString *name;
    NSString *email;
    NSString *phone;
    UITextField *activeTextField;
}
@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

- (IBAction)dismissKeyboard:(id)sender {
    [activeTextField resignFirstResponder];
}

@end
