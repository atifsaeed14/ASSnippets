//
//  AppDelegate.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "NSDate+Helper.h"
#import "AppDelegate.h"
#import "ASViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSDate+TimeAgo.h"
#import <EventKit/EventKit.h>
#import "GMEventsManager.h"
#import "SlideNavigationController.h"
#import "ASLoginViewController.h"
#import "PayPalMobile.h"
#import "INTULocationManager.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "ASBookmarkViewController.h"

// id UA-62673521-1 UA-XXXXX-Y

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-62673521-1";

@interface AppDelegate ()

// Used for sending Google Analytics traffic in the background.
@property(nonatomic, assign) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);

@end

@implementation AppDelegate




typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}


#pragma mark -
#pragma mark UINavigationControllerDelegate

//| ----------------------------------------------------------------------------
//  Force the navigation controller to defer to the topViewController for
//  its supportedInterfaceOrientations.  This allows some of the demos
//  to rotate into landscape while keeping others in portrait.
//
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return navigationController.topViewController.supportedInterfaceOrientations;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ASBookmarkViewController new]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    

    
    /*
     INTULocationManager *locMgr = [INTULocationManager sharedInstance];
     [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
     timeout:10.0
     delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
     block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
     if (status == INTULocationStatusSuccess) {
     // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
     
     NSString *str = [NSString stringWithFormat:@"%@", currentLocation];
     
     NSLog(@"%@",str);
     
     
     
     // CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
     
     [self getAddressFromLocation:currentLocation complationBlock:^(NSString * address) {
     if(address) {
     NSLog(@"%@ address",address);
     
     }
     }];
     
     
     // currentLocation contains the device's current location.
     }
     else if (status == INTULocationStatusTimedOut) {
     // Wasn't able to locate the user with the requested accuracy within the timeout interval.
     // However, currentLocation contains the best location available (if any) as of right now,
     // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
     }
     else {
     // An error occurred, more info is available by looking at the specific status returned.
     }
     }];
     
     
     */
    
    /*   [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
     PayPalEnvironmentSandbox : @"AZVTLykplV7oQC38jFqe_-iZ2BF8BHmoKIMtigzpIFjkaSvDXWHtfnpLIAJ6PXau1sZH3d30naBpO8UR"}];
     
     
     if (0) {
     
     //ASViewController *leftMenu = [[ASViewController alloc] initWithNibName:@"ASViewController" bundle:nil];;
     ASLoginViewController *login = [ASLoginViewController new];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = nav;
     [self.window makeKeyAndVisible];
     
     }else if(00) {
     
     ASViewController *leftMenu = [[ASViewController alloc] initWithNibName:@"ASViewController" bundle:nil];;
     
     ASLoginViewController *login = [ASLoginViewController new];
     SlideNavigationController  *slide = [[SlideNavigationController alloc] initWithRootViewController:login];
     
     [SlideNavigationController sharedInstance].leftMenu = leftMenu;
     [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
     
     
     // Creating a custom bar button for right menu
     UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [button setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
     [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Closed %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Opened %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Revealed %@", menu);
     }];
     
     
     
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = slide;
     [self.window makeKeyAndVisible];
     
     } else {
     
     
     
     
     [self currentDateInDifferntFormate];
     ///[self calendarEvent];
     [self googleAnalyticsConfiguration];
     
     /* app works in background *
     [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
     
     // <>'/& character that effect web service request replace these
     NSString *str = @"@ %$*ab&c";
     str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
     
     NSString *name2escaped = @"Nu\\u0161a Florjan\\u010di\\u010d &quot; &amp; &apos; &lt; &gt; ";
     NSString *name2 = [NSString
     stringWithCString:[name2escaped cStringUsingEncoding:NSUTF8StringEncoding]
     encoding:NSNonLossyASCIIStringEncoding];
     NSLog(@"name = %@", name2);
     
     NSDate *someTime = [NSDate date];
     
     if ([someTime isInPast]) {
     NSLog(@"It's in the past!");
     } else {
     NSLog(@"It is yet to come!");
     }
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setInteger:9001 forKey:@"HighScore"];
     [defaults synchronize];
     
     
     NSUserDefaults *defaultss = [NSUserDefaults standardUserDefaults];
     NSInteger theHighScore = [defaultss integerForKey:@"HighScore"];
     
     
     NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
     NSString *ago = [date timeAgo];
     NSLog(@"Output is: \"%@\"", ago);
     
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
     
     /* add local notification setting *
     UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
     UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
     [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
     
     
     int n = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
     
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = _sideMenuController;
     [self.window makeKeyAndVisible];
     
     /* json format *
     // http://labs.omniti.com/labs/jsend
     
     [self JSONData];
     
     
     }
     
     */
    
    /* Blogs */
    //    [self sendLoginRequest:@"myUsername" password:@"password" callback:^(NSString *error, BOOL success) {
    //        if (success) {
    //            NSLog([@"My response back from the server after an unknown amount of time";
    //                  }
    //    }];
    
    
    
    return YES;
}


