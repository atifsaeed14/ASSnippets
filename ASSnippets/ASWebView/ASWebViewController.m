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
#import "NSString+EMAdditions.h"
#import "EMStringStylingConfiguration.h"

@interface ASWebViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *texViewHTML;

@property (weak, nonatomic) IBOutlet UITextView *textView;


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
    
    
    / Setup styling for demo.
        
    /**
     *  Seting up styling needs to be done ONE time only to use througout entire app. EMStringStylingConfiguration is a singleton and will help you keep your design
     *  consistent.
     */
        
        // Ideally, this should not be in a specific view controller, but a more general object like where you setup configuration for your app.
        // Setup specific font for default, strong and emphasis text
        [EMStringStylingConfiguration sharedInstance].defaultFont  = [UIFont fontWithName:@"Avenir-Light" size:15];
    [EMStringStylingConfiguration sharedInstance].strongFont   = [UIFont fontWithName:@"Avenir" size:15];
    [EMStringStylingConfiguration sharedInstance].emphasisFont = [UIFont fontWithName:@"Avenir-LightOblique" size:15];
    
    
    // Then for the demo I created a bunch of custom styling class to provide examples
    
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<code>"];
    aStylingClass.color           = [UIColor colorWithWhite:0.151 alpha:1.000];
    aStylingClass.font            = [UIFont fontWithName:@"Courier" size:14];
    aStylingClass.attributes      = @{NSBackgroundColorAttributeName : [UIColor colorWithWhite:0.901 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in RED
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<red>"];
    aStylingClass.color = [UIColor colorWithRed:0.773 green:0.000 blue:0.263 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in GREEN
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<green>"];
    aStylingClass.color = [UIColor colorWithRed:0.269 green:0.828 blue:0.392 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text with stroke
    aStylingClass            = [[EMStylingClass alloc] initWithMarkup:@"<stroke>"];
    aStylingClass.font       = [UIFont fontWithName:@"Avenir-Black" size:26];
    aStylingClass.color      = [UIColor whiteColor];
    aStylingClass.attributes = @{NSStrokeWidthAttributeName: @-6,
                                 NSStrokeColorAttributeName:[UIColor colorWithRed:0.111 green:0.568 blue:0.764 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    /**
     *  END of setup to be done only once througout entire app.
     */

    
    NSString *text;

    text = @"<h4>About!  E &apos! MString</h4>\n<p><strong>EMString</strong> stands for <em><strong>E</strong>asy <strong>M</strong>arkup <strong>S</strong>tring</em>. I hesitated to call it SONSAString : Sick Of NSAttributedString...</p>\n<p>Most of the time if you need to display a text with different styling in it, like \"<strong>This text is bold</strong> but then <em>italic.</em>\", you would use an <code>NSAttributedString</code> and its API. Same thing if suddenly your text is <green><strong>GREEN</strong></green> and then <red><strong>RED</strong></red>...</p><p>Personnaly I don't like it! It clusters my classes with a lot of boilerplate code to find range and apply style, etc...</p>\n<p>This is what <strong>EMString</strong> is about. Use the efficient <u>HTML markup</u> system we all know and get an iOS string stylized in one line of code and behave like you would expect it to.</p>\n<h1>h1 header</h1><h2>h2 header</h2><h3>h3 header</h3><stroke>Stroke text</stroke>\n<strong>strong</strong>\n<em>emphasis</em>\n<u>underline</u>\n<s>strikethrough</s>\n<code>and pretty much whatever you think of...</code>";
    
    // Set string to textView with .attributedString to apply styling.
    self.texViewHTML.attributedText = text.attributedString;
    
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
