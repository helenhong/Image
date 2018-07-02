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
@property (nonatomic, strong) UIViewPropertyAnimator *animator;
@property (nonatomic, assign) CGFloat targetY;

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

    
    UIPanGestureRecognizer *panProgress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panProgressHandler:)];
    [self.view addGestureRecognizer:panProgress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.displayBlock addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.displayBlock addGestureRecognizer:pan];
    
    UICubicTimingParameters *timing = [[UICubicTimingParameters alloc] initWithAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:3.0f timingParameters:timing];
    self.targetY = 200;
}

- (void)panHandler:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint position = [gestureRecognizer translationInView:self.view];
    static CGFloat startX = 0;
    static CGFloat startY = 0;
    
    UIView *view = gestureRecognizer.view;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            startX = gestureRecognizer.view.center.x;
            startY = gestureRecognizer.view.center.y;
            break;
        case UIGestureRecognizerStateChanged:
            view.center = CGPointMake(startX + position.x, startY + position.y);
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 添加弹簧动画
            // NSLog(@"panGesture Ended");
            UIViewPropertyAnimator *springAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:1.0f dampingRatio:0.5 animations:^{
                self.displayBlock.center = self.view.center;
            }];
            [springAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                self.targetY = self.displayBlock.center.y < self.view.center.y ? self.view.center.y : 200;
            }];
            
            [springAnimator startAnimation];
        }
            break;
        default:
            break;
    }
    
}
// 根据 fractionComplete 演示动画
- (void)panProgressHandler:(UIPanGestureRecognizer*)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.animator.state == UIViewAnimatingStateInactive)
            {
                __weak __typeof(self)weakSelf = self;
                
                [self.animator addAnimations:^{
                    weakSelf.displayBlock.center = CGPointMake(weakSelf.displayBlock.center.x, weakSelf.targetY);
                    weakSelf.displayBlock.backgroundColor = weakSelf.displayBlock.backgroundColor == [UIColor redColor] ? [UIColor orangeColor] : [UIColor redColor];
                }];
                
                [self.animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                    weakSelf.targetY = weakSelf.displayBlock.center.y < weakSelf.view.center.y ? weakSelf.view.center.y : 200;
                }];
                
                [self.animator startAnimation];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat gestureY = [gestureRecognizer locationInView:gestureRecognizer.view].y;
            
            CGFloat fraction_1 = 0;
            if (self.targetY == 200)
            {
               fraction_1 = MIN (( self.view.center.y - gestureY)/ (self.view.center.y - 200), 1.0);
            }
            else
            {
                fraction_1 = MIN ((gestureY - 200)/ (self.view.center.y - 200), 1.0);
            }
            CGFloat fraction_2 = MAX(0.0, fraction_1);
            
            self.animator.fractionComplete = fraction_2;
        }
            
        default:
            break;
    }
}
// 动画isReversed,动画的isRunning 和 UIViewAnimatingState
- (void)tapHandler:(UITapGestureRecognizer*)gestureRecognizer
{
    switch (self.animator.state) {
        case UIViewAnimatingStateActive:
            if (self.animator.isRunning) {
                [self.animator pauseAnimation];
            }
            else {
                [self.animator setReversed:!self.animator.isReversed];
                
                // 中途修改动画
                UISpringTimingParameters *springTiming = [[UISpringTimingParameters alloc] initWithDampingRatio:0.2];
                
                [self.animator continueAnimationWithTimingParameters:springTiming durationFactor:0.5];
            }
            break;
        case UIViewAnimatingStateInactive:
        {
            __weak __typeof(self)weakSelf = self;
            
            [self.animator addAnimations:^{
                weakSelf.displayBlock.center = CGPointMake(weakSelf.displayBlock.center.x, weakSelf.targetY);
                weakSelf.displayBlock.backgroundColor = CGColorEqualToColor(weakSelf.displayBlock.backgroundColor.CGColor, [UIColor redColor].CGColor) ? [UIColor orangeColor] : [UIColor redColor];
            }];
            
            [self.animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                weakSelf.targetY = weakSelf.displayBlock.center.y < weakSelf.view.center.y ? weakSelf.view.center.y : 200;
            }];
            
            [self.animator startAnimation];
            break;
        }
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
