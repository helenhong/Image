//
//  PTransitionAnimation.m
//  ImageBrowser
//
//  Created by yimin on 2018/6/30.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "PTransitionAnimation.h"

@implementation PTransitionAnimation

#pragma mark <UIViewControllerAnimatedTransitioning>
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = self.image;
    
    UIView* bgView = [[UIView alloc] initWithFrame:toView.view.frame];
    bgView.backgroundColor = [UIColor blackColor];
    
    [[transitionContext containerView] addSubview:bgView];
    [[transitionContext containerView] addSubview:imageView];
    imageView.frame = self.startframe;
    bgView.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        // width > height
        if (self.image.size.width > self.image.size.height)
        {
            CGFloat desWidth = toView.view.frame.size.width;
            CGFloat desHeight = self.image.size.height / self.image.size.width * desWidth;
            
            imageView.frame = CGRectMake(0, (toView.view.frame.size.height - desHeight)/2, desWidth, desHeight);
        }
        // height > width
        else
        {
            CGFloat desHeight = toView.view.frame.size.height;
            CGFloat desWidth = self.image.size.width / self.image.size.height * desHeight;
            
            imageView.frame = CGRectMake((toView.view.frame.size.width - desWidth)/2, 0, desWidth, desHeight);
        }
        bgView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
        [bgView removeFromSuperview];
        
        [[transitionContext containerView] addSubview:toView.view];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }]; 
}

@end
