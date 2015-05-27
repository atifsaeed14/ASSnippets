//
//  GMMapViewController.m
//  GMSnippets
//
//  Created by Mustafa on 02/12/2014.
//  Copyright (c) 2014 Learning. All rights reserved.
//

#import "GMMapViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "RMUniversalAlert.h"

#define kGMMapQuestOptimizeLimit    10
#define kGMMapErrorDomain           @"com.mustafa.learning.map.errordomain"
#define kGMMapQuestKey              @"<map_quest_api_key>"

#define kGMMapQuestRouteURLString           @"http://www.mapquestapi.com/directions/v2/route?key=%@&outFormat=json&json=%@"
#define kGMMapQuestRouteOptimizedURLString  @"http://www.mapquestapi.com/directions/v2/optimizedroute?key=%@&outFormat=json&json=%@"

#pragma mark -

@interface GMMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

#pragma mark -

@implementation GMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add right bar button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                    target:self
                                                                                    action:@selector(actionButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action methods

- (void)actionButtonTapped:(id)sender {
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:@"Action"
                                              message:@"Choose the action you want the take."
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@[@"Get Geo-location from Address",
                                                        @"Get Address from Geo-location",
                                                        @"Get Directions Information",
                                                        @"Get Travel Time Information",
                                                        @"Open Maps App for Directions",
                                                        @"Get Route Using MapQuest",
                                                        @"Get Optimized Route Using MapQuest"]
                   popoverPresentationControllerBlock:nil
                                             tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                                 
                                                 if (buttonIndex == alert.cancelButtonIndex) {
                                                     NSLog(@"Cancel button tapped");
                                                     
                                                 } else if (buttonIndex == alert.destructiveButtonIndex) {
                                                     NSLog(@"Delete button tapped");
                                                     
                                                 } else if (buttonIndex >= alert.firstOtherButtonIndex) {
                                                     NSInteger otherButtonIndex = (long)buttonIndex - alert.firstOtherButtonIndex;
                                                     NSLog(@"Other Button Index %ld", otherButtonIndex);
                                                     
                                                     if (otherButtonIndex == 0) {
                                                         [self getLocationsForAddresses];
                                                         
                                                     } else if (otherButtonIndex == 1) {
                                                         [self getAddressesFromLocations];
                                                         
                                                     } else if (otherButtonIndex == 2) {
                                                         [self getGeneralPurposeDirectionsInformation];
                                                         
                                                     } else if (otherButtonIndex == 3) {
                                                         [self getExpectedTravelTimeInformation];
                                                         
                                                     } else if (otherButtonIndex == 4) {
                                                         [self openMapsApplicationWithDirections];
                                                         
                                                     } else if (otherButtonIndex == 5) {
                                                         [self getRouteUsingMapQuest];
                                                     
                                                     } else if (otherButtonIndex == 6) {
                                                         [self optimizeMapRoute];
                                                         // [self routeOptimizationRaw];
                                                     }
                                                 }
                                             }];
}

#pragma mark Wrapper methods

- (void)getRouteUsingMapQuest {
    CLLocationCoordinate2D storeLocationCoordinate = CLLocationCoordinate2DMake(40.01469800, -74.78969499);
    NSValue *storeLocationCoordinateValue = [NSValue valueWithMKCoordinate:storeLocationCoordinate];
    
    NSArray *locationCoordinates = @[storeLocationCoordinateValue,
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35945318, -72.94651295)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36346908, -72.93512004)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35902000, -72.94537900)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36294014, -72.93391982)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35103500, -72.93191100)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.39091200, -72.92199700)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36788196, -72.94184343)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36496548, -72.92269087)],
                                     [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36293200, -72.92756300)]];
    
    for (NSValue *locationCoordinateValue in locationCoordinates) {
        CLLocationCoordinate2D locationCoordinate = [locationCoordinateValue MKCoordinateValue];

        MKPointAnnotation *mapPointAnnotation = [[MKPointAnnotation alloc] init];
        mapPointAnnotation.coordinate = locationCoordinate;
        mapPointAnnotation.title = [self stringForCoordinate:locationCoordinate];
        [self.mapView addAnnotation:mapPointAnnotation];
    }

    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

    // Get directions!
    NSString *jsonString = [self locationsJSONForCoordinates:locationCoordinates];
    NSString *mapQuestRouteURLString = [NSString stringWithFormat:kGMMapQuestRouteURLString, kGMMapQuestKey, jsonString];
    NSLog(@"Request URL: \n%@", mapQuestRouteURLString);
    
    NSError *error = nil;
    NSURL *mapQuestOptimizeRouteURL = [NSURL URLWithString:[mapQuestRouteURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request URL: \n%@", mapQuestOptimizeRouteURL);
    
    NSString *response = [NSString stringWithContentsOfURL:mapQuestOptimizeRouteURL encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error: \n%@", error);
        
    } else if (response != nil) {
        NSLog(@"Response: \n%@", response);
        
        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
        
        if (error) {
            NSLog(@"Error: \n%@", error);
            
        } else if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonDictionary = (NSDictionary *)jsonResponse;
            NSNumber *infoStatusCode = [jsonDictionary valueForKeyPath:@"info.statuscode"];
            
        } else if ([jsonResponse isKindOfClass:[NSArray class]]) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil),
                                       NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil)
                                       };
            NSError *error = [NSError errorWithDomain:kGMMapErrorDomain
                                                 code:-57
                                             userInfo:userInfo];
            
            NSLog(@"Error: \n%@", error);
        }
    }
}

