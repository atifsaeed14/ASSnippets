//
//  ASViewController.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASProtocol.h"
#import <UIKit/UIKit.h>
#import "M13ProgressViewBorderedBar.h"

@interface ASViewController : UIViewController 

@property (nonatomic, retain) IBOutlet M13ProgressViewBorderedBar *progressViewVertical;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) id<ASProtocol> delegate;

@end
