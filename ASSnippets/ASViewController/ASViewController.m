//
//  ASViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASViewController.h"
#import "ASCompassViewController.h"
#import "ASTableViewController.h"
#import "ASNavigationHeader.h"
#import "ASBookmarkViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ASViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UILabel *myCounterLabel;
- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ASNavigationHeader *navigationHeader;

@end

@implementation ASViewController

int hours, minutes, seconds;
int secondsLeft;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavigationBar];
    
    /* add local notification */
    [self addNotification];

    /* progress view */
    _progressViewVertical.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
    [_progressViewVertical setProgress:.44 animated:NO];
    _progressViewVertical.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
    _progressViewVertical.successColor = [UIColor redColor];
    [_progressViewVertical performAction:M13ProgressViewActionSuccess animated:NO];
    
    /* counter */
    secondsLeft = 16925;
    [self countdownTimer];
    
    
    /* get locaiton for apple api*/
    
    //http://stackoverflow.com/questions/14950896/showing-nearby-restaurants-in-mkmap-view
    //http://jeffreysambells.com/2013/01/28/mklocalsearch-example
    
    // http://nshipster.com/mklocalsearch/
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.naturalLanguageQuery = @"Mosque";
    request.naturalLanguageQuery = @"restuarts";
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.7167, 73.0667);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1500, 1500);
    request.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSLog(@"%@", response.mapItems);
        NSLog(@"Error : %@", error);
    }];

    /* get near by location from google */
    //  http://stackoverflow.com/questions/14950896/showing-nearby-restaurants-in-mkmap-view
    //  https://developers.google.com/places/documentation/search#PlaceSearchRequests
    //     https://maps.googleapis.com/maps/api/place/search/json?location=10.009890,76.316013&radius=5000&types=restaurant&sensor=false&key=AIzaSyCd_coP8f7TbdlcVavbgUku2S81pgAz_bs&pagetoken=CmRTAAAAIrTPdzdJzqNYSCw7p4D4ThGHh0srcyUpZ9LfvXRJJA1wR-DOsiXZ07V9TzdTu9HJdCwq2kRFIftm_FCzo4ofboAN95CjpX-6e41G_oXYQph5YIrP6HzM2hzrMw2G7phhEhDx6vzp9KlRo15w4Knd8L3QGhQBlsszX43YRC6Q-NbhFDcjDvu_eQ



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigation Controller

- (void)setUpNavigationBar {
    
    self.navigationHeader = [[ASNavigationHeader alloc] initWithFrame:CGRectZero];
    self.navigationHeader.titleLable.text = kApplicationTitle;
    [self.navigationItem setTitleView:self.navigationHeader];
    
    UIImage *menuImage = [[UIImage imageNamed:@"icn_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"LeftBTN" style:UIBarButtonItemStyleDone target:self action:nil];
    leftBarButton.tintColor = kThemeColor;
    
    NSArray *leftButtonItems = @[menuBarButton, leftBarButton];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setTitle:@"Today's" forState:UIControlStateNormal];
    [todayButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [todayButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [todayButton setFrame:CGRectMake(0, 0, 60, 30)];
    [todayButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *todayBarButton =[[UIBarButtonItem alloc] initWithCustomView:todayButton];
    todayBarButton.tintColor = kThemeColor;
    
    NSArray *actionButtonItems = @[shareItem, todayBarButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kASActionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
            
        case kASActionTableView:
            cell.textLabel.text = @"TableView";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kASActionCompass:
            cell.textLabel.text = @"Compass";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kASBookmark:
            cell.textLabel.text = @"To Do List";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            cell.textLabel.text = @"N/A";
            break;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case kASActionTableView:
            [self showTableViewViewController];
            break;
            
        case kASActionCompass:
            [self showCompassViewController];
            break;
            
        case kASBookmark:
            [self showBookmarkViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark - Action Methods

- (void)showTableViewViewController {
    ASTableViewController *tableViewController = [ASTableViewController new];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)showCompassViewController {
    ASCompassViewController *compassViewController = [ASCompassViewController new];
    [self.navigationController pushViewController:compassViewController animated:YES];
}

- (void)showBookmarkViewController {
    ASBookmarkViewController *bookmarkViewController = [ASBookmarkViewController new];
    [self.navigationController pushViewController:bookmarkViewController animated:YES];
}

#pragma mark - Local Notificaiton

- (void)addNotification {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertAction = @"View";
    localNotification.alertBody = NSLocalizedString(@"ALERT_MESSAGE", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    // Notification fire times are set by creating a notification whose fire date
    // is an arbitrary weekday at the correct time, and having it repeat every weekday
    NSDate *fireDate = [dateFormatter dateFromString:@"01-04-2012 23:05"];
    
    localNotification.fireDate = fireDate;
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Timer Methods

- (void)updateCounter:(NSTimer *)theTimer {
    
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        self.myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else{
        secondsLeft = 16925;
    }
}

-(void)countdownTimer{
    
    secondsLeft = hours = minutes = seconds = 0;
    //    if([timer isValid])
    //    {
    //        [timer release];
    //    }
    //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    //  [pool release];
}

#pragma mark - Block Sample

+ (void)isBlock:(void(^)(NSArray *posts, NSError *error))block {
    
    if (block) {
        block(nil, nil);
    }
}


@end
