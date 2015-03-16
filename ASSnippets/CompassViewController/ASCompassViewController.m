//
//  GMCompassViewController.m
//  GMSnippets
//
//  Created by Mustafa on 16/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "ASCompassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CLHeading+Formatted.h"

@interface ASCompassViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *compassContainerView;

@property (weak, nonatomic) IBOutlet UIView *compassArrowGreenContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *compassArrowGreenView;

@property (weak, nonatomic) IBOutlet UIImageView *compassNSEWView;
@property (weak, nonatomic) IBOutlet UIImageView *compassArrowBlackView;

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiblaLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLHeading *currentHeading;
@property (nonatomic) BOOL qiblaHeadingFound;

@property (nonatomic) NSInteger degree;

@end

#pragma mark -

@implementation ASCompassViewController

#pragma mark Init & Dealloc methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization
    }
    
    return self;
}

- (void)dealloc {
    // Clear memory or data
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (![CLLocationManager locationServicesEnabled]) {
        // location services is disabled, alert user
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DisabledTitle", @"DisabledTitle")
                                                                        message:NSLocalizedString(@"DisabledMessage", @"DisabledMessage")
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OKButtonTitle", @"OKButtonTitle")
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }

    
    // Do any additional setup after loading the view from its nib.
    if ([CLLocationManager headingAvailable]) {
        [self locationManager];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Device doesn't support heading updates."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    // Rotate black arrow to 180 degrees
    double degrees = 180;
    double radians = DegreesToRadians(degrees);
    self.compassArrowBlackView.transform = CGAffineTransformMakeRotation(radians);
    //[self rotate];
}

- (void)rotate {
    self.degree+=5;
    
    if (self.degree > 360) {
        self.degree = 0;
    }
    
    double radians = DegreesToRadians(self.degree);
    self.compassArrowBlackView.transform = CGAffineTransformMakeRotation(-radians);
    
    [self performSelector:@selector(rotate) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

 
#pragma mark -
#pragma mark CLLocationManager methods

- (CLLocationManager *)locationManager {
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }

        // Start the location updates
        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            [_locationManager startUpdatingLocation];
        }
        
        // Start the compass updates
        if ([CLLocationManager headingAvailable]) {
            _locationManager.headingFilter = 1;
            [_locationManager startUpdatingHeading];
        }
    }
    
    return _locationManager;
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%s", __FUNCTION__);
    CLLocation *newLocation = [locations firstObject];
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0) {
        return;
    }
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        NSLog(@"Location found!");

        // store the location as the "best effort"
        self.currentLocation = newLocation;
        
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.

        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            [self.locationManager stopUpdatingLocation];
            self.locationManager.delegate = nil;
        }
        
        // Update display
        [self updateHeadingDisplays];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.

    if ([error code] != kCLErrorLocationUnknown) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if (newHeading.headingAccuracy < 0)
        return;

    self.currentHeading = newHeading;
    [self updateHeadingDisplays];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

#pragma mark CLLocationManagerDelegate helper methods

- (void)updateHeadingDisplays {
    CLLocationDirection theHeading = self.currentHeading.magneticHeading; // ((self.currentHeading.trueHeading > 0) ? self.currentHeading.trueHeading : self.currentHeading.magneticHeading);

    NSLog(@"New magnetic heading: %f", self.currentHeading.magneticHeading);
    NSLog(@"New true heading: %f", self.currentHeading.trueHeading);
    self.headingLabel.text = [NSString stringWithFormat:@"Compass Direction: %@", [CLHeading formattedStringForHeading:theHeading format:nil abbreviate:YES]];
    
    if (self.currentLocation && self.currentHeading && !self.qiblaHeadingFound) {
        
        CLLocationCoordinate2D fromLocation = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
        CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(21.4225268,39.8263737); // (21.422481, 39.826223);
        CLLocationDirection qiblaDirection = [self directionFromLocation:fromLocation toLocation:toLocation];

        double degrees = qiblaDirection;
        double radians = DegreesToRadians(degrees);
        self.compassArrowGreenContainerView.transform = CGAffineTransformMakeRotation(radians);

        NSLog(@"Qibla direction: %f", qiblaDirection);
        self.qiblaLabel.text = [NSString stringWithFormat:@"Qibla Direction: %@", [CLHeading formattedStringForHeading:((qiblaDirection < 0) ? 180 - qiblaDirection : qiblaDirection) format:nil abbreviate:YES]];
        self.qiblaHeadingFound = YES;
        self.compassArrowGreenView.hidden = NO;

    } else if (self.qiblaHeadingFound == NO) {
        self.qiblaLabel.text = @"Qibla Direction: N/A";
        self.compassArrowGreenView.hidden = YES;
    }

    // Rotate compass according to the heading information
    double degrees = theHeading;
    double radians = DegreesToRadians(degrees);
    self.compassContainerView.transform = CGAffineTransformMakeRotation(-radians);
}

- (CLLocationDirection)directionFromLocation:(CLLocationCoordinate2D)fromLocationCoordinate toLocation:(CLLocationCoordinate2D)toLocationCoordinate {
    //Bearing Calculation
    //
    //In general, your current heading will vary as you follow a great circle path (orthodrome); the final heading will differ from the initial heading by varying degrees according to distance and latitude (if you were to go from say 35°N,45°E (≈ Baghdad) to 35°N,135°E (≈ Osaka), you would start on a heading of 60° and end up on a heading of 120°!).
    //
    //This formula is for the initial bearing (sometimes referred to as forward azimuth) which if followed in a straight line along a great-circle arc will take you from the start point to the end point:1
    //
    //Formula: 	θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
    //
    //JavaScript: (all angles in radians)
    //var y = Math.sin(λ2-λ1) * Math.cos(φ2);
    //var x = Math.cos(φ1)*Math.sin(φ2) -
    //Math.sin(φ1)*Math.cos(φ2)*Math.cos(λ2-λ1);
    //var brng = Math.atan2(y, x).toDegrees();
    //
    //Excel: (all angles in radians)
    //=ATAN2(COS(lat1)*SIN(lat2)-SIN(lat1)*COS(lat2)*COS(lon2-lon1),SIN(lon2-lon1)*COS(lat2))
    //*note that Excel reverses the arguments to ATAN2 – see notes below
    //
    //Since atan2 returns values in the range -π ... +π (that is, -180° ... +180°), to normalise the result to a compass bearing (in the range 0° ... 360°, with −ve values transformed into the range 180° ... 360°), convert to degrees and then use (θ+360) % 360, where % is (floating point) modulo.
    //
    //Reference:
    //http://www.movable-type.co.uk/scripts/latlong.html
    
    double lat1 = DegreesToRadians(fromLocationCoordinate.latitude);
    double lon1 = DegreesToRadians(fromLocationCoordinate.longitude);
    
    double lat2 = DegreesToRadians(toLocationCoordinate.latitude);
    double lon2 = DegreesToRadians(toLocationCoordinate.longitude);

    double radiansBearing = atan2(sin(lon2 - lon1) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1));
    double degreesBearing = RadiansToDegrees(radiansBearing);
    degreesBearing = (int)round(degreesBearing + 360.0) % 360; // Note: These calculation shenanigans are required because apparently we're getting the values between -180 and +180 (instead of between 0 and 360)

    return degreesBearing;
}

double DegreesToRadians(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees(double radians) {return radians * 180.0/M_PI;};

@end
