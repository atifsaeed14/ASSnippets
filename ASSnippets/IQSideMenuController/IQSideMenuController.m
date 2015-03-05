//
//  IQSideMenuController.m
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

#import "IQSideMenuController.h"

static const CGFloat initialMenuWidthPercent = 0.85;

#pragma mark - Built-in calculators for menu width

IQSideMenuControllerWidthCalculatorBlock constantCalculator(CGFloat constantWidth) {
    return ^CGFloat(CGFloat sideMenuControllerWidth) {
        if ((constantWidth > 0.0) && (constantWidth < sideMenuControllerWidth)) {
            return constantWidth;
        }

        return sideMenuControllerWidth * initialMenuWidthPercent;
    };
}

IQSideMenuControllerWidthCalculatorBlock percentCalculator(CGFloat percentOfParentWidth) {
    return ^CGFloat(CGFloat sideMenuControllerWidth) {
        if ((percentOfParentWidth < 1.0) && (percentOfParentWidth > 0.0)) {
            return sideMenuControllerWidth * percentOfParentWidth;
        }

        return sideMenuControllerWidth * initialMenuWidthPercent;
    };
}

#pragma mark - Internal Classes

@interface IQSideMenuScrollView : UIScrollView
@end

@implementation IQSideMenuScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [[self superview] pointInside:[self convertPoint:point toView:[self superview]] withEvent:event];
}

@end

#pragma mark - IQSideMenuController

@interface IQSideMenuController () <UIScrollViewDelegate>
@end

@implementation IQSideMenuController {
    UIViewController *_menuViewController;
    UIViewController *_contentViewController;
    CGFloat _currentPercentOfAnimation;
    IQSideMenuScrollView *_scrollView;
}

#pragma mark - Setters and Getters

- (UIViewController *)menuViewController {
    @synchronized (self) {
        return _menuViewController;
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    @synchronized (self) {
        [menuViewController removeFromParentViewController];
        [[menuViewController view] removeFromSuperview];

        [_menuViewController removeFromParentViewController];
        [[_menuViewController view] removeFromSuperview];

        _menuViewController = menuViewController;

        if ([self isViewLoaded]) {
            [self insertMenuView];
        }
    }
}

- (UIViewController *)contentViewController {
    @synchronized (self) {
        return _contentViewController;
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    @synchronized (self) {
        [contentViewController removeFromParentViewController];
        [[contentViewController view] removeFromSuperview];

        [_contentViewController removeFromParentViewController];
        [[_contentViewController view] removeFromSuperview];

        _contentViewController = contentViewController;

        if ([self isViewLoaded]) {
            [self insertContentView];
        }
    }
}

#pragma mark - Init

- (void)designedInit {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

#pragma mark - UIViewController Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self designedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self designedInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self designedInit];
    }
    return self;
}

- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController
                  andContentViewController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        [self designedInit];
        [self setMenuViewController:menuViewController];
        [self setContentViewController:contentViewController];
    }
    return self;
}

- (void)loadView {
    //create main view
    [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]];
    [[self view] setClipsToBounds:YES];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    [[self view] setAutoresizingMask:UIViewAutoresizingNone];

    //internal scrollView
    _scrollView = [[IQSideMenuScrollView alloc] initWithFrame:[[self view] bounds]];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setAutoresizingMask:UIViewAutoresizingNone];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBounces:NO];
    [_scrollView setDirectionalLockEnabled:YES];
    [_scrollView setDelegate:self];

    [[self view] addSubview:_scrollView];

    //insert external subviews if didn`t yet
    [self insertMenuView];
    [self insertContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self respondsToSelector:@selector(addObserver:forKeyPath:options:context:)]) {
        [self addObserver:self forKeyPath:[NSString stringWithFormat:@"frame"] options:NSKeyValueObservingOptionNew context:NULL];
    }
    [self performLayout];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if ([self respondsToSelector:@selector(removeObserver:forKeyPath:)]) {
        [self removeObserver:self forKeyPath:[NSString stringWithFormat:@"frame"]];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self performLayout];
}

- (void)dealloc {
    [self setMenuViewController:nil];
    [self setContentViewController:nil];
    [self setMenuWidthCalculatorBlock:nil];
    [self setAnimationProgressTrackingBlock:nil];

    _scrollView = nil;
}

#pragma mark - Implementation

