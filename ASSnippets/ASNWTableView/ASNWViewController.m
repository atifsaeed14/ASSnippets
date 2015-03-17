//
//  ASNWViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASNWViewController.h"

#import "Post.h"
#import "User.h"

#import "AppDelegate.h"
#import "PostTableViewCell.h"
#import "ApiHTTPClientSessioin.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

#import "UserClient.h"
#import "UserModel.h"

@interface ASNWViewController () {
    UserClient *_userClient;
    
    BOOL isSearch;
   NSArray *searchResults;
}
@property (readwrite, nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSString *(^blockAsAMemberVar)(void);
+ (void)isBlock:(void(^)(NSArray *posts, NSError *error))block;
@property (strong, nonatomic) NSArray* jokes;


@end

@implementation ASNWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self download];
    
    isSearch = NO;
    searchResults = [[NSArray alloc] init];
    
    self.title = NSLocalizedString(@"AFNetworking", nil);
    
    self.tableView.rowHeight = 70.0f;
    
//    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
//    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    [self reload:nil];
    
    [self createFooterViewForTable];
    
    /* test http api clien manager */
    _userClient = [UserClient client];

    [_userClient getUser:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [responseObject succeeded] ) {
            UserModel *user = [[UserModel alloc] initWithDictionary:responseObject[@"user"]];
            
            NSLog(@"------------------------------");
            NSLog(@"• %@", user.userId.stringValue);
            NSLog(@"• %@", user.username);
            NSLog(@"• %@", user.name);
            NSLog(@"• %@", user.surname);
            NSLog(@"• %@", user.about);
            NSLog(@"• %@", user.git);
            NSLog(@"------------------------------");
        }
    }];
    
    [_userClient getError:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if ( ![responseObject succeeded] ) {
            NSLog(@"------------------------------");
            NSLog(@"• %@", [responseObject errorMessage] );
            NSLog(@"------------------------------");
        }
    }];
    
    /* block learn */
    // returnType(^blockName)(Parameters)
    void(^blockName)(void);
    blockName = ^(void) {
        NSLog(@"What's up, Doc?");
    };
    
    _blockAsAMemberVar = ^(void){
        return @"This block is declared as a member variable!";
    };
    
    //-(returnType)methodNameWithParams:(parameterType)parameterName ...<more params>... andCompletionHandler:(void(^)(<any block params>))completionHandler;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view setAlpha:0.5];
                     } completion:^(BOOL finished) {
                         NSLog(@"Animation is over.");
                     }];
 
    
    
    [self retrieveGooglePlaceInformation:@"" withCompletion:^(NSArray * results) {
//        [self.localSearchQueries addObjectsFromArray:results];
//        NSDictionary *searchResult = @{@"keyword":self.substring,@"results":results};
//        [self.pastSearchResults addObject:searchResult];
//        [self.tableView reloadData];
        
    }];

    
}


- (void)showNextJoke {
    
    [UIView animateWithDuration:1.0 animations:^{
     //   self.label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideJoke) withObject:nil afterDelay:5.0];
    }];
}

- (void)hideJoke {
    [UIView animateWithDuration:1.0 animations:^{
   //     self.label.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self showNextJoke];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         [self.view setAlpha:1.0];
                     } completion:^(BOOL finished) {
                         NSLog(@"Animation is over.");
                     }];
}

#pragma mark - Private method implementation

- (void)download {
    
    // Prepare the URL that we'll get the neighbour countries from.
    NSString *URLString = [NSString stringWithFormat:@"https://api.app.net/stream/0/posts/stream/global"];
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    // Download the data.
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data, NSError *error, BOOL success) {
  
        // Make sure that there is data.
        if (data != nil) {
            
            // Convert the returned data into a dictionary.
            NSError *error;
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                
                NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];

              //  self.countryDetailsDictionary = [[returnedDict objectForKey:@"geonames"] objectAtIndex:0];
                
                // Set the country name to the respective label.
              //  self.lblCountry.text = [NSString stringWithFormat:@"%@ (%@)", [self.countryDetailsDictionary objectForKey:@"countryName"], [self.countryDetailsDictionary objectForKey:@"countryCode"]];
                
                // Reload the table view.
              //  [self.tblCountryDetails reloadData];
                
                // Show the table view.
              //  self.tblCountryDetails.hidden = NO;
            }


        }
        
    }];
}


