//
//  ASNWViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASNWViewController.h"

#import "Post.h"
#import "AppDelegate.h"
#import "PostTableViewCell.h"
#import "ApiHTTPClientSessioin.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

#import "UserClient.h"
#import "UserModel.h"

@interface ASNWViewController () {
    UserClient *_userClient;
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
    
    
    
    self.title = NSLocalizedString(@"AFNetworking", nil);
    
    self.tableView.rowHeight = 70.0f;
    
//    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
//    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    [self reload:nil];
    
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return (NSInteger)[self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.post = [self.posts objectAtIndex:(NSUInteger)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PostTableViewCell heightForCellWithPost:[self.posts objectAtIndex:(NSUInteger)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
