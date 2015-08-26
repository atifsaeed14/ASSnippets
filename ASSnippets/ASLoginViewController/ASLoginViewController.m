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
#import <CoreImage/CoreImage.h>
#import "CLWeeklyCalendarView.h"
#import "LGHelper.h"

@interface ASLoginViewController () <UITextFieldDelegate, UIScrollViewDelegate, CLWeeklyCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation ASLoginViewController


#pragma mark - SlideNavigationController Methods -


//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return YES;
//}

# pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.calendarView];

    
    /**********Automatic screen recording**********/
    self.screenName = @"Clock ViewController";
    
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
    
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = closeItem;
    
    [_imageView setImage:_screenShot];
    
    // http://stackoverflow.com/questions/3844557/uiview-shake-animation
    
}

- (void)dismissViewController {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
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
    [self.username shake:10
                withDelta:5
                 andSpeed:0.04
           shakeDirection:ShakeDirectionHorizontal];
    
    [self.password shake:10
               withDelta:5
                andSpeed:0.04
          shakeDirection:ShakeDirectionVertical];
    
    
//    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
//        [obj shake:10
//         withDelta:5
//          andSpeed:0.04
//    shakeDirection:ShakeViewDirectionHorizontal];
//    }];

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

- (IBAction)pickerView:(id)sender {
    
    
//    [[LGHelper sharedHelper] imagePickerControllerShowWithActionSheetInView:self.view inViewController:self animated:YES setupHandler:^(UIImagePickerController *imagePickerController) {
//        
//    } presentCompletionHandler:^{
//        
//    } completionHandler:^(UIImage *image) {
//        
//    } dismissCompletionHandler:^{
//        
//    }];
    
    
    [[LGHelper sharedHelper] imagePickerControllerShowWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary inViewController:self animated:YES setupHandler:^(UIImagePickerController *imagePickerController) {
        
        
    } presentCompletionHandler:^{
        
        
    } completionHandler:^(UIImage *image) {
        
        
    } dismissCompletionHandler:^{
        
        
    }];
}

@end
