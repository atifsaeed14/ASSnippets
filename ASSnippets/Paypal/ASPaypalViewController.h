//
//  ASPaypalViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 5/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface ASPaypalViewController : UIViewController

- (IBAction)pay ;

- (IBAction)parallaxSender:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) DownPicker *downPicker;

@property (strong,nonatomic) IBOutlet UITextField *dropdoweField;



/* pick view */
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPV;

@end




// https://github.com/paypal/PayPal-iOS-SDK //