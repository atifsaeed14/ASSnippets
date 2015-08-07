//
//  PagerViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 8/6/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "PagerViewController.h"
#import "ASLoginViewController.h"
#import "ASDetailTableView.h"
#import "ASCollectionViewController.h"

@interface PagerViewController () {
    UIViewController *currentVC;
    int selectedIndex;
    ASLoginViewController *loginVC;
    ASDetailTableView *detailVC;
    ASCollectionViewController *collectionVC;
}

@end
//  https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loginVC = [ASLoginViewController new];
    detailVC = [ASDetailTableView new];
    collectionVC = [ASCollectionViewController new];
    currentVC = loginVC;
    [self displayContentController:currentVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)third:(id)sender {
    if (currentVC != collectionVC) {
        [self hideContentController:currentVC];
        currentVC = collectionVC;
        [self displayContentController:currentVC];
    }
}

- (IBAction)second:(id)sender {
    if (currentVC != detailVC) {
        [self hideContentController:currentVC];
        currentVC = detailVC;
        [self displayContentController:currentVC];
    }
}

- (IBAction)first:(id)sender {
    
    if (currentVC != loginVC) {
        [self hideContentController:currentVC];
        currentVC = loginVC;
        [self displayContentController:currentVC];
    }
}

- (void) displayContentController: (UIViewController*) content;
{
    
    [self addChildViewController:content];                 // 1
    content.view.frame = self.containerView.bounds;
    //////tableViewController.view.frame = self.contentView.bounds;
    // content.view.frame = [self frameForContentController]; // 2

    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

@end
