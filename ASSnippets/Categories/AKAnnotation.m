//
//  AKAnnotation.m
//
//  Created by Thiago Peres on 3/4/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import "AKAnnotation.h"


@implementation AKAnnotation

@synthesize coordinate, title, subtitle;

+ (id)annotationWithTitle:(NSString*)aTitle subtitle:(NSString*)aSubtitle coordinate:(CLLocationCoordinate2D)aCoordinate
{
    AKAnnotation *annotation = [[AKAnnotation alloc] init];
    [annotation setTitle:aTitle];
    [annotation setSubtitle:aSubtitle];
    [annotation setCoordinate:aCoordinate];
    return annotation;
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ - %@ (%f,%f) : %p>", title, subtitle, coordinate.latitude, coordinate.longitude, &self];
}

- (id)copyWithZone:(NSZone *)zone
{
    AKAnnotation *annotationCopy = [[AKAnnotation allocWithZone:zone] init];
    [annotationCopy setTitle:title];
    [annotationCopy setSubtitle:subtitle];
    [annotationCopy setCoordinate:coordinate];
    return annotationCopy;
}

@end
