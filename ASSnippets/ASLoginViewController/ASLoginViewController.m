//
//  ASLoginViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/19/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "UITextField+Shake.h"
#import "UIView+Shake.h"
#import "ASLoginViewController.h"

@interface ASLoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ASLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Login ViewController";
    /* Desgin */
    // http://www.appdesignvault.com/iphone-flat-ui-design-patterns/
    
    /* shake text field*/
    // https://github.com/andreamazz/UITextField-Shake
    
    
    [@[_username, _password] enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
        [obj.layer setBorderWidth:2];
        [obj.layer setCornerRadius:5];
        [obj.layer setBorderColor:[UIColor colorWithRed:49.0/255.0 green:186.0/255.0 blue:81.0/255.0 alpha:1].CGColor];
        [obj setDelegate:self];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionShake:(id)sender
{
    [self shake];
}

- (void)shake
{
//    [self.username shake:10
//                withDelta:5
//                 andSpeed:0.04
//           shakeDirection:ShakeDirectionHorizontal];
//    
//    [self.password shake:10
//               withDelta:5
//                andSpeed:0.04
//          shakeDirection:ShakeDirectionVertical];
    
    
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        [obj shake:10
         withDelta:5
          andSpeed:0.04
    shakeDirection:ShakeViewDirectionHorizontal];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField != _password) {
        [textField resignFirstResponder];
    } else {
        [self shake];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [obj resignFirstResponder];
        }
    }];
}

// http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setViewMovedUp:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)sender {

    if  (self.scrollView.frame.origin.y < 0)
        [self setViewMovedUp:NO];
}

- (void)setViewMovedUp:(BOOL)movedUp {
    
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (movedUp ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
    [UIView commitAnimations];
}

@end
