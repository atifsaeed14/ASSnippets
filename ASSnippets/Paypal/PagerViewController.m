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

@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