- (void)insertMenuView {
    if (![_menuViewController view]) {
        return;
    }

    if (!_scrollView) {
        return;
    }

    if ([[_scrollView subviews] containsObject:_menuViewController.view]) {
        return;
    }

    [[_menuViewController view] setAutoresizingMask:UIViewAutoresizingNone];
    [[[_menuViewController view] layer] setShouldRasterize:YES];
    [[[_menuViewController view] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];

    [_scrollView addSubview:[_menuViewController view]];
    [_scrollView sendSubviewToBack:[_menuViewController view]];

    [self addChildViewController:_menuViewController];
    [self performLayout];
}

- (void)insertContentView {
    if (![_contentViewController view]) {
        return;
    }

    if (!_scrollView) {
        return;
    }

    if ([[_scrollView subviews] containsObject:[_contentViewController view]]) {
        return;
    }

    [[_contentViewController view] setAutoresizingMask:UIViewAutoresizingNone];
    [[[_contentViewController view] layer] setShouldRasterize:YES];
    [[[_contentViewController view] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];

    [_scrollView addSubview:[_contentViewController view]];
    [_scrollView bringSubviewToFront:[_contentViewController view]];

    [self addChildViewController:_menuViewController];
    [self performLayout];
}

- (void)performLayout {
    CGFloat contentViewWidth = [[self view] bounds].size.width;
    CGFloat contentViewHeight = [[self view] bounds].size.height;

    IQSideMenuControllerWidthCalculatorBlock currentMenuWidthCalculator = _menuWidthCalculatorBlock;

    if (!currentMenuWidthCalculator) {
        currentMenuWidthCalculator = percentCalculator(initialMenuWidthPercent);
    }

    CGFloat menuViewWidth = currentMenuWidthCalculator([[self view] bounds].size.width);
    CGFloat menuViewHeight = [[self view] bounds].size.height;

    CGFloat currentContentOffsetX = _currentPercentOfAnimation * menuViewWidth;

    CGFloat lowerMenuViewXPosition = 0.0f;
    CGFloat upperMenuViewXPosition = menuViewWidth / 2.0f;

    CGFloat menuViewXPosition = lowerMenuViewXPosition + (upperMenuViewXPosition - lowerMenuViewXPosition) * _currentPercentOfAnimation;

    [[_menuViewController view] setFrame:CGRectMake(menuViewXPosition, 0.0f, menuViewWidth, menuViewHeight)];
    [[_contentViewController view] setFrame:CGRectMake(menuViewWidth, 0.0f, contentViewWidth, contentViewHeight)];

    [_scrollView setContentSize:CGSizeMake(menuViewWidth * 2.0f, [[self view] bounds].size.height)];
    [_scrollView setContentOffset:CGPointMake(currentContentOffsetX, 0.0f)];
    [_scrollView setFrame:CGRectMake(0.0f, 0.0f, menuViewWidth, [[self view] bounds].size.height)];

    [self performAnimationWithPercent:_currentPercentOfAnimation];
}

- (void)updateCurrentPercentOfAnimation {
    if (!_menuViewController) {
        return;
    }

    CGFloat menuViewWidth = [[_menuViewController view] bounds].size.width;
    CGFloat percentOfAnimation = [_scrollView contentOffset].x / menuViewWidth;

    _currentPercentOfAnimation = percentOfAnimation;
}

- (void)performAnimationWithPercent:(CGFloat)animationPercent {
    if (_animationProgressTrackingBlock) {
        _animationProgressTrackingBlock(animationPercent, [_menuViewController view], [_contentViewController view]);
    }
}

#pragma mark - UIScrollView Delegate Implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCurrentPercentOfAnimation];
    [self performLayout];
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([self isViewLoaded] && [object isEqual:[self view]] && [keyPath isEqualToString:@"frame"]) {
        [self performLayout];
    }
}

#pragma mark - Interaction methods

- (void)toggleMenuAnimated:(BOOL)animated {
    if (!_scrollView) {
        return;
    }

    if (_currentPercentOfAnimation == 0.0f) {
        [self closeMenuAnimated:animated];
    } else {
        [self openMenuAnimated:animated];
    }
}

- (void)openMenuAnimated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake(0.0f, [_scrollView contentOffset].y)
                         animated:animated];
}

- (void)closeMenuAnimated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake([[_menuViewController view] bounds].size.width, [_scrollView contentOffset].y)
                         animated:animated];
}

@end