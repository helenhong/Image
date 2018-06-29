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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HiImageScroller *advBanner;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // inscrollerable Header
    /*
    self.advBanner = [[HiImageScroller alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    self.advBanner.images = [NSArray arrayWithObjects:[UIImage imageNamed:@"image0.jpg"],
                               [UIImage imageNamed:@"image1.jpg"],
                               [UIImage imageNamed:@"image2.jpg"],
                               [UIImage imageNamed:@"image3.jpg"],
                               [UIImage imageNamed:@"image4.jpg"],
                               nil];
    self.advBanner.timeInterval = 2.5f;
     [self.view addSubview:self.advBanner];
     */
    
    // inscrollerable Header
    
    self.dataArr = @[[NSString stringWithFormat:@"%@", [HiAnimationPhotoViewer class]], [NSString stringWithFormat:@"%@", [AnimationDisplayController class]]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
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
    NSLog(@"didSelectRowAtIndexPath %@",indexPath);
    
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
    photoViewr.imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"image0.jpg"],
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
