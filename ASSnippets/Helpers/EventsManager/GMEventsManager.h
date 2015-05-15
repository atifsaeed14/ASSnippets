//
//  GMEventsManager.h
//  GMSnippets
//
//  Created by Mustafa on 23/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@interface GMEventsManager : NSObject

+ (instancetype)sharedManager;

- (EKCalendar *)eventCalendar;

- (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;

- (BOOL)addEventWithTitle:(NSString *)title
                startDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate;

- (BOOL)addEventWithTitle:(NSString *)title
                startDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate
                    notes:(NSString *)notes
                 location:(NSString *)location
              alarmBefore:(NSTimeInterval)relativeAlarmOffset;
@end
