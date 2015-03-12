//
//  ASWebViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/12/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASWebViewController.h"
#import <Social/Social.h>

@interface ASWebViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *textView;


// http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing
- (IBAction)postToTwitter:(id)sender;
- (IBAction)postToFacebook:(id)sender;

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
    
    NSURL *htmlStr = [[NSBundle mainBundle]  URLForResource: @"demo"     withExtension:@"html"];
    NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc] initWithFileURL:htmlStr
                                                                                       options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                            documentAttributes:nil
                                                                                         error:nil];
    _textView.attributedText = stringWithHTMLAttributes; // attributedText field!
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