#pragma mark - Block Sample

+ (void)isBlock:(void(^)(NSArray *posts, NSError *error))block {
    
    if (block) {
        block(nil, nil);
    }
}

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [ASUtility showMBProgressInView:self.view WithText:@"Testing..."];
    
    NSURLSessionTask *task = [ApiHTTPClientSessioin globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.posts = [Post setData:posts];
            [self.tableView reloadData];
        }
        //[ASUtility hideMBProgressView];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    //[self.refreshControl setRefreshingWithStateOfTask:task];
}

- (void)sideMenu {
    [[AppDelegate appDelegate].sideMenuController toggleMenuAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    
    if (isSearch) {
        return (NSInteger)[searchResults count];
    } else {
        return (NSInteger)[self.posts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (isSearch) {
        cell.post = [searchResults objectAtIndex:(NSUInteger)indexPath.row];
    } else {
        cell.post = [self.posts objectAtIndex:(NSUInteger)indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isSearch) {
        return [PostTableViewCell heightForCellWithPost:[searchResults objectAtIndex:(NSUInteger)indexPath.row]];
    } else {
        return [PostTableViewCell heightForCellWithPost:[self.posts objectAtIndex:(NSUInteger)indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // http://www.peterfriese.de/using-nspredicate-to-filter-data/
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.user.username contains[cd] %@", searchBar.text];
    searchResults = [self.posts filteredArrayUsingPredicate:resultPredicate];
    
    [_searchBar resignFirstResponder];
    isSearch = YES;
    [self.tableView reloadData];
    [_searchBar setShowsCancelButton:YES animated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    isSearch = NO;
    [_tableView reloadData];
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)createFooterViewForTable{
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 500, 320, 70)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powered-by-google"]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    imageView.frame = CGRectMake(110,10,85,12);
    [footerView addSubview:imageView];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Google API Requests


-(void)retrieveGooglePlaceInformation:(NSString *)searchWord withCompletion:(void (^)(NSArray *))complete{
    NSString *searchWordProtection = [searchWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    if (searchWordProtection.length != 0) {
//        
//        CLLocation *userLocation = self.locationManager.location;
//        NSString *currentLatitude = @(userLocation.coordinate.latitude).stringValue;
//        NSString *currentLongitude = @(userLocation.coordinate.longitude).stringValue;
//        
//        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500&language=en&key=%@",searchWord,currentLatitude,currentLongitude,apiKey];
//        NSLog(@"AutoComplete URL: %@",urlString);
//        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSArray *results = [jSONresult valueForKey:@"predictions"];
//            
//            if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]){
//                if (!error){
//                    NSDictionary *userInfo = @{@"error":jSONresult[@"status"]};
//                    NSError *newError = [NSError errorWithDomain:@"API Error" code:666 userInfo:userInfo];
//                    complete(@[@"API Error", newError]);
//                    return;
//                }
//                complete(@[@"Actual Error", error]);
//                return;
//            }else{
//                complete(results);
//            }
//        }];
//        
//        [task resume];
//    }
    
}

-(void)retrieveJSONDetailsAbout:(NSString *)place withCompletion:(void (^)(NSArray *))complete {
//    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",place,apiKey];
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSArray *results = [jSONresult valueForKey:@"result"];
//        
//        if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]){
//            if (!error){
//                NSDictionary *userInfo = @{@"error":jSONresult[@"status"]};
//                NSError *newError = [NSError errorWithDomain:@"API Error" code:666 userInfo:userInfo];
//                complete(@[@"API Error", newError]);
//                return;
//            }
//            complete(@[@"Actual Error", error]);
//            return;
//        }else{
//            complete(results);
//        }
//    }];
//    
//    [task resume];
}



@end
