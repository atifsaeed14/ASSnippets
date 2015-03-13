//
//  ApiHTTPClient.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//


// https://api.app.net/stream/0/posts/stream/global
#import "ApiHTTPClientSessioin.h"

static NSString * const APIBaseURLString = @"https://api.app.net/";

@implementation ApiHTTPClientSessioin

+ (instancetype)sharedClient {
    
    static ApiHTTPClientSessioin *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ApiHTTPClientSessioin alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        //sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return sharedClient;
}

#pragma mark - Get GlobalTimelinePost

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[self sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
       
        if (block) {
            block([NSArray arrayWithArray:[JSON valueForKeyPath:@"data"]], nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        if (block) {
            block([NSArray array], error);
        }
        
    }];
}

@end
