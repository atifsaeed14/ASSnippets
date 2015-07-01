//
//  AppDelegate.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
// legal/#terms

#import <UIKit/UIKit.h>
#import "IQSideMenuController.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "SlideNavigationController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

+ (AppDelegate *)appDelegate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) IQSideMenuController *sideMenuController;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data, NSError *error, BOOL success))completionHandler;

@property(nonatomic, strong) id<GAITracker> tracker;

@end

//https://api.foursquare.com/v2/venues/search?ll=33.7167,73.0667&intent=checkin&oauth_token=S3CNNGZM2Q2UZIHYMEV3BTAOSCZIW5AAJGPKHDKE1DJA3DWV&v=20150605&categoryId=4bf58dd8d48988d138941735&llAcc=10

/* four*/

//https://api.foursquare.com/v2/venues/search?radius=1000&ll=33.7167,73.0667&limit=100&intent=checkin&oauth_token=S3CNNGZM2Q2UZIHYMEV3BTAOSCZIW5AAJGPKHDKE1DJA3DWV&v=20150605&categoryId=4bf58dd8d48988d138941735

// Parameter
//https://developer.foursquare.com/docs/venues/search

//specific category
//https://developer.foursquare.com/docs/venues/categories


//To create client id and client secret
//https://developer.foursquare.com/overview/auth

