//
//  ASViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewBorderedBar.h"

@interface ASViewController : UIViewController 

@property (nonatomic, retain) IBOutlet M13ProgressViewBorderedBar *progressViewVertical;

+ (void)isBlock:(void(^)(NSArray *posts, NSError *error))block;

@end
