//
//  UIAlertView+Simple.m
//
//  Created by Thiago Peres on 6/1/11.
//  Copyright 2011 Thiago Peres. All rights reserved.
//

#import "UIAlertView+Simple.h"

@implementation UIAlertView (Simple)

+ (void)alertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
