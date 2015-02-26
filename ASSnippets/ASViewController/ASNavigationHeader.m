//
//  ASNavigationHeader.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASNavigationHeader.h"

@implementation ASNavigationHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ASNavigationHeader" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

@end
