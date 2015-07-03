//
//  AKAnnotation.h
//
//  Created by Thiago Peres on 3/4/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AKAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (id)annotationWithTitle:(NSString*)aTitle subtitle:(NSString*)aSubtitle coordinate:(CLLocationCoordinate2D)aCoordinate;
- (NSString*)description;
- (id)copyWithZone:(NSZone *)zone;

@end
