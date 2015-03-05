//
//  IQSideMenuController.h
//  IQSideMenu
//
//  Copyright © 2014 Alexander Orlov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

#pragma mark - Built-in calculators for menu width

typedef CGFloat (^IQSideMenuControllerWidthCalculatorBlock)(CGFloat sideMenuControllerWidth);

typedef void (^IQSideMenuControllerAnimationProgressTrackingBlock)(CGFloat openingProgressPercent,
        UIView *menuView,
        UIView *contentView);

//keeps constant width in absolute (pixels)
IQSideMenuControllerWidthCalculatorBlock constantCalculator(CGFloat constantWidth);

//keeps constant dependence of menuWidth from parent width
IQSideMenuControllerWidthCalculatorBlock percentCalculator(CGFloat percentOfParentWidth);

#pragma mark - IQSideMenuController

@interface IQSideMenuController : UIViewController

@property(atomic, strong) UIViewController *menuViewController, *contentViewController;
@property(atomic, strong) IQSideMenuControllerWidthCalculatorBlock menuWidthCalculatorBlock;
@property(atomic, strong) IQSideMenuControllerAnimationProgressTrackingBlock animationProgressTrackingBlock;

#pragma mark - Init

- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController
                  andContentViewController:(UIViewController *)contentViewController;

#pragma mark - Interaction methods

- (void)toggleMenuAnimated:(BOOL)animated;

@end