- (void)currentDateInDifferntFormate {
    
    /* http://stackoverflow.com/questions/16194820/converting-a-gregorian-date-string-to-islamic-date-gives-correct-incorrect-res */
    
    // Create a Gregorian Calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Set up components of a Gregorian date
    NSDateComponents *gregorianComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSLog(@"[In Gregorian calendar ->] Day: %ld, Month: %ld, Year:%ld",
          (long)[gregorianComponents day],
          (long)[gregorianComponents month],
          (long)[gregorianComponents year]);
    
    
    gregorianComponents.day = [gregorianComponents day];
    gregorianComponents.month = [gregorianComponents month];
    gregorianComponents.year = [gregorianComponents year];
    
    // Create the date
    NSDate *date = [gregorianCalendar dateFromComponents:gregorianComponents];
    
    
    
    // Then create an Islamic calendar
    NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicCivil];
    
    // And grab those date components for the same date
    NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay |
                                                                   NSCalendarUnitMonth |
                                                                   NSCalendarUnitYear)
                                                         fromDate:date];
    
    
    NSLog(@"[In Hijri calendar ->] Day: %ld, Month: %ld, Year:%ld",
          (long)[hijriComponents day],
          (long)[hijriComponents month],
          (long)[hijriComponents year]);
    
    
    // Then create an Islamic calendar
    NSCalendar *civilCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamic];
    
    // And grab those date components for the same date
    NSDateComponents *civilComponents = [civilCalendar components:(NSCalendarUnitDay |
                                                                   NSCalendarUnitMonth |
                                                                   NSCalendarUnitYear)
                                                         fromDate:date];
    
    
    NSLog(@"[In Hijri calendar ->] Day: %ld, Month: %ld, Year:%ld",
          (long)[civilComponents day],
          (long)[civilComponents month],
          (long)[civilComponents year]);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:hijriCalendar];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    //[formatter setTimeStyle:kCFDateFormatterNoStyle];
    
    NSString *formattedDate = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"%@", formattedDate);
    
    
    [formatter setCalendar:civilCalendar];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    //[formatter setTimeStyle:kCFDateFormatterNoStyle];
    
    NSString *formattedDateHi = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", formattedDateHi);
    
    
}

