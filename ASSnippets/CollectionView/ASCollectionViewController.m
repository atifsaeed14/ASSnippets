//
//  ASCollectionViewController.m
//  ASSnippets
//
//  Created by Atif Saeed on 4/2/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#import "MyCell.h"
#import "ASCollectionViewController.h"
#import "CLWeeklyCalendarView.h"

@interface ASCollectionViewController () <CLWeeklyCalendarViewDelegate>

{
    CATransition *transition;
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;


@implementation ASCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Collection View";
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(setViewFrame)];

    [self.view addSubview:self.calendarView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//https://github.com/clisuper/CLWeeklyCalendarView

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @7,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
                          CLCalendarDayTitleTextColor : [UIColor yellowColor],
                          CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             CLCalendarSelectedDatePrintFontSize : @16.0f,
             CLCalendarBackgroundImageColor : [UIColor purpleColor],
             
             
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
}



#pragma mark -

- (void)setViewFrame {
    
    CGRect frame = _collectionView.frame;
    frame.origin.y = 150;
    frame.size.height = _collectionView.frame.size.height - 150;
    [UIView animateWithDuration:0.5f animations:^{
        _collectionView.frame = frame;
    }];
    
//    transition = [CATransition animation];
//    [transition setDuration:1];
//    [transition setType:kCATransitionReveal];
//    transition.subtype = kCATransitionFromBottom;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [[self.collectionView layer] addAnimation:transition forKey:nil];
    
}

- (IBAction)resetViewFrame:(id)sender {
    
    CGRect frame;
    frame.size.height = [[UIScreen mainScreen] bounds].size.height;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.origin.y = 0;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.5f animations:^{
        _collectionView.frame = frame;
    }];
    
//    transition = [CATransition animation];
//    [transition setDuration:1];
//    [transition setType:kCATransitionReveal];
//    transition.subtype = kCATransitionFromTop;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [[self.collectionView layer] addAnimation:transition forKey:nil];
}



#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (MyCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.cellLabel.text = [NSString stringWithFormat:@"cell %li",(long)indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = (MyCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray *views = [cell.contentView subviews];
    UILabel *label = [views objectAtIndex:0];
    NSLog(@"Select %@",label.text);
}


@end