- (void)openMapsApplicationWithDirections {
    
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake(37.331446,-122.030412);
    CLLocationCoordinate2D endLocationCoordinate = CLLocationCoordinate2DMake(37.325333,-122.045035);
    CLLocationCoordinate2D furtherLocationCoordinate = CLLocationCoordinate2DMake(37.3545783,-122.0321715);
    
    MKMapItem *startMapItem = [self mapItemForLocationCoordinate:startLocationCoordinate];
    MKMapItem *endMapItem = [self mapItemForLocationCoordinate:endLocationCoordinate];
    MKMapItem *furtherMapItem = [self mapItemForLocationCoordinate:furtherLocationCoordinate];
    
    NSArray *mapItems = @[startMapItem, endMapItem, furtherMapItem];
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,
                                    MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard]};
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
}

- (void)getGeneralPurposeDirectionsInformation {
    // Software Technology Park, Constitution Avenue, Islamabad, Islamabad Capital Territory, Pakistan (33.732869,73.091714)
    // Jinnah Super Market, College Road, Islamabad, Islamabad Capital Territory, Pakistan (33.72114,73.05713)
    // Islamabad (33.7167, 73.0667)
    // Lahore (31.5497, 74.3436)
    // Cupertino, CA (37.30925,-122.0436444)
    // Los Angeles, CA (34.0204989,-118.4117325)
    // Apple Inc., Infinite Loop, Cupertino, CA (37.331446,-122.030412)
    // Cupertino Memorial Park, North Stelling Road, Cupertino, CA (37.325333,-122.045035)
    // Fremont High School 1279 Sunnyvale Saratoga Rd Sunnyvale, CA 94087 (37.3545783,-122.0321715)
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake(37.331446,-122.030412);
    CLLocationCoordinate2D endLocationCoordinate = CLLocationCoordinate2DMake(37.325333,-122.045035);
    CLLocationCoordinate2D furtherLocationCoordinate = CLLocationCoordinate2DMake(37.3545783,-122.0321715);
    
    MKMapItem *startMapItem = [self mapItemForLocationCoordinate:startLocationCoordinate];
    MKMapItem *endMapItem = [self mapItemForLocationCoordinate:endLocationCoordinate];
    MKMapItem *furtherMapItem = [self mapItemForLocationCoordinate:furtherLocationCoordinate];
    
    MKPointAnnotation *startPointAnnotation = [[MKPointAnnotation alloc] init];
    startPointAnnotation.coordinate = startLocationCoordinate;
    startPointAnnotation.title = @"Start";
    [self.mapView addAnnotation:startPointAnnotation];
    
    MKPointAnnotation *endPointAnnotation = [[MKPointAnnotation alloc] init];
    endPointAnnotation.coordinate = endLocationCoordinate;
    endPointAnnotation.title = @"End";
    [self.mapView addAnnotation:endPointAnnotation];
    
    MKPointAnnotation *furtherPointAnnotation = [[MKPointAnnotation alloc] init];
    furtherPointAnnotation.coordinate = furtherLocationCoordinate;
    furtherPointAnnotation.title = @"Further";
    [self.mapView addAnnotation:furtherPointAnnotation];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    directionsRequest.requestsAlternateRoutes = YES;
    [directionsRequest setSource:startMapItem];
    [directionsRequest setDestination:endMapItem];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *directionsResponse, NSError *directionsError) {
        
        if (directionsError) {
            NSLog(@"Error: %@", directionsError);
            
        } else {
            NSLog(@"Response: %@", directionsResponse);
            
            for (MKRoute *route in directionsResponse.routes) {
                NSLog(@"-");
                NSLog(@"Route/Name: %@", route.name); // localized description of the route's significant feature, e.g. "US-101"
                NSLog(@"Route/Advisory Notice: %@", route.advisoryNotices); // localized notices of route conditions as NSStrings. e.g. "Avoid during winter storms"
                NSLog(@"Route/Distance: %.2f meters", route.distance); // overall route distance in meters
                NSLog(@"Route/Expected Travel Time: %.2f", route.expectedTravelTime); // time in seconds
                NSLog(@"Route/Transport Type: %@", [self transportTypeString:route.transportType]);
                NSLog(@"Route/Steps:");
                
                NSInteger stepCounter = 1;
                for (MKRouteStep *step in route.steps) {
                    NSLog(@"Route/Step %ld:", (long)stepCounter);
                    NSLog(@"Route/Step %ld/Instructions: %@", (long)stepCounter, step.instructions); // localized written instructions
                    NSLog(@"Route/Step %ld/Instructions: %@", (long)stepCounter, step.notice); // additional localized legal or warning notice related to this step (e.g. "Do not cross tracks when lights flash")
                    NSLog(@"Route/Step %ld/Distance: %.2f meters", (long)stepCounter, step.distance); // step distance in meters
                    NSLog(@"Route/Step %ld/Transport Type: %@", (long)stepCounter, [self transportTypeString:step.transportType]); // step transport type (may differ from overall route transport type)
                    
                    stepCounter++;
                }
            }
            
            // Show Route on map
            [self showRoute:directionsResponse];
        }
    }];
    
    MKDirectionsRequest *directionsRequest2 = [[MKDirectionsRequest alloc] init];
    directionsRequest2.transportType = MKDirectionsTransportTypeWalking;
    directionsRequest2.requestsAlternateRoutes = YES;
    [directionsRequest2 setSource:endMapItem];
    [directionsRequest2 setDestination:furtherMapItem];
    
    MKDirections *directions2 = [[MKDirections alloc] initWithRequest:directionsRequest2];
    [directions2 calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *directionsResponse, NSError *directionsError) {
        
        if (directionsError) {
            NSLog(@"Error: %@", directionsError);
            
        } else {
            NSLog(@"Response: %@", directionsResponse);
            
            for (MKRoute *route in directionsResponse.routes) {
                NSLog(@"-");
                NSLog(@"Route/Name: %@", route.name); // localized description of the route's significant feature, e.g. "US-101"
                NSLog(@"Route/Advisory Notice: %@", route.advisoryNotices); // localized notices of route conditions as NSStrings. e.g. "Avoid during winter storms"
                NSLog(@"Route/Distance: %.2f meters", route.distance); // overall route distance in meters
                NSLog(@"Route/Expected Travel Time: %.2f", route.expectedTravelTime); // time in seconds
                NSLog(@"Route/Transport Type: %@", [self transportTypeString:route.transportType]);
                NSLog(@"Route/Steps:");
                
                NSInteger stepCounter = 1;
                for (MKRouteStep *step in route.steps) {
                    NSLog(@"Route/Step %ld:", (long)stepCounter);
                    NSLog(@"Route/Step %ld/Instructions: %@", (long)stepCounter, step.instructions); // localized written instructions
                    NSLog(@"Route/Step %ld/Instructions: %@", (long)stepCounter, step.notice); // additional localized legal or warning notice related to this step (e.g. "Do not cross tracks when lights flash")
                    NSLog(@"Route/Step %ld/Distance: %.2f meters", (long)stepCounter, step.distance); // step distance in meters
                    NSLog(@"Route/Step %ld/Transport Type: %@", (long)stepCounter, [self transportTypeString:step.transportType]); // step transport type (may differ from overall route transport type)
                    
                    stepCounter++;
                }
            }
            
            // Show Route on map
            [self showRoute:directionsResponse];
        }
    }];
}