- (void)calendarEvent {
    
    
    [[GMEventsManager sharedManager] fetchEvents];
    
    
    [[GMEventsManager sharedManager]requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            
            NSDate *startDate = [NSDate date];
            NSDate *endDate = [startDate dateByAddingTimeInterval:24 * 60 * 60];
            NSString *title = [NSString stringWithFormat:@"Test %@", [NSDate date]];
            
            [[GMEventsManager sharedManager] addEventWithTitle:title startDate:startDate endDate:endDate];
            
        } else {
            NSLog(@"Access to the event store is restricted / denied.");
        }
    }];
    
    
    
    /* http://web.archive.org/web/20120730005439/http://blog.blackwhale.at/?p=336
     
     //Create the first status image and the indicator view
     UIImage *statusImage = [UIImage imageNamed:@"status1.png"];
     UIImageView *activityImageView = [[UIImageView alloc]
     initWithImage:statusImage];
     
     
     //Add more images which will be used for the animation
     activityImageView.animationImages = [NSArray arrayWithObjects:
     [UIImage imageNamed:@"status1.png"],
     [UIImage imageNamed:@"status2.png"],
     [UIImage imageNamed:@"status3.png"],
     [UIImage imageNamed:@"status4.png"],
     [UIImage imageNamed:@"status5.png"],
     [UIImage imageNamed:@"status6.png"],
     [UIImage imageNamed:@"status7.png"],
     [UIImage imageNamed:@"status8.png"],
     nil];
     
     
     //Set the duration of the animation (play with it
     //until it looks nice for you)
     activityImageView.animationDuration = 0.8;
     
     
     //Position the activity image view somewhere in
     //the middle of your current view
     activityImageView.frame = CGRectMake(
     self.view.frame.size.width/2
     -statusImage.size.width/2,
     self.view.frame.size.height/2
     -statusImage.size.height/2,
     statusImage.size.width,
     statusImage.size.height);
     
     //Start the animation
     [activityImageView startAnimating];
     
     
     //Add your custom activity indicator to your current view
     [self.view addSubview:activityImageView]; */
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // We'll try to dispatch any hits queued for dispatch as the app goes into the background.
    //[self sendHitsInBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// In case the app was sent into the background when there was no network connection, we will use
// the background data fetching mechanism to send any pending Google Analytics data.  Note that
// this app has turned on background data fetching in the capabilities section of the project.
//-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [self sendHitsInBackground];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

// This method sends hits in the background until either we're told to stop background processing,
// we run into an error, or we run out of hits.  We use this to send any pending Google Analytics
// data since the app won't get a chance once it's in the background.
//- (void)sendHitsInBackground {
//    self.okToWait = YES;
//    __weak AppDelegate *weakSelf = self;
//    __block UIBackgroundTaskIdentifier backgroundTaskId =
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        weakSelf.okToWait = NO;
//    }];
//
//    if (backgroundTaskId == UIBackgroundTaskInvalid) {
//        return;
//    }
//
//    self.dispatchHandler = ^(GAIDispatchResult result) {
//        // If the last dispatch succeeded, and we're still OK to stay in the background then kick off
//        // again.
//        if (result == kGAIDispatchGood && weakSelf.okToWait ) {
//            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
//        } else {
//            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
//        }
//    };
//    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
//}


- (void)JSONData {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath];
    
    NSError *errore =  nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errore];
    
    
    NSArray *postsFromResponse = [jsonDic valueForKeyPath:@"data"];
    NSString *responseSTR = [jsonDic valueForKey:@"status"];
    
    if ([[responseSTR lowercaseString]  isEqual: @"success"]) {
        NSLog(@"Success");
    }
    
    NSError *jsonError;
    NSData *objectData = [@"{\"2\":\"3\"}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&jsonError];
    
    
    NSDictionary *dictionary =
    @{
      @"First Name" : @"Anthony",
      @"Last Name" : @"Robbins",
      @"Age" : @51,
      @"Children" : @[
              @"Anthony's Son 1",
              @"Anthony's Daughter 1",
              @"Anthony's Son 2",
              @"Anthony's Son 3",
              @"Anthony's Daughter 2",
              ],
      };
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        NSLog(@"Successfully serialized the dictionary into data.");
        
        /* Now try to deserialize the JSON object into a dictionary */
        error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingAllowFragments
                         error:&error];
        
        if (jsonObject != nil && error == nil){
            
            NSLog(@"Successfully deserialized...");
            
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *deserializedDictionary = jsonObject;
                NSLog(@"Deserialized JSON Dictionary = %@",
                      deserializedDictionary);
                
            }
            else if ([jsonObject isKindOfClass:[NSArray class]]){
                
                NSArray *deserializedArray = (NSArray *)jsonObject;
                NSLog(@"Deserialized JSON Array = %@", deserializedArray);
                
            }
            else {
                /* Some other object was returned. We don't know how to
                 deal with this situation as the deserializer only
                 returns dictionaries or arrays */
            }
        }
        else if (error != nil){
            NSLog(@"An error happened while deserializing the JSON data.");
        }
        
    }
    else if ([jsonData length] == 0 && error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
    
    
}

