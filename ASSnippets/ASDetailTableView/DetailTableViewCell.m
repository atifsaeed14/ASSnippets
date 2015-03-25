//
//  DetailTableViewCell.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/20/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.title.text = _post.user.username;
    self.detail.text = _post.text;
    [self.iconImage setImageWithURL:_post.user.avatarImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    [self setNeedsLayout];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
//    self.textLabel.frame = CGRectMake(70.0f, 6.0f, 240.0f, 20.0f);
//    
//    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
//    CGFloat calculatedHeight = [[self class] detailTextHeight:self.post.text];
//    detailTextLabelFrame.size.height = calculatedHeight;
//    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
