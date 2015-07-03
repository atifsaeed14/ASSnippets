//
//  NSDate+Simple.h
//
//  Created by Thiago Peres on 6/2/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Simple) 

+ (NSDate*)dateWithString:(NSString*)dateString format:(NSString*)format;
+ (NSInteger)numberOfMonthsUntil:(NSDate *)aDate;
+ (NSInteger)numberOfDaysUntil:(NSDate *)aDate;
+ (NSInteger)numberOfDaysSince:(NSDate *)aDate;

@end
