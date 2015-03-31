//
//  ASDetailTableView.m
//  ASSnippets
//
//  Created by Atif Saeed on 3/4/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASDetailTableView.h"

#import "Post.h"
#import "User.h"

#import "AppDelegate.h"
#import "DetailTableViewCell.h"
#import "ApiHTTPClientSessioin.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

#import "UserClient.h"
#import "UserModel.h"

@interface ASDetailTableView () {
   
}
@property (readwrite, nonatomic, strong) NSArray *posts;

@end

@implementation ASDetailTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Detail View Controller", nil);
    self.tableView.rowHeight = 70.0f;
    [self reload:nil];
    

    [_tabbar setTintColor:[UIColor whiteColor]];
    [_tabbar setBarTintColor:[UIColor whiteColor]];
    _tabbar.translucent = false;
    [_tabbar setAlpha:1.0];

    
    UITabBarItem *tabBarItem = [_tabbar.items objectAtIndex:0];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"tHome"];
    UIImage *selectedImage = [UIImage imageNamed:@"tHome"];
    
    [tabBarItem setImage: [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage: selectedImage];
    [tabBarItem setTitle:@"Home"];
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

#pragma mark - Block Sample


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
    return (NSInteger)[self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DetailTableViewCell";
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell.more addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.post = [self.posts objectAtIndex:(NSUInteger)indexPath.row];
    cell.more.tag = indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//        return [PostTableViewCell heightForCellWithPost:[self.posts objec tAtIndex:(NSUInteger)indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)buttonClick:(id)senderParam {
    
    NSLog(@"%@",senderParam);
    
//    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:3 inSection:0];
//    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
//    [myUITableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    
}


@end
