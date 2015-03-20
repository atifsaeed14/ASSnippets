//
//  DetailTableViewCell.h
//  ASSnippets
//
//  Created by Atif Saeed on 3/20/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "Post.h"
#import "User.h"
#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *more;

@property (nonatomic, strong) Post *post;

@end
