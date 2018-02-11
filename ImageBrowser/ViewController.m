//
//  ViewController.m
//  ImageBrowser
//
//  Created by hongyimin on 2017/5/10.
//  Copyright © 2017年 hongyimin. All rights reserved.
//

#import "ViewController.h"
#import "HiImageScroller.h"

@interface ViewController ()
@property (nonatomic, strong) HiImageScroller *advBanner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.advBanner = [[HiImageScroller alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    self.advBanner.images = @[@"image0.jpg",@"image1.jpg",@"image2.jpg",@"image3.jpg",@"image4.jpg"];
    self.advBanner.timeInterval = 2.5f;
    
    [self.view addSubview:self.advBanner];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
