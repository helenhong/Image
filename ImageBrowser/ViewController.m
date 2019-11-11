//
//  ViewController.m
//  ImageBrowser
//
//  Created by hongyimin on 2017/5/10.
//  Copyright © 2017年 hongyimin. All rights reserved.
//

#import "ViewController.h"
#import "HiImageScroller.h"
#import "HiAnimationPhotoViewer.h"
#import "AnimationDisplayController.h"
#import "AnimateLabelView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HiImageScroller *advBanner;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    // inscrollerable Header
    CGFloat topHeight = statusRect.size.height+navRect.size.height;
    
    self.advBanner = [[HiImageScroller alloc] initWithFrame:CGRectMake(0, topHeight, self.view.frame.size.width, 200)];
    self.advBanner.images = [NSArray arrayWithObjects:[UIImage imageNamed:@"image0.jpg"],
                               [UIImage imageNamed:@"image1.jpg"],
                               [UIImage imageNamed:@"image2.jpg"],
                               [UIImage imageNamed:@"image3.jpg"],
                               [UIImage imageNamed:@"image4.jpg"],
                               nil];
    self.advBanner.timeInterval = 2.5f;
     [self.view addSubview:self.advBanner];
    // inscrollerable Header
    
    AnimatableLabelView *animatableLabel = [[AnimatableLabelView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2.0, topHeight, 100, 20) Titles:@[@"Hello",@"World !"]];
    animatableLabel.textAlignment = NSTextAlignmentCenter;
    [animatableLabel start];
    [self.view addSubview:animatableLabel];
    
    self.dataArr = @[[NSString stringWithFormat:@"%@", [HiAnimationPhotoViewer class]],
                     [NSString stringWithFormat:@"%@", [AnimationDisplayController class]]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.advBanner.frame.origin.y + self.advBanner.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.advBanner.frame.size.height - self.advBanner.frame.origin.y)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    //cell右侧的小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self jumpToPhotoViewer];
            break;
        case 1:
            [self jumToAnimationDisplay];
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectRowAtIndexPath %@",indexPath);
}

#pragma mark - Action
- (void)jumpToPhotoViewer
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
    layout.itemSize = CGSizeMake(width, width);
    
    HiAnimationPhotoViewer *photoViewr = [[HiAnimationPhotoViewer alloc] initWithCollectionViewLayout:layout];
    photoViewr.imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"image0"],
                           [UIImage imageNamed:@"image1.jpg"],
                           [UIImage imageNamed:@"image2.jpg"],
                           [UIImage imageNamed:@"image3.jpg"],
                           [UIImage imageNamed:@"image4.jpg"],
                           [UIImage imageNamed:@"image0.jpg"],
                           nil];
    [self.navigationController pushViewController:photoViewr animated:YES];
}
- (void)jumToAnimationDisplay
{
    AnimationDisplayController *animatiorVC = [[AnimationDisplayController alloc] init];
    [self.navigationController pushViewController:animatiorVC animated:YES];
}
        
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
