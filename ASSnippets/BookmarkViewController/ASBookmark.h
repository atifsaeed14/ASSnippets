//
//  ASBookmark.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "JSONModel.h"

@interface ASBookmark : JSONModel

@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL state;

+ (NSMutableArray *)bookmarkFromPlist:(NSArray *)dataArray;
+ (NSMutableArray *)bookmarkInToPlist:(NSArray *)dataArray;

@end