- (void)getExpectedTravelTimeInformation {
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake(37.331446,-122.030412);
    CLLocationCoordinate2D endLocationCoordinate = CLLocationCoordinate2DMake(37.325333,-122.045035);
    
    MKMapItem *startMapItem = [self mapItemForLocationCoordinate:startLocationCoordinate];
    MKMapItem *endMapItem = [self mapItemForLocationCoordinate:endLocationCoordinate];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    directionsRequest.requestsAlternateRoutes = YES;
    [directionsRequest setSource:startMapItem];
    [directionsRequest setDestination:endMapItem];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            // Note: Source and destination may be filled with additional details compared to the request object.
            MKMapItem *source = response.source;
            MKMapItem *destination = response.destination;
            NSTimeInterval expectedTravelTime = response.expectedTravelTime;
            NSLog(@"Calculated ETA: %.2f", expectedTravelTime);
        }
        
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:@"Result"
                                            message:@"See Console for result."
                                  cancelButtonTitle:@"OK"
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:NULL];
    }];
}

- (void)optimizeMapRoute {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLLocationCoordinate2D storeLocationCoordinate = CLLocationCoordinate2DMake(40.01469800, -74.78969499);
        NSArray *locationCoordinates = @[[NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36383161, -72.93596993)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35945318, -72.94651295)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36346908, -72.93512004)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35902000, -72.94537900)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36294014, -72.93391982)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.35103500, -72.93191100)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.39091200, -72.92199700)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36788196, -72.94184343)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36496548, -72.92269087)],
                                         [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(41.36293200, -72.92756300)]];
        
        // Fetch optimized location sequence
        NSMutableArray *locationSequences = [NSMutableArray array];
        
        // Note: Store location or previous batch's last location will be added as the first location (by default)
        NSInteger requestLimit = kGMMapQuestOptimizeLimit - 1;
        NSInteger requestTotal = ([locationCoordinates count] / requestLimit) + 1;
        
        for (NSInteger requestCount = 0; requestCount < requestTotal; requestCount++) {
            NSMutableArray *locationsArray = [NSMutableArray array];
            BOOL isFirstLocationStore = NO;
            BOOL isLastLocationStore = NO;
            
            // Prepare a range for tickets
            NSInteger ticketsRangeLocation = requestCount * requestLimit;
            NSInteger rangeLength = ([locationCoordinates count] - ticketsRangeLocation);
            
            if (rangeLength > requestLimit) {
                rangeLength = requestLimit;
            }
            
            NSRange ticketsRange = NSMakeRange(ticketsRangeLocation, rangeLength);
            
            // Add store location as the first location, or
            // Add last location of the previous batch as the first location
            if (ticketsRangeLocation == 0) {
                isFirstLocationStore = YES;
                
                NSNumber *lat = [NSNumber numberWithDouble:storeLocationCoordinate.latitude];
                NSNumber *lng = [NSNumber numberWithDouble:storeLocationCoordinate.longitude];
                NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
                NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
                [locationsArray addObject:locationDictionary];
                
            } else {
                NSValue *locationCoordinateValue = [locationCoordinates objectAtIndex:ticketsRangeLocation - 1];
                CLLocationCoordinate2D locationCoordinate = [locationCoordinateValue MKCoordinateValue];
                
                NSNumber *lat = [NSNumber numberWithDouble:locationCoordinate.latitude];
                NSNumber *lng = [NSNumber numberWithDouble:locationCoordinate.longitude];
                NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
                NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
                [locationsArray addObject:locationDictionary];
            }
            
            // Add locations for each ticket
            for (NSInteger index = ticketsRange.location + 0; index < (ticketsRange.location + ticketsRange.length); index++) {
                NSValue *locationCoordinateValue = [locationCoordinates objectAtIndex:index];
                CLLocationCoordinate2D locationCoordinate = [locationCoordinateValue MKCoordinateValue];
                
                NSNumber *lat = [NSNumber numberWithDouble:locationCoordinate.latitude];
                NSNumber *lng = [NSNumber numberWithDouble:locationCoordinate.longitude];
                NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
                NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
                [locationsArray addObject:locationDictionary];
            }
            
            // Add store location as the last location
            if (requestCount == requestTotal - 1) {
                isLastLocationStore = YES;
                
                NSNumber *lat = [NSNumber numberWithDouble:storeLocationCoordinate.latitude];
                NSNumber *lng = [NSNumber numberWithDouble:storeLocationCoordinate.longitude];
                NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
                NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
                [locationsArray addObject:locationDictionary];
            }
            
            NSError *error = nil;
            NSArray *locationSequencesForBatch = [self locationSequenceForLocations:locationsArray error:&error];
            NSLog(@"Location Sequence for Range (%lu, %lu): \n%@", (unsigned long)ticketsRange.location, (unsigned long)ticketsRange.length, locationSequencesForBatch);
            
            // Normalize location sequence
            NSInteger locationSequenceIndex = 0;
            NSInteger locationSequenceTotal = [locationSequencesForBatch count];
            
            for (NSNumber *locationSequenceNumber in locationSequencesForBatch) {
                
                if ((locationSequenceIndex == 0) && (!isFirstLocationStore)) {
                    // Ignore the sequence of this location
                    
                } else if ((locationSequenceIndex == locationSequenceTotal) && (isLastLocationStore)) {
                    // Ignore the sequence of this location
                    
                } else {
                    NSInteger normalizedLocationSequenceNumber = [locationSequenceNumber integerValue] + (requestCount * requestLimit);
                    [locationSequences addObject:[NSNumber numberWithInteger:normalizedLocationSequenceNumber]];
                }
                
                locationSequenceIndex++;
            }
        }
        
        NSLog(@"Sequence: \n%@", locationSequences);
        
        NSMutableArray *ticketSequences = [NSMutableArray array];
        
        for (NSInteger index = 0; index < [locationSequences count]; index++) {
            
            if ((index == 0) || (index == [locationSequences count] - 1)) {
                // Ignore, this is representing the store location
                
            } else {
                NSInteger ticketIndex = [[locationSequences objectAtIndex:index] integerValue] - 1;
                [ticketSequences addObject:[NSNumber numberWithInteger:ticketIndex]];
            }
        }
        
        NSLog(@"New Ticket Indexes: \n%@", ticketSequences);
        
        // Perform UI operation in the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [RMUniversalAlert showAlertInViewController:self
                                              withTitle:@"Result"
                                                message:@"See Console for result."
                                      cancelButtonTitle:@"OK"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil
                                               tapBlock:NULL];
        });
    });
}

