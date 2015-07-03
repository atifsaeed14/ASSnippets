//
//  AKNavigationBar.m
//
//  Created by Thiago Peres on 2/15/12.
//  Copyright (c) 2012 Thiago Peres. All rights reserved.
//

#import "AKNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation AKNavigationBar

@synthesize myBackgroundImage;

- (UIImage*)myBackgroundImage
{
    return [UIImage imageNamed:@"navbar.png"];
}

- (void)drawRect:(CGRect)rect
{    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [super drawRect:rect];
    }
    else {
        [[self myBackgroundImage] drawInRect:rect];
    }
}

- (void)dropShadow
{
    UINavigationBar *navBar = self;
    navBar.layer.masksToBounds = NO;
    navBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    navBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    navBar.layer.shadowRadius = 3.0f;
    navBar.layer.shadowOpacity = 1.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:navBar.bounds];
    navBar.layer.shadowPath = path.CGPath;
}

@end
