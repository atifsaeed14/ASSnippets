//
//  BookmarkViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASBookmark.h"
#import "ASBookmarkViewController.h"

@interface ASBookmarkViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *dataArray;
    NSString *filePath;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation ASBookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"To Do List";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(callAddForm)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(callEditTable)];
    dataArray = [NSMutableArray new];
    [self getPlistData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callAddForm {
}

- (void)callEditTable {
    self.tableView.editing = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(exitEditingMode)];
}

- (void)exitEditingMode {
    self.tableView.editing = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(callEditTable)];
}

- (void)getPlistData {
    
    filePath = [[ASUtility applicationDocumentsDirectory] stringByAppendingPathComponent:@"Bookmark.plist"];
    
    /* or to get path using this */
    //NSString *dataFile = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/"];
    //NSLog(@"dataFile: %@",dataFile);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if(![fileManager fileExistsAtPath:filePath]) {
        
        /* get a path to your plist created before in bundle directory (by Xcode) */
        NSString *resPath = [[NSBundle mainBundle] pathForResource:@"Bookmark" ofType:@"plist"];
        //NSLog(@"resPath: %@",resPath);
        
        /* copy this plist to your documents directory */
        [fileManager copyItemAtPath:resPath toPath:filePath error:nil];
    }
    
    /* copy plist item into array */
    NSArray *tem = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    //NSLog(@"%@",self.listItem);
    
    dataArray = [ASBookmark bookmarkFromPlist:tem];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ASBookmark *bookmark = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.text;
    if (bookmark.state)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASBookmark *bookmark = [dataArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        bookmark.state = YES;
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        bookmark.state = NO;
    }
    
    [dataArray replaceObjectAtIndex:indexPath.row withObject:bookmark];
    //NSLog(@"%@",temDic);
    
    //[dataArray writeToFile:filePath atomically:YES];
    
    
    NSArray *tem = [ASBookmark bookmarkInToPlist:dataArray];
    [tem writeToFile:filePath atomically:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row < 2) {
//        return UITableViewCellEditingStyleNone;
//    }else {
        return UITableViewCellEditingStyleNone;
//    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < [dataArray count]) {
            /* first remove this object from the source */
            [dataArray removeObjectAtIndex:indexPath.row];
            /* remove this from plist */
            //[dataArray writeToFile:filePath atomically:YES];
            
            NSArray *tem = [ASBookmark bookmarkInToPlist:dataArray];
            [tem writeToFile:filePath atomically:YES];
            
            /* then remove the associated cell from the Table View */
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

@end
