//
//  AKNavigationBar.h
//
//  Created by Thiago Peres on 2/15/12.
//  Copyright (c) 2012 Thiago Peres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKNavigationBar : UINavigationBar
{
    UIImage *myBackgroundImage;
}

@property (strong, nonatomic) UIImage *myBackgroundImage;

- (UIImage*)myBackgroundImage;
- (void)dropShadow;

@end
