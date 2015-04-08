//
//  ASCollectionViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 4/2/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCollectionViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
