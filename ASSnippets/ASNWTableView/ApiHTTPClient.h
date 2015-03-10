//
//  ApiHTTPClient.h
//  ASSnippets
//
//  Created by Atif Saeed on 3/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ApiHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
