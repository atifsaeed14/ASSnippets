//
//  MKMapViewHelper.h
//
//  Created by Thiago Peres on 6/16/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (Helper)

- (void)recenterMapOnNumberOfClosestCoordinates:(NSInteger)numberOrCoordinates fromCoordinate:(CLLocationCoordinate2D)coordinate;

// Recenters the map in all annotations currently on the map
- (void)recenterMap;
- (BOOL)isCoordinate:(CLLocationCoordinate2D)coordinate insidePolygonView:(MKPolygonView*)polygonView;
- (BOOL)isCoordinate:(CLLocationCoordinate2D)coordinate insideCoordinatePolygon:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end
