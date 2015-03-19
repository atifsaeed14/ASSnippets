//
//  NSDate+Helper.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/19/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (BOOL)isInPast {
    
    NSDate *testTime = self;
    if ([testTime timeIntervalSinceNow] == 0.0) {
        return YES;
    }
    return NO;
}

@end
