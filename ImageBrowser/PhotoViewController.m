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
    UIImageView *_centerImageView;
}
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self ) {
        _centerImageView.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _centerImageView.backgroundColor = [UIColor darkGrayColor];
    _centerImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
