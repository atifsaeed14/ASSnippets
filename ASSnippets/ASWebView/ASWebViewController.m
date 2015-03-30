//
//  ASWebViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/12/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASWebViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ASWebViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *textView;


// http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing
- (IBAction)postToTwitter:(id)sender;
- (IBAction)postToFacebook:(id)sender;

// http://nshipster.com/uiactivityviewcontroller/
@property (nonatomic, strong) UIActivityViewController *activityViewController;

@end

@implementation ASWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* load data from url */
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html" inDirectory:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *Url = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:htmlString baseURL:Url];
    
//    NSURL *htmlStr = [[NSBundle mainBundle]  URLForResource: @"demo"     withExtension:@"html"];
//    NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc] initWithFileURL:htmlStr
//                                                                                       options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
//                                                                            documentAttributes:nil
//                                                                                         error:nil];
//    _textView.attributedText = stringWithHTMLAttributes; // attributedText field!
    
    
    
    NSString *aya = @"خَتَمَ اللَّهُ عَلَىٰ قُلُوبِهِمْ وَعَلَىٰ سَمْعِهِمْ ۖ وَعَلَىٰ أَبْصَارِهِمْ غِشَاوَةٌ ۖ وَلَهُمْ عَذَابٌ عَظِيمٌ(٧)";
    NSLog(@"%@",aya);
    
    [ASUtility fontsList];
    
    UIFont *font = [UIFont fontWithName:@"KFGQPC Uthmanic Script HAFS" size:20];
    font = [UIFont fontWithName:@"KFGQPCUthmanicScriptHAFS" size:20];
    font = [UIFont fontWithName:@"me_quran" size:20];
    font = [UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:20];
    //font = [UIFont fontWithName:@"BFantezy" size:20];
    //font = [UIFont fontWithName:@"DiwanMishafi" size:20];
    //font = [UIFont fontWithName:@"Scheherazade" size:20];

    
    _label.font = font;
    //_label.text = aya;
    
}

- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"First post from my iPhone app"];
        
        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        [controller addImage:[UIImage imageNamed:@"bg1.jpg"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}


- (IBAction)postToTwitter:(id)sender {
    
    if ([SLComposeViewController
         isAvailableForServiceType:SLServiceTypeTwitter]){
        
        SLComposeViewController *controller =
        [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:@"MacBook Airs are amazingly thin!"];
        [controller addImage:[UIImage imageNamed:@"MacBookAir"]];
        [controller addURL:[NSURL URLWithString:@"http://www.apple.com/"]];
        
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Completed");
        };
        
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"The twitter service is not available");
    }

    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)TweetPressed{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"This is a tweet!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)FBPressed{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPostSheet setInitialText:@"This is a Facebook post!"];
        [self presentViewController:fbPostSheet animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Send SMS

// For the message body, it supports textual content only.
// http://www.appcoda.com/ios-programming-send-sms-text-message/

- (IBAction)showSMS {
    
    NSString *file;
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"<h1>iOS</h2> programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) handleShare:(id)paramSender{
    
/*    if ([self.textField.text length] == 0){
        NSString *message = @"Please enter a text and then press Share";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
  */
    
    self.activityViewController = [[UIActivityViewController alloc]
                                   initWithActivityItems:@[@"asdfasdf asdf asf sadf sdf sadf saf saf asdf sadf "]
                                   applicationActivities:nil];
    [self presentViewController:self.activityViewController
                       animated:YES
                     completion:^{
                         /* Nothing for now */
                     }];
    
}

@end