- (void)routeOptimizationRaw {
    NSArray *locations = @[[[CLLocation alloc] initWithLatitude:41.36383161 longitude:-72.93596993],
                           [[CLLocation alloc] initWithLatitude:41.35945318 longitude:-72.94651295],
                           [[CLLocation alloc] initWithLatitude:41.36346908 longitude:-72.93512004],
                           [[CLLocation alloc] initWithLatitude:41.35902000 longitude:-72.94537900],
                           [[CLLocation alloc] initWithLatitude:41.36294014 longitude:-72.93391982],
                           [[CLLocation alloc] initWithLatitude:41.35103500 longitude:-72.93191100],
                           [[CLLocation alloc] initWithLatitude:41.39091200 longitude:-72.92199700],
                           [[CLLocation alloc] initWithLatitude:41.36788196 longitude:-72.94184343],
                           [[CLLocation alloc] initWithLatitude:41.36496548 longitude:-72.92269087],
                           [[CLLocation alloc] initWithLatitude:41.36293200 longitude:-72.92756300]];
    
    NSMutableArray *locationsArray = [NSMutableArray array];
    
    for (CLLocation *location in locations) {
        NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
        NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];
        NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
        NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
        [locationsArray addObject:locationDictionary];
    }
    
    NSDictionary *locationsDictionary = [NSDictionary dictionaryWithObject:locationsArray forKey:@"locations"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:locationsDictionary options:0 error:&error];
    NSString *jsonLocations = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *mapQuestKey = [NSString stringWithString:kGMMapQuestKey];
    NSString *mapQuestOptimizeRouteURLString = [NSString stringWithFormat:kGMMapQuestRouteOptimizedURLString, mapQuestKey, jsonLocations];
    NSLog(@"Request URL: \n%@", mapQuestOptimizeRouteURLString);
    
    NSURL *mapQuestOptimizeRouteURL = [NSURL URLWithString:[mapQuestOptimizeRouteURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *response = [NSString stringWithContentsOfURL:mapQuestOptimizeRouteURL encoding:NSUTF8StringEncoding error:&error];
    
    if (error != nil) {
        NSLog(@"Error: \n%@", error);
        
    } else if (response != nil) {
        NSLog(@"Response: \n%@", response);
    }
    
    NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
    
    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *)jsonResponse;
        NSArray *locationSequence = [jsonDictionary valueForKeyPath:@"route.locationSequence"];
        
        // route.locationSequence
        // route.locations
        // route.routeError.errorCode
        // route.routeError.message
        // info.statuscode (Int)
        // info.messages (Array)
        
    } else if ([jsonResponse isKindOfClass:[NSArray class]]) {
        
    }
    
    // http://www.mapquestapi.com/directions/v2/optimizedroute?key=<map_quest_api_key>&callback=renderMatrixResults&outFormat=xml&json={%22locations%22:%20[{%22latLng%22:%20{%22lat%22:%2041.36346908,%22lng%22:%20-72.93512004}},{%22latLng%22:%20{%22lat%22:%2041.36383161,%22lng%22:%20-72.93596993}},{%22latLng%22:%20{%22lat%22:%2041.35945318,%22lng%22:%20-72.94651295}}],%22options%22:%20{%22routeType%22:%20%22shortest%22}}
    // http://open.mapquestapi.com/directions/v2/optimizedroute?key=<map_quest_api_key>&callback=%20renderMatrixResults&outFormat=xml&json={locations:[{%20latLng:%20{%20lat:%2048.2300676,%20lng:%2011.6828566}%20},{%20latLng:%20{%20lat:%2048.447097202066,%20lng:%2011.7404350694809}%20},{%20latLng:%20{%20lat:%2048.1212485,%20lng:%2011.5190721}%20},{%20latLng:%20{%20lat:%2049.45385,%20lng:%2011.07732}%20},{%20latLng:%20{%20lat:%2048.2300676,%20lng:%2011.6828566}%20}]}

    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:@"Result"
                                        message:@"See Console for result."
                              cancelButtonTitle:@"OK"
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil
                                       tapBlock:NULL];
}

