//
//  PagerViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 8/6/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerViewController : UIViewController

- (IBAction)third:(id)sender;
- (IBAction)second:(id)sender;
- (IBAction)first:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
