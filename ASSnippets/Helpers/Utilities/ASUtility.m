//
//  ASUtility.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASUtility.h"
#import "MBProgressHUD.h"

static MBProgressHUD *mbProgressHUD = nil;

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
    return size.height + 10;
}

+ (NSString *)macAddress {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (float)systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)iPad {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    return NO;
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
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UINavigationBar appearance]setTintColor:UIColorFromRGB(0x52b3c1)];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    NSDictionary *titleDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                     shadow, NSShadowAttributeName,
                                     [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:19.0], NSFontAttributeName, nil];
    
    [navController.navigationBar setTitleTextAttributes:titleDictionary];
    //[[UINavigationBar appearance] setTitleTextAttributes:titleDictionary];
    
    
    /* NavigationBG */
    //[navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];
  //  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];


    return navController;
}

+ (NSString *) applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (void)showMBProgressInView:(UIView *)view WithText:(NSString *)text {

    if (mbProgressHUD != nil) {
        [mbProgressHUD hide:YES];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    mbProgressHUD = [[MBProgressHUD alloc] initWithView:keyWindow];
    mbProgressHUD.labelText = @"Doing funky stuff...";

    mbProgressHUD.detailsLabelText = @"Just relax";
    mbProgressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    mbProgressHUD.dimBackground = YES;
    [mbProgressHUD show:YES];
}

+ (void)hideMBProgressView {
    [mbProgressHUD hide:YES];
}

@end
