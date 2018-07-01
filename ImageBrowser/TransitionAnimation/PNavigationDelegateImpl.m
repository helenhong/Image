//
//  PNavigationDelegateIml.m
//  ImageBrowser
//
//  Created by yimin on 2018/6/30.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "PNavigationDelegateImpl.h"
#import "PTransitionAnimation.h"

@implementation PNavigationDelegateImpl

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        return self.animator;
    }
    return nil;
}

@end