- (void)getAddressesFromLocations {
    NSArray *locations = @[[[CLLocation alloc] initWithLatitude:41.36383161 longitude:-72.93596993],    // 3 Elmwood Pl, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.35945318 longitude:-72.94651295],    // 275-297 Gilbert Ave, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.36346908 longitude:-72.93512004],    // 95 Cherry Hill Rd, Greater New Haven, Hamden, CT 06514-2825
                           [[CLLocation alloc] initWithLatitude:41.35902000 longitude:-72.94537900],    // 100 Morgan Ln, Greater New Haven, Hamden, CT 06514-2621
                           [[CLLocation alloc] initWithLatitude:41.36294014 longitude:-72.93391982],    // 92 Springdale St, Greater New Haven, Hamden, CT 06514-2823
                           [[CLLocation alloc] initWithLatitude:41.35103500 longitude:-72.93191100],    // 1396 Dixwell Ave, Greater New Haven, Hamden, CT 06514-4128
                           [[CLLocation alloc] initWithLatitude:41.39091200 longitude:-72.92199700],    // 625 Shepard Ave, Greater New Haven, Hamden, CT 06514-1603
                           [[CLLocation alloc] initWithLatitude:41.36788196 longitude:-72.94184343],    // 1-45 Paradise Ave, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.36496548 longitude:-72.92269087],    // 1972 Dixwell Ave, Greater New Haven, Hamden, CT 06514-2403
                           [[CLLocation alloc] initWithLatitude:41.36293200 longitude:-72.92756300]];   // 50 Roosevelt St, Greater New Haven, Hamden, CT 06514-3038
    
    for (CLLocation *location in locations) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           
                           if (placemarks.count > 0) {
                               CLPlacemark *placemark = [placemarks objectAtIndex:0];
                               NSLog(@"%@: %@", location, placemark.addressDictionary);
                               
                           } else if (error.domain == kCLErrorDomain) {
                               
                               switch (error.code) {
                                   case kCLErrorDenied:
                                       NSLog(@"Location Services Denied by User");
                                       break;
                                   case kCLErrorNetwork:
                                       NSLog(@"No Network");
                                       break;
                                   case kCLErrorGeocodeFoundNoResult:
                                       NSLog(@"No Result Found");
                                       break;
                                   default:
                                       NSLog(@"%@", error.localizedDescription);
                                       break;
                               }
                               
                           } else {
                               NSLog(@"%@", error.localizedDescription);
                           }
                       }];
    }
    
    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:@"Result"
                                        message:@"See Console for result."
                              cancelButtonTitle:@"OK"
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil
                                       tapBlock:NULL];
}

