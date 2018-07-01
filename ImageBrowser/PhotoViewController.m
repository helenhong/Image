//
//  PhotoViewController.m
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/6/29.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

- (instancetype)initWithImage:(UIImage *)image;

@end

@implementation PhotoViewController
{
    UIImage* _centerImageView;
}
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self ) {
        _centerImageView = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = _centerImageView;
    
    [self.view addSubview:imageView];
    
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

@end
