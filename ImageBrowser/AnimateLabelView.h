//
//  AnimateLabelView.h
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/7/16.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatableLabelView : UIView

@property (nonatomic, assign) NSTextAlignment textAlignment;

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray<NSString *> *)titles;
- (void)start;
@end
