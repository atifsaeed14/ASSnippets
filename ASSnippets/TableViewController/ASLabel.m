//
//  ASLabel.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/16/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASLabel.h"

@implementation ASLabel

//  http://stackoverflow.com/questions/3476646/uilabel-text-margin/3476866#3476866

- (void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets insets = {10, 5, 5, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