- (void)getLocationsForAddresses {
    NSArray *addresses = @[@"20 Springdale St, Hamden, CT, 06514",      // 41.36383161,-72.93596993
                           @"170 Morgan Ln, Hamden, CT, 06514",         // 41.35945318,-72.94651295
                           @"50 Springdale St, Hamden, CT, 06514",      // 41.36346908,-72.93512004
                           @"100 Morgan Ln, Hamden, CT, 06514",         // 41.35902000,-72.94537900
                           @"90 Springdale St, Hamden, CT, 06514",      // 41.36294014,-72.93391982
                           @"1396 Dixwell Avenue, Hamden, CT, 06514",   // 41.35103500,-72.93191100
                           @"625 Shepard Ave, Hamden, CT, 06514",       // 41.39091200,-72.92199700
                           @"25 Paradise Avenue, Hamden, CT, 06514",    // 41.36788196,-72.94184343
                           @"1952 Dixwell Avenue, Hamden, CT, 06514",   // 41.36496548,-72.92269087
                           @"50 Roosevelt St, Hamden, CT, 06514"];      // 41.36293200,-72.92756300
    
    NSArray *locations = @[[[CLLocation alloc] initWithLatitude:41.36383161 longitude:-72.93596993],    // 3 Elmwood Pl, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.35945318 longitude:-72.94651295],    // 275-297 Gilbert Ave, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.36346908 longitude:-72.93512004],    // 95 Cherry Hill Rd, Greater New Haven, Hamden, CT 06514-2825
                           [[CLLocation alloc] initWithLatitude:41.35902000 longitude:-72.94537900],    // 100 Morgan Ln, Greater New Haven, Hamden, CT 06514-2621
                           [[CLLocation alloc] initWithLatitude:41.36294014 longitude:-72.93391982],    // 92 Springdale St, Greater New Haven, Hamden, CT 06514-2823
                           [[CLLocation alloc] initWithLatitude:41.35103500 longitude:-72.93191100],    // 1396 Dixwell Ave, Greater New Haven, Hamden, CT 06514-4128
                           [[CLLocation alloc] initWithLatitude:41.39091200 longitude:-72.92199700],    // 625 Shepard Ave, Greater New Haven, Hamden, CT 06514-1603
                           [[CLLocation alloc] initWithLatitude:41.36788196 longitude:-72.94184343],    // 1-45 Paradise Ave, Greater New Haven, Hamden, CT 06514
                           [[CLLocation alloc] initWithLatitude:41.36496548 longitude:-72.92269087],    // 1972 Dixwell Ave, Greater New Haven, Hamden, CT 06514-2403
                           [[CLLocation alloc] initWithLatitude:41.36293200 longitude:-72.92756300]];   // 50 Roosevelt St, Greater New Haven, Hamden, CT 06514-3038
    
    // Sample Output:
    // <+41.36383161,-72.93596993> +/- 100.00m (speed -1.00 mps / course -1.00) @ 7/2/14, 4:56:57 PM Pakistan Standard Time
    for (NSString *address in addresses) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         
                         if (placemarks.count > 0) {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             NSLog(@"%@: %@", address, placemark.location);
                             
                         } else if (error.domain == kCLErrorDomain) {
                             
                             switch (error.code) {
                                 case kCLErrorDenied:
                                     NSLog(@"Location Services Denied by User");
                                     break;
                                 case kCLErrorNetwork:
                                     NSLog(@"No Network");
                                     break;
                                 case kCLErrorGeocodeFoundNoResult:
                                     NSLog(@"No Result Found");
                                     break;
                                 default:
                                     NSLog(@"%@", error.localizedDescription);
                                     break;
                             }
                             
                         } else {
                             NSLog(@"%@", error.localizedDescription);
                         }
                     }];
    }
    
    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:@"Result"
                                        message:@"See Console for result."
                              cancelButtonTitle:@"OK"
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil
                                       tapBlock:NULL];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)stringForCoordinate:(CLLocationCoordinate2D)locationCoordinate {
    return [NSString stringWithFormat:@"%.8f, %.8f", locationCoordinate.latitude, locationCoordinate.longitude];
}

