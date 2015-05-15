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
#import "ASScrollViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASNWViewController.h"
#import "ASWebViewController.h"
#import "ASLoginViewController.h"
#import "ASDetailTableView.h"
#import "ASCollectionViewController.h"
#import "GAIDictionaryBuilder.h"

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
    request.naturalLanguageQuery = @"Restaurants";
    
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.7167, 73.0667);

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(40.7127, 74.0059);

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 15000, 15000);
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
   
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setTitle:@"Today's" forState:UIControlStateNormal];
    //[todayButton setTitleColor: forState:UIControlStateNormal];
    [todayButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [todayButton setFrame:CGRectMake(0, 0, 80, 30)];
    //[productionOrderButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [todayButton addTarget:self action:@selector(todayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *todayBarButton =[[UIBarButtonItem alloc] initWithCustomView:todayButton];
    //todayBarButton.tintColor = ;
    
    UIImage *arrowDownImage = [[UIImage imageNamed:@"arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *arrowDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(todayButton.bounds) - 12, todayButton.frame.origin.y + 13, arrowDownImage.size.width, arrowDownImage.size.height)];
    [arrowDownImageView setImage:arrowDownImage];
    
    [todayButton addSubview:arrowDownImageView];

    
//    - (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;
//
//    CGPoint pointVale = [sender convertPoint: CGPointZero]
//    NSIndexPath *path = [self.view indexPathforrowatpoint]
//    
    /* view blue */
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [blurEffectView setFrame:self.view.bounds];
//    [self.view addSubview:blurEffectView];

    /* image blue */
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = _imageView.bounds;
//    [_imageView addSubview:visualEffectView];
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

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
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"ViewCon" style:UIBarButtonItemStyleDone target:self action:@selector(presentViewCOntroller)];
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

- (void)closeViewController {
    
    if ([_delegate respondsToSelector:@selector(didSelectViewController:)])
        [self.delegate didSelectViewController:self];
}

- (void)presentViewCOntroller {
    
    // http://stackoverflow.com/questions/2200736/how-to-take-a-screenshot-programmatically
    
    /* Capture the screenshot */
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    ASLoginViewController *loginVC = [ASLoginViewController new];
    loginVC.screenShot = imageView;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    
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
            
        case kASScrollTableView:
            cell.textLabel.text = @"Customer TableView";
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            break;
            
        case kANWViewController:
            cell.textLabel.text = @"AF Networking";
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            break;
            
        case kASWebViewController:
            cell.textLabel.text = @"Web ViewController";
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            break;
            
        case kASLoginViewController:
            cell.textLabel.text = @"Login ViewController";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kASDetailViewController:
            cell.textLabel.text = @"Detail ViewController";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        
        case kASCollectinViewController:
            cell.textLabel.text = @"Collection ViewController";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            cell.textLabel.text = @"N/A";
            break;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    //cell.backgroundColor = color;
    
    // http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.sideMenuController toggleMenuAnimated:YES];
    
    switch (indexPath.row) {
        case kASActionTableView: {
            
            ASTableViewController *tableViewController = [ASTableViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            //[self.navigationController pushViewController:tableViewController animated:YES];
            [appDelegate.sideMenuController setContentViewController:nav];
            //[self showTableViewViewController];
        }
            break;
            
        case kASActionCompass: {
            
            ASCompassViewController *scrollViewController = [ASCompassViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scrollViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];
            
            [appDelegate.sideMenuController setContentViewController:nav];

            
            //[self showCompassViewController];
        }
            break;
            
        case kASBookmark:
            [self showBookmarkViewController];
            break;
            
        case kASScrollTableView: {
            
            ASScrollViewController *scrollViewController = [ASScrollViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scrollViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];

            [appDelegate.sideMenuController setContentViewController:nav];
        }
            //[self showScrollTablViewController];
            break;

        case kANWViewController: {
            
            ASNWViewController *nwViewController = [ASNWViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nwViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];
            
            [appDelegate.sideMenuController setContentViewController:nav];
        }
            //[self showScrollTablViewController];
            break;

        case kASWebViewController: {
            
            ASWebViewController *nwViewController = [ASWebViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nwViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];
            
            [appDelegate.sideMenuController setContentViewController:nav];
        }
            //[self showScrollTablViewController];
            break;
            
            
        case kASLoginViewController: {
            ASLoginViewController *nwViewController = [ASLoginViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nwViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
            [appDelegate.sideMenuController setContentViewController:nav];
        }
            break;
            
        case kASDetailViewController: {
            ASDetailTableView *dViewController = [ASDetailTableView new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
            [appDelegate.sideMenuController setContentViewController:nav];
        }
            break;
            
        case kASCollectinViewController: {
            ASCollectionViewController *cViewController = [ASCollectionViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cViewController];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
            [appDelegate.sideMenuController setContentViewController:nav];
        }
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

- (void)showScrollTablViewController {
    ASScrollViewController *scrollViewController = [ASScrollViewController new];
    [self.navigationController pushViewController:scrollViewController animated:YES];
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




@end
