//
//  MKMapViewHelper.m
//
//  Created by Thiago Peres on 6/16/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import "MKMapViewHelper.h"

@implementation MKMapView (Helper)

// Center map in a given set of annotations
- (void)recenterMapInAnnotations:(NSArray*)annotations
{
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    
    for (id <MKAnnotation> annotation in annotations) 
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) 
        {
            zoomRect = pointRect;
        } 
        else 
        {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    
    [self setVisibleMapRect:zoomRect animated:YES];
}

- (void)recenterMapOnNumberOfClosestCoordinates:(NSInteger)numberOrCoordinates fromCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSComparator compareAnnotations = ^(id obj1, id obj2) {
        id<MKAnnotation> ann1 = obj1;
        id<MKAnnotation> ann2 = obj2;
        
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:ann1.coordinate.latitude longitude:ann1.coordinate.longitude];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:ann2.coordinate.latitude longitude:ann2.coordinate.longitude];
        CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        CLLocationDistance distance1 = [loc1 distanceFromLocation:userLoc];
        CLLocationDegrees distance2 = [loc2 distanceFromLocation:userLoc];
        
        if (distance1 > distance2) 
        {
            return NSOrderedDescending;
        } 
        else if (distance1 < distance2) 
        {
            return NSOrderedAscending;
        } 
        else 
        {
            return NSOrderedSame;
        }
    };
        
    NSArray *sortedAnnotations = [self.annotations sortedArrayUsingComparator:compareAnnotations];
    
    NSArray *filteredAnnotations = [sortedAnnotations objectsAtIndexes:
                                    [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, (sortedAnnotations.count < numberOrCoordinates) ? sortedAnnotations.count : numberOrCoordinates )]];
    
    [self recenterMapInAnnotations:filteredAnnotations];
}

- (void)recenterMap 
{
    [self recenterMapInAnnotations:self.annotations];
}

- (BOOL)isCoordinate:(CLLocationCoordinate2D)coordinate insidePolygonView:(MKPolygonView*)polygonView
{
	MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
	CGPoint polygonViewPoint = [polygonView pointForMapPoint:mapPoint];
	
	BOOL mapCoordinateIsInPolygon = CGPathContainsPoint(polygonView.path, NULL, polygonViewPoint, NO);
	
	return mapCoordinateIsInPolygon;
}

- (BOOL)isCoordinate:(CLLocationCoordinate2D)coordinate insideCoordinatePolygon:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
	MKPolygon *poly = [MKPolygon polygonWithCoordinates:coords count:count];
	MKPolygonView *polyView = [[MKPolygonView alloc] initWithPolygon:poly];
	
	BOOL result = [self isCoordinate:coordinate insidePolygonView:polyView];
    
	return result;
}

@end
