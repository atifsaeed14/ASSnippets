//
//  ASUtility.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASUtility.h"

@implementation ASUtility

+ (CGFloat)getLabelHeight:(UILabel *)label {
    /* http://stackoverflow.com/questions/22014062/get-the-nsstring-height-in-ios-7 */
    
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height + 5;
}

+ (NSString *)macAddress {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
@end
