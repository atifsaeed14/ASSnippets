//
//  AppDelegate.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "AppDelegate.h"
#import "ASViewController.h"
 #import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
        ASViewController *viewController = [[ASViewController alloc] initWithNibName:@"ASViewController" bundle:nil];
    //viewController.title = kApplicationTitle;
    
    //self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController = [ASUtility customizedNavigationController:viewController];
    
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    UIViewController *menuController = [UIViewController new];
    
    UINavigationController *menuNavController = [[UINavigationController alloc]
                                                 initWithRootViewController:menuController];
    [[menuController view] setBackgroundColor:[UIColor redColor]];
    
    
    UITableViewController *tableViewController = [UITableViewController new];
    UINavigationController *contentViewController = [[UINavigationController alloc]
                                                     initWithRootViewController:tableViewController];
    
    _sideMenuController = [[IQSideMenuController alloc] initWithMenuViewController:self.navigationController
                                                                               andContentViewController:contentViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /* add local notification setting */
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _sideMenuController;
    [self.window makeKeyAndVisible];
    
    /* Blogs */
//    [self sendLoginRequest:@"myUsername" password:@"password" callback:^(NSString *error, BOOL success) {
//        if (success) {
//            NSLog([@"My response back from the server after an unknown amount of time";
//                  }
//    }];
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

#pragma mark - Class method implementation

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data, NSError *error, BOOL success))completionHandler {
    
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
            
        } else {
            
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
        }
        
        // Call the completion handler with the returned data on the main thread.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(data, error, YES);
        }];
        
    }];
    
    // Resume the task.
    [task resume];
    
}

                  
// http://www.raywenderlich.com/67081/cookbook-using-nsurlsession
// http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession?rq=1

- (void) sendLoginRequest:(NSString*) username withPassword:(NSString *) password callback:(void (^)(NSError *error, BOOL success))callback
{
    // Instantiate a session configuration object.
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    // Instantiate a session object.
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
//        if (error) {
//            // Handle error
//        }
//        else {
//            callback(error, YES);
//        }
//    }];
//    
//    [dataTask resume];
//    
}

/* download image */
- (void)downloadImage {
                      //1
                      NSURL *url = [NSURL URLWithString:
                                    @"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg"];
                      
                      // 2
                      NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                                     downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                         // 3 
                                                                         UIImage *downloadedImage = [UIImage imageWithData:
                                                                                                     [NSData dataWithContentsOfURL:location]];
                                                                     }];
                      
                      // 4	
                      [downloadPhotoTask resume];
}
       
                  - (void)postRequest {
                      
                      NSURL *url = [NSURL URLWithString:@"YOUR_WEBSERVICE_URL"];
                      NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                      NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                      
                      // 2
                      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                      request.HTTPMethod = @"POST";
                      
                      // 3
                      NSDictionary *dictionary = @{@"key1": @"value1"};
                      NSError *error = nil;
                      NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                                     options:kNilOptions error:&error];
                      
                      if (!error) {
                          // 4
                          NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                                     fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                                         // Handle response here
                                                                                     }];
                          
                          // 5
                          [uploadTask resume];
                      }

                      
                      
                  }// 1
                  
@end
