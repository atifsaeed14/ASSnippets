//
//  BookmarkViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 2/26/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "ASBookmark.h"
#import "ASBookmarkViewController.h"
#import "AFURLSessionManager.h"
#import "AFDownloadRequestOperation.h"
#import "UIProgressView+AFNetworking.h"
#import "Main.h"

@interface ASBookmarkViewController () <UITableViewDataSource, UITableViewDelegate, ZipArchiveDelegate> {
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

    self.progress.progress = 0.0;
    
//    [self downloadVideoFromURL:@"http://dl.dropbox.com/u/97700329/GCDExample-master.zip" withProgress:^(CGFloat progress) {
//        self.progress.progress = progress;
//        NSLog(@"%f",progress);
//    } completion:^(NSURL *filePath) {
//        
//        
//    } onError:^(NSError *error) {
//        
//        
//    }];
    
    [self downloadFile];
    
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

- (void)downloadFile {
    
    NSString *cfilePath = [[ASUtility applicationDocumentsDirectory] stringByAppendingPathComponent:@"GCDExample-master.zip"];
    
    /* or to get path using this */
    //NSString *dataFile = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/"];
    //NSLog(@"dataFile: %@",dataFile);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:cfilePath]) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:@"http://dl.dropbox.com/u/97700329/GCDExample-master.zip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", cfilePath);
        }];
        
        [self.progress setProgressWithDownloadProgressOfTask:downloadTask animated:YES];

        [downloadTask resume];
        
    }
}

// http://tarikfayad.com/afnetworking-downloading-files-with-progress/

-(void)downloadVideoFromURL:(NSString *)URL withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock {
    
    //Configuring the session manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //Most URLs I come across are in string format so to convert them into an NSURL and then instantiate the actual request
    NSURL *formattedURL = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:formattedURL];
    
    //Watch the manager to see how much of the file it's downloaded
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //Convert totalBytesWritten and totalBytesExpectedToWrite into floats so that percentageCompleted doesn't get rounded to the nearest integer
        CGFloat written = totalBytesWritten;
        CGFloat total = totalBytesExpectedToWrite;
        CGFloat percentageCompleted = written/total;
        
        //Return the completed progress so we can display it somewhere else in app
        progressBlock(percentageCompleted);
    }];
    
    //Start the download
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //Getting the path of the document directory
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fullURL = [documentsDirectoryURL URLByAppendingPathComponent:@"GCDExample-master.zip"];
        
        //If we already have a video file saved, remove it from the phone
        [self removeVideoAtPath:fullURL];
        return fullURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            //If there's no error, return the completion block
            completionBlock(filePath);
        } else {
            //Otherwise return the error block
            errorBlock(error);
        }
        
    }];
    
    [downloadTask resume];
}

- (void)removeVideoAtPath:(NSURL *)filePath {
    NSString *stringPath = filePath.path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:stringPath]) {
        [fileManager removeItemAtPath:stringPath error:NULL];
    }
}

- (void) unZip {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:@"/Documents"];
    
//    NSString *zipPath = Your zip file path;
    
 //   [SSZipArchive unzipFileAtPath:zipPath toDestination:outputPath delegate:self];
    
    
}

@end
