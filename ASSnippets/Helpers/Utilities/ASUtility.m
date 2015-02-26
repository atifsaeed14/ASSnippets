//
//  ASUtility.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASUtility.h"

@implementation ASUtility

+ (CGFloat)getLabelHeight:(UILabel *)label {
    /* http://stackoverflow.com/questions/22014062/get-the-nsstring-height-in-ios-7 */
    
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height + 5;
}

+ (NSString *)macAddress {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (UINavigationController *)customizedNavigationController:(UIViewController *)viewController {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationController.hidesBottomBarWhenPushed = NO;
    navController.navigationBar.backItem.hidesBackButton = NO;
    [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navController.navigationBar.shadowImage = [UIImage new];
    navController.navigationBar.translucent = NO;
    
    [navController.navigationBar setBackgroundColor:kThemeColor];
    [[UINavigationBar appearance] setBarTintColor:kTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    NSDictionary *titleDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                     shadow, NSShadowAttributeName,
                                     [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:19.0], NSFontAttributeName, nil];
    
    [navController.navigationBar setTitleTextAttributes:titleDictionary];
    //[[UINavigationBar appearance] setTitleTextAttributes:titleDictionary];
    
    return navController;
}


@end
