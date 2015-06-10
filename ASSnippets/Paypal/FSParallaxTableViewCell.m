//
//  FSParallaxTableViewCell.m
//  ASSnippets
//
//  Created by Atif Saeed on 6/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "FSParallaxTableViewCell.h"

@implementation FSParallaxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGFloat)imageOverflowHeight
{
    return self.cellImageViewt.image.size.height - self.cellImageViewt.frame.size.height;
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    CGRect frame = self.cellImageViewt.frame;
    frame.origin = imageOffset;
    self.cellImageViewt.frame = frame;
}

@end
