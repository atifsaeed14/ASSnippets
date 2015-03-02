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


/* AFNetworking Sample 2 *

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.postID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.text = [attributes valueForKeyPath:@"text"];
    self.user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
*/

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
