//
//  AppDelegate.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQSideMenuController.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)appDelegate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) IQSideMenuController *sideMenuController;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data, NSError *error, BOOL success))completionHandler;

@property(nonatomic, strong) id<GAITracker> tracker;

@end