- (void)showRoute:(MKDirectionsResponse *)response {
    NSLog(@"%s", __FUNCTION__);
    
    for (MKRoute *route in response.routes) {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

- (NSArray *)locationSequenceForLocations:(NSArray *)locationsArray error:(NSError **)outError {
    NSArray *locationSequence = nil;
    
    if ([locationsArray count] <= 2) {
        NSMutableArray *routeLocationSequence = [NSMutableArray array];
        
        for (NSInteger index = 0; index < [locationsArray count]; index++) {
            [routeLocationSequence addObject:[NSNumber numberWithInteger:index]];
        }
        
        locationSequence = routeLocationSequence;
        
    } else {
        NSDictionary *locationsDictionary = [NSDictionary dictionaryWithObject:locationsArray forKey:@"locations"];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:locationsDictionary options:0 error:&error];
        NSString *jsonLocations = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *mapQuestOptimizeRouteURLString = [NSString stringWithFormat:kGMMapQuestRouteOptimizedURLString, kGMMapQuestKey, jsonLocations];
        NSLog(@"Request URL: \n%@", mapQuestOptimizeRouteURLString);
        
        NSURL *mapQuestOptimizeRouteURL = [NSURL URLWithString:[mapQuestOptimizeRouteURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *response = [NSString stringWithContentsOfURL:mapQuestOptimizeRouteURL encoding:NSUTF8StringEncoding error:&error];
        
        if (error != nil) {
            NSLog(@"Error: \n%@", error);
            
            if (outError != NULL) {
                *outError = error;
            }
            
        } else if (response != nil) {
            NSLog(@"Response: \n%@", response);
            
            NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
            
            if (error) {
                
                if (outError != NULL) {
                    *outError = error;
                }
                
            } else if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDictionary = (NSDictionary *)jsonResponse;
                NSNumber *infoStatusCode = [jsonDictionary valueForKeyPath:@"info.statuscode"];
                NSArray *infoMessages = [jsonDictionary valueForKeyPath:@"info.messages"];
                NSString *routeErrorCode = [jsonDictionary valueForKeyPath:@"route.routeError.errorCode"];
                NSString *routeErrorMessage = [jsonDictionary valueForKeyPath:@"route.routeError.message"];
                NSArray *routeLocationSequence = [jsonDictionary valueForKeyPath:@"route.locationSequence"];
                NSString *infoMessage = nil;
                
                if ((infoMessages != nil) && ([infoMessages count] > 0)) {
                    infoMessage = [infoMessages objectAtIndex:0];
                }
                
                if ([infoStatusCode integerValue] == 0) {
                    locationSequence = routeLocationSequence;
                    
                } else if (infoMessage != nil) {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey:infoMessage,
                                               NSLocalizedFailureReasonErrorKey:infoMessage,
                                               NSLocalizedRecoverySuggestionErrorKey:infoMessage
                                               };
                    NSError *error = [NSError errorWithDomain:kGMMapErrorDomain
                                                         code:-57
                                                     userInfo:userInfo];
                    
                    if (outError != NULL) {
                        *outError = error;
                    }
                }
                
            } else if ([jsonResponse isKindOfClass:[NSArray class]]) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil),
                                           NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil),
                                           NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Unrecognized response received from MapQuest.", nil)
                                           };
                NSError *error = [NSError errorWithDomain:kGMMapErrorDomain
                                                     code:-57
                                                 userInfo:userInfo];
                
                if (outError != NULL) {
                    *outError = error;
                }
            }
        }
        
    }
    
    return locationSequence;
}

