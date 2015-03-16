//
//  ASTableViewCell.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/25/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASTableViewCell.h"

@implementation ASTableViewCell

@synthesize aLabel;
@synthesize bLabel;

/* method 2 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ASTableViewCell" owner:self options:nil];
        
        for (id currentObj in topLevelObjects ) {
            if ([currentObj isKindOfClass:[ASTableViewCell class]]) {
                self = (ASTableViewCell *) currentObj;
            }
        }
    } else {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    
    self.aLabel.textColor = [UIColor darkGrayColor];
    self.aLabel.font = [UIFont systemFontOfSize:12.0f];
    //self.aLabel.numberOfLines = 0;
    
    
    self.bLabel.textColor = [UIColor darkGrayColor];
    self.bLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    //self.bLabel.numberOfLines = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /* set frame
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 6.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    CGFloat calculatedHeight = [[self class] detailTextHeight:self.post.text];
    detailTextLabelFrame.size.height = calculatedHeight;
    self.detailTextLabel.frame = detailTextLabelFrame; */
    
    if (![aLabel.text isEqualToString: @"A"])
        aLabel.frame = CGRectMake(aLabel.frame.origin.x, aLabel.frame.origin.y, aLabel.frame.size.width, [ASUtility getLabelHeight:aLabel]+10);
    
    if (![bLabel.text isEqualToString: @"B"] || bLabel.text != nil)
        bLabel.frame = CGRectMake(bLabel.frame.origin.x, aLabel.frame.size.height, bLabel.frame.size.width, [ASUtility getLabelHeight:bLabel]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
