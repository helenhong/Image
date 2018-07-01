//
//  PTransitionAnimation.h
//  ImageBrowser
//
//  Created by yimin on 2018/6/30.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect startframe;

@property (nonatomic, strong) UIImage *image;

@end
