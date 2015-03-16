//
//  ASTableViewCell.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/25/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASLabel.h"
#import <UIKit/UIKit.h>

@interface ASTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet ASLabel *aLabel;
@property (nonatomic, strong) IBOutlet ASLabel *bLabel;

@end


