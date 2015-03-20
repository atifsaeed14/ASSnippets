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

@end
