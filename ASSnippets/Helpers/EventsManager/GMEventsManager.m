//
//  GMEventsManager.m
//  GMSnippets
//
//  Created by Mustafa on 23/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMEventsManager.h"

static EKEventStore *_eventStore = nil;
static NSString *const kCalendarIdentifer = @"GMEventsManagerCalendarIdentifier";
static NSString *const kCalendarName = @"AS Events Calendar";

@implementation GMEventsManager

#pragma mark -
#pragma mark Singleton methods

+ (instancetype)sharedManager {
    static dispatch_once_t _once;
    static GMEventsManager *_sharedManager;
    
    dispatch_once(&_once, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager initializeManager];
    });
    
    return _sharedManager;
}

- (void)initializeManager {

    if (_eventStore == nil) {
        _eventStore = [[EKEventStore alloc] init];
    }
}

#pragma mark -
#pragma mark Public methods

- (NSString *)eventCalendarName {
    return kCalendarName;
}

- (EKCalendar *)eventCalendar {

    EKCalendar *calendar = nil;
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:kCalendarIdentifer];
    
    // When identifier exists, my calendar probably already exists
    // Note that user can delete my calendar. In that case I have to create it again.
    if (calendarIdentifier) {
        calendar = [_eventStore calendarWithIdentifier:calendarIdentifier];
    }
    
    // Calendar doesn't exist, create it and save it's identifier
    if (!calendar) {
        // http://stackoverflow.com/questions/7945537/add-a-new-calendar-to-an-ekeventstore-with-eventkit
        calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];
        
        // Set calendar name. This is what users will see in their Calendar app
        [calendar setTitle:[self eventCalendarName]];
        
        // Find appropriate source type. I'm interested only in local calendars but
        // there are also calendars in iCloud, MS Exchange, ...
        // Look for EKSourceType in manual for more options
        for (EKSource *source in _eventStore.sources) {
            
            if (source.sourceType == EKSourceTypeLocal) {
                calendar.source = source;
                break;
            }
        }
        
        // Save this in NSUserDefaults data for retrieval later
        NSString *calendarIdentifier = [calendar calendarIdentifier];
        
        NSError *error = nil;
        BOOL saved = [_eventStore saveCalendar:calendar commit:YES error:&error];
        
        if (saved) {
            // http://stackoverflow.com/questions/1731530/whats-the-easiest-way-to-persist-data-in-an-iphone-app
            // Saved successfuly, store it's identifier in NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:kCalendarIdentifer];
            
        } else {
            // Unable to save calendar
            return nil;
        }
    } else {
        NSLog(@"Could not find the calendar we were looking for.");
    }
    
    return calendar;
}

- (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback {
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}

- (BOOL)addEventWithTitle:(NSString *)title
                startDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate {
    
    return [self addEventWithTitle:title
                         startDate:startDate
                           endDate:endDate
                             notes:nil
                          location:nil
                       alarmBefore:NSTimeIntervalSince1970];
}

- (BOOL)addEventWithTitle:(NSString *)title
                startDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate
                    notes:(NSString *)notes
                 location:(NSString *)location
              alarmBefore:(NSTimeInterval)relativeAlarmOffset {
    
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
    EKCalendar *calendar = [self eventCalendar];

    // This shouldn't happen
    if (!calendar) {
        return NO;
    }
    
    // Assign basic information to the event; location is optional
    event.calendar = calendar;
    event.title = title;
    event.notes = notes;
    event.location = location;
    
    // Set the start date to the current date/time and the event duration to two hours
    event.startDate = startDate;
    
    if (endDate) {
        event.allDay = NO;
        event.endDate = endDate;
        
    } else {
        event.allDay = YES;
    }

    // Set alarm
    if ((relativeAlarmOffset != NSTimeIntervalSince1970) && (relativeAlarmOffset >= 0)) {
        NSArray *alarms = @[ [EKAlarm alarmWithRelativeOffset:-relativeAlarmOffset] ];
        event.alarms = alarms;
    }

    // Save event to the calendar
    NSError *error = nil;
    BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    
    if (!result) {
        NSLog(@"Error saving event: %@", error);
        return NO;
    }

    NSLog(@"Event saved successfully!");
    return YES;
}


- (NSMutableArray *)fetchEvents {
    
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    //tomorrowDateComponents.day = 5;
    tomorrowDateComponents.year = 1;
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    
    // We will only search the create calendar for our events
    NSArray *calendarArray = [NSArray arrayWithObject:[self eventCalendar]];
    
    // Create the predicate
    NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[_eventStore eventsMatchingPredicate:predicate]];
    
    return events;
}


@end
