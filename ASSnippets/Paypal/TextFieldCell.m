//
//  TextFieldCell.m
//  ASSnippets
//
//  Created by Atif Saeed on 8/12/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
        
        for (id currentObj in topLevelObjects ) {
            if ([currentObj isKindOfClass:[TextFieldCell class]]) {
                self = (TextFieldCell *) currentObj;
            }
        }
    } else {
        return nil;
    }
    
    _inputTextField.textColor = [UIColor darkGrayColor];
    _inputTextField.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

@end
