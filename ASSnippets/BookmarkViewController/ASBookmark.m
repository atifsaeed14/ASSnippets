//
//  ASBookmark.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASBookmark.h"

#define kID @"id"

@implementation ASBookmark

+ (JSONKeyMapper*)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"iD",
                                                       @"title": @"text",
                                                       @"state": @"state",
                                                       }];
}

+ (NSMutableArray *)bookmarkFromPlist:(NSArray *)dataArray {
    
    NSMutableArray *bookmarkArray = [NSMutableArray new];
    
    for (NSDictionary *bookmark in dataArray) {
        ASBookmark *asBookmark = [[ASBookmark alloc] initWithDictionary:bookmark error:nil];
        [bookmarkArray addObject:asBookmark];
    }
    return bookmarkArray;
}

+ (NSMutableArray *)bookmarkInToPlist:(NSArray *)dataArray {
    
    NSMutableArray *bookmarkArray = [NSMutableArray new];
    
    for (ASBookmark *bookmark in dataArray) {
        
        NSDictionary *dicBookmark = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:bookmark.id],@"id",bookmark.text,@"title", [NSNumber numberWithBool:bookmark.state], @"state", nil];
        
        [bookmarkArray addObject:dicBookmark];
    }
    return bookmarkArray;
}

@end
