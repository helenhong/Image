//
//  HiImageScroller.h
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/2/11.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiImageScroller : UIView
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) CGFloat timeInterval;

/**
 options property, default is NO.
 */
@property (assign, nonatomic) BOOL bounces;
@end
