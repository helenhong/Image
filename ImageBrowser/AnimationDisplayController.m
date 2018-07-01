//
//  AnimationDisplayController.m
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/6/29.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "AnimationDisplayController.h"

@interface AnimationDisplayController ()

@property (nonatomic, strong) UIView *displayBlock;

@end

@implementation AnimationDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.displayBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    self.displayBlock.center = self.view.center;
    self.displayBlock.backgroundColor = [UIColor orangeColor];
    self.displayBlock.layer.cornerRadius = 5.0;
    self.displayBlock.clipsToBounds = YES;
    
    [self.view addSubview:self.displayBlock];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.displayBlock addGestureRecognizer:pan];
}

- (void)panHandler:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint position = [gestureRecognizer translationInView:self.view];
    static CGFloat startX = 0;
    static CGFloat startY = 0;
    
    UIView *view = gestureRecognizer.view;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
             NSLog(@"start xPostion = %lf, yPosition = %lf", position.x, position.y);
            startX = gestureRecognizer.view.center.x;
            startY = gestureRecognizer.view.center.y;
            break;
        case UIGestureRecognizerStateChanged:
            view.center = CGPointMake(startX + position.x, startY + position.y);
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
