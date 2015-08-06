//
//  ASPaypalViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 5/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASPaypalViewController.h"
#import "PayPalMobile.h"
#import "GMMapViewController.h"
#import "FSParallaxViewController.h"
#import "PagerViewController.h"

@interface ASPaypalViewController () <PayPalPaymentDelegate,UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {

    NSMutableArray* bandArray;
    
}

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation ASPaypalViewController


#pragma mark -
#pragma mark UINavigationControllerDelegate

- (IBAction)childViewController:(id)sender {
    [self.navigationController pushViewController:[PagerViewController new] animated:YES];
}


- (IBAction)parallaxSender:(id)sender {

    FSParallaxViewController *vc = [FSParallaxViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _textFieldPV.text = [bandArray objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [bandArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [bandArray objectAtIndex:row];
}




//| ----------------------------------------------------------------------------
//  Force the navigation controller to defer to the topViewController for
//  its supportedInterfaceOrientations.  This allows some of the demos
//  to rotate into landscape while keeping others in portrait.
//
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return navigationController.topViewController.supportedInterfaceOrientations;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openMapView)];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Paypal";
    
    _textLabel.text = NSLocalizedString(@"text", @"translator english");
    
    // Set up payPalConfig
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = YES;
    _payPalConfiguration.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);

    
    /* drop down */
    // create the array of data
    bandArray = [[NSMutableArray alloc] init];
    
    // add some sample data
    [bandArray addObject:@"Offsprings"];
    [bandArray addObject:@"Radiohead"];
    [bandArray addObject:@"Muse"];
    [bandArray addObject:@"R.E.M."];
    [bandArray addObject:@"The Killers"];
    [bandArray addObject:@"Social Distortion"];
    
    // bind yourTextField to DownPicker
    self.downPicker = [[DownPicker alloc] initWithTextField:self.dropdoweField withData:bandArray];
    
    
    /* Picker View */
    
    _textFieldPV.placeholder = @"Tap to choose...";
    
    
    // show the arrow image
    _textFieldPV.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow.png"]];
    _textFieldPV.rightView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldPV.rightView.clipsToBounds = YES;
    
    
    [self setArrowImage:[UIImage imageNamed:@"downArrow.png"]];
//    [self showArrowImage:YES];
    
}

- (void) setArrowImage:(UIImage*)image {
    [(UIImageView*)_textFieldPV.rightView setImage:image];
}


- (void)openMapView {
    GMMapViewController *vc = [GMMapViewController new];
    [self.navigationController pushViewController:vc animated:YES];

    
    /* http://stackoverflow.com/questions/630265/iphone-uiview-animation-best-practice?rq=1
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [UIView commitAnimations]; */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Receive Single Payment

- (IBAction)pay {
    // Remove our last completed payment, just for demo purposes.
//    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
    NSArray *items = @[item1, item2, item3];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Hipster clothing";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfiguration
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    
    [self verifyCompletedPayment:completedPayment];

//    self.resultText = [completedPayment description];
//    [self showSuccess];
//    
//    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
//    self.resultText = nil;
//    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    
        NSLog(@"PayPal Payment Success!");
        NSLog(@"Description : %@", [completedPayment description]);
    
      //  [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
        [self dismissViewControllerAnimated:YES completion:nil];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


@end