#pragma mark - Local Notification

//   http://www.ios-developer.net/iphone-ipad-programmer/development/local-notifications/creating-local-notifications
//  http://stackoverflow.com/questions/8682051/ios-application-how-to-clear-notifications
// http://stackoverflow.com/questions/11137066/update-fire-date-for-local-notification-and-cancel-previous-notification?lq=1
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    if (state == UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive");
    }
    else if(state == UIApplicationStateInactive){
        NSLog(@"UIApplicationStateInActive");
    }
    
}

#pragma mark - Helping Method

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


// + (SLRequest *)requestForServiceType:(NSString *)serviceType requestMethod:(SLRequestMethod)requestMethod URL:(NSURL *)url parameters:(NSDictionary *)parameters;


#pragma mark - Google Analytics Configuration


- (void)googleAnalyticsConfiguration {
    // Override point for customization after application launch.
    
    // 1 - Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    
    
    // 3 -  Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 10;
    
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    // **** REPLACE UA-42269122-1 with your own GA Tracking Id **** //
    // 4 Create tracker instance.
    //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    /********** Sampling Rate **********/
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    //    [[GAI sharedInstance] set:kGAIAppVersion value:version];
    //    [tracker set:kGAISampleRate value:@"50.0"]; // sampling rate of 50%
    
    
    
}

- (void)googleAnalyticsConfigurationextra {
    
    //    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    //    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    //
    // User must be able to opt out of tracking
    //[GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    
    // If your app runs for long periods of time in the foreground, you might consider turning
    // on periodic dispatching.  This app doesn't, so it'll dispatch all traffic when it goes
    // into the background instead.  If you wish to dispatch periodically, we recommend a 120
    // second dispatch interval.
    // [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].dispatchInterval = -1;
    
    /* send uncaught exceptions to Google Analytics. */
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *trackerName = [NSString stringWithFormat:@"%@ (%@)",[infoDictionary objectForKey:@"CFBundleDisplayName"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    
    self.tracker = [[GAI sharedInstance] trackerWithName:@"CuteAnimals"
                                              trackingId:kTrackingId];
    
    
    
    
    
    
    
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




+ (void)postToURL:(NSURL *)url from:(NSDictionary *)dictionary withCompletionHandler:(void(^)(NSData *data, NSError *error, BOOL success))completionHandler {
    
}

// http://www.raywenderlich.com/67081/cookbook-using-nsurlsession
// http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession?rq=1





+ (void)sendRequestFromURL:(NSURL *)url andParameters:(NSDictionary *)dictionary withCompletionHandler:(void(^)(NSData *data, NSError *error, BOOL success))completionHandler {
    
    NSURL *urll = [NSURL URLWithString:@"YOUR_WEBSERVICE_URL"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 2
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 3
    NSDictionary *dictionaryd = @{@"key1": @"value1"};
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    
    // 4
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            // Handle response here
            
        }];
        
        // 5
        [uploadTask resume];
    }
    
}

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
    NSURL *url = [NSURL URLWithString: @"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg"];
    
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



// pinch gesture
//http://stackoverflow.com/questions/5150642/max-min-scale-of-pinch-zoom-in-uipinchgesturerecognizer-iphone-ios



@end
