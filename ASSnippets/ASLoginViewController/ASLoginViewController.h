//
//  ASLoginViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 3/19/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "SlideNavigationController.h"

@interface ASLoginViewController : GAITrackedViewController <SlideNavigationControllerDelegate>

@property (weak, nonatomic) UIImage *screenShot;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
