//
//  FSParallaxViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 6/10/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "FSParallaxViewController.h"
#import "FSParallaxTableViewCell.h"

@interface FSParallaxViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FSParallaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageNames = [NSArray new];
    
    self.imageNames = @[@"img01.jpg",
                        @"img02.jpg",
                        @"img03.jpg",
                        @"img04.jpg",
                        @"img05.jpg",
                        @"img06.jpg",
                        @"img07.jpg",
                        @"img08.jpg",
                        @"img09.jpg",
                        @"img10.jpg",
                        @"img11.jpg"];

    
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



- (void)updateImageViewCellOffset:(FSParallaxTableViewCell *)cell
{
    CGFloat imageOverflowHeight = [cell imageOverflowHeight];
    
    CGFloat cellOffset = cell.frame.origin.y - self.tableView.contentOffset.y;
    CGFloat maxOffset = self.tableView.frame.size.height - cell.frame.size.height;
    CGFloat verticalOffset = imageOverflowHeight * (0.5f - cellOffset/maxOffset);
    
    cell.imageOffset = CGPointMake(0.0f, verticalOffset);
}

#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   FSParallaxTableViewCell *cell = (FSParallaxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    static NSString *CellIdentifier = @"FSParallaxTableViewCell";
    
    FSParallaxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FSParallaxTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    
    NSString *imageName = [self.imageNames objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.cellImageViewt.image = image;
    cell.cellLabelt.text = imageName;
    
    cell.clipsToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 150.0f;
}

#pragma mark - UIScrollViewdelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (FSParallaxTableViewCell *cell in self.tableView.visibleCells) {
        [self updateImageViewCellOffset:cell];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateImageViewCellOffset:(FSParallaxTableViewCell *)cell];
}


@end
