//
//  ASUtility.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUtility : NSObject

+ (CGFloat)getLabelHeight:(UILabel *)label;
+ (NSString*)macAddress;
+ (UINavigationController *)customizedNavigationController:(UIViewController *)viewController;

@end
