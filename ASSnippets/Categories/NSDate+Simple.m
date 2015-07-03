//
//  NSDate+Simple.m
//
//  Created by Thiago Peres on 6/2/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import "NSDate+Simple.h"

@implementation NSDate (Simple)

+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
    NSDate *firstDate = [dateFormatter dateFromString:dateString];
    
    return firstDate;
}

+ (NSInteger)numberOfMonthsUntil:(NSDate *)aDate
{
    NSDate * date1 = [NSDate date];
    NSDate * date2 = aDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:date1
                                                  toDate:date2 options:0];
    
    
    NSInteger months = [components month];
    //NSInteger days = [components day];
    return months;
}

+ (NSInteger)numberOfDaysUntil:(NSDate *)aDate
{
    NSDate * date1 = [NSDate date];
    NSDate * date2 = aDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:date1
                                                  toDate:date2 options:0];
    
    
    //NSInteger months = [components month];
    NSInteger days = [components day];
    return days;
}

+ (NSInteger)numberOfDaysSince:(NSDate *)aDate
{
    NSDate * date1 = [NSDate date];
    NSDate * date2 = aDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:date2
                                                  toDate:date1 options:0];
    
    
    //NSInteger months = [components month];
    NSInteger days = [components day];
    return days;
}

@end
