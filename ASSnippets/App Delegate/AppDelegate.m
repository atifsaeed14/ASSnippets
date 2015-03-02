//
//  AppDelegate.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "AppDelegate.h"
#import "ASViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ASViewController *viewController = [[ASViewController alloc] initWithNibName:@"ASViewController" bundle:nil];
    //viewController.title = kApplicationTitle;
    
    //self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController = [ASUtility customizedNavigationController:viewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /* add local notification setting */
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    
    /* Blogs */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Local Notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - Helping Method

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - Applause Configuration

- (void)applauseConfiguration {
    //    /* SignIn Link: https://help.applause.com/access/unauthenticated?return_to=https%3A%2F%2Fhelp.applause.com%2Fhc%2Fen-us%2Farticles%2F201954853-iOS-SDK-Installation-Guide&theme=hc#login */
    //    /* helping Link: https://help.applause.com/hc/en-us/articles/201954853-iOS-SDK-Installation-Guide */
    //    [[APLLogger settings] setReportOnShakeEnabled:YES]; // YES by default
    //    [[APLLogger settings] setWithUTest:NO]; // YES by default
    //    [[APLLogger settings] setScreenShotsFromGallery:NO]; // NO by default
    //    [[APLLogger settings] setDefaultUser:APLAnonymousUser];
    //    /* Starting Applause */
    //    [APLLogger startNewSessionWithApplicationKey:kApplauseKey];
    //
    //     //APLLog(@"ClassName -  Methods: parameters: %@", parameters);
}

@end
