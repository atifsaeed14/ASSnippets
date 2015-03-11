// Post.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Post.h"
#import "User.h"

@implementation Post

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

+ (NSMutableArray *)setData:(NSArray *)dataArray {
    
    NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[dataArray count]];
    for (NSDictionary *attributes in dataArray) {
        Post *post = [[Post alloc] initWithAttributes:attributes];
        [mutablePosts addObject:post];
    }
    return mutablePosts;
}

+ (NSMutableArray *)retrieveItems:(NSArray *)dataArray {
    
    NSMutableArray *mutablePosts = [NSMutableArray new];
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Post *post = [[Post alloc] initWithAttributes:obj];
        [mutablePosts addObject:post];
    }];
    
    return mutablePosts;
}


-(NSArray *)imagesFromContent {
    
    if (self.content) {
        return [self imagesFromHTMLString:self.content];
    }
    
    return nil;
}

#pragma mark - retrieve images from html string using regexp (private methode)

-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr
{
    NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex enumerateMatchesInString:htmlstr
                            options:0
                              range:NSMakeRange(0, htmlstr.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             [imagesURLStringArray addObject:[htmlstr substringWithRange:result.range]];
                         }];
    
    return [NSArray arrayWithArray:imagesURLStringArray];
}


@end
