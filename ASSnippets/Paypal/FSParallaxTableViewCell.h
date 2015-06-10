//
//  FSParallaxTableViewCell.h
//  ASSnippets
//
//  Created by Atif Saeed on 6/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSParallaxTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *cellImageViewt;
@property (weak, nonatomic) IBOutlet UILabel *cellLabelt;
- (CGFloat)imageOverflowHeight;

- (void)setImageOffset:(CGPoint)imageOffset;

@end
