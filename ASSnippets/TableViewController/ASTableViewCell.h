//
//  ASTableViewCell.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/25/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *testLable;
@property (nonatomic, weak) IBOutlet UILabel *textLable;

//+ (CGFloat)heightForCellWithPost:(Post *)post;

@end