- (NSString *)jsonForDictionaryObject:(NSDictionary *)dictionaryObject {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryObject options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)locationsJSONForCoordinates:(NSArray *)coordinates {
    NSDictionary *locationsInfo = [self locationsDictionaryForCoordinates:coordinates];
    NSString *locationsJSON = [self jsonForDictionaryObject:locationsInfo];
    return locationsJSON;
}

- (NSDictionary *)locationsDictionaryForCoordinates:(NSArray *)coordinates {
    NSMutableArray *locations = [NSMutableArray array];
    
    for (NSValue *locationCoordinateValue in coordinates) {
        CLLocationCoordinate2D locationCoordinate = [locationCoordinateValue MKCoordinateValue];
        NSDictionary *locationDictionary = [self locationDictionaryForCoordinate:locationCoordinate];
        [locations addObject:locationDictionary];
    }
    
    NSDictionary *locationsDictionary = [NSDictionary dictionaryWithObject:locations forKey:@"locations"];
    return locationsDictionary;
}

- (NSDictionary *)locationDictionaryForCoordinate:(CLLocationCoordinate2D)locationCoordinate {
    NSNumber *lat = [NSNumber numberWithDouble:locationCoordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:locationCoordinate.longitude];
    NSDictionary *latLngDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:latLngDictionary forKey:@"latLng"];
    return locationDictionary;
}

- (NSString *)transportTypeString:(MKDirectionsTransportType)transportType {
    NSString *routeTransportTypeString = nil;
    
    switch (transportType) {
        case MKDirectionsTransportTypeAutomobile:
            routeTransportTypeString = @"Automobile";
            break;
        case MKDirectionsTransportTypeWalking:
            routeTransportTypeString = @"Walking";
            break;
        case MKDirectionsTransportTypeAny:
            routeTransportTypeString = @"Any";
            break;
        default:
            break;
    }
    
    return routeTransportTypeString;
}

- (MKMapItem *)mapItemForLocationCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%s", __FUNCTION__);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    NSLog(@"%s", __FUNCTION__);
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor purpleColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    // if ([annotation isKindOfClass:[MyCustomAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView) {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // If appropriate, customize the callout by adding accessory views (code not shown).
            
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

@end
