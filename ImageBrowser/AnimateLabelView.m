//
//  AnimateLabelView.m
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/7/16.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "AnimateLabelView.h"

@interface AnimatableLabelView ()
@property (nonatomic, strong) NSArray *titlesArrays;
@property (nonatomic, strong) NSMutableArray *titleViews;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation AnimatableLabelView

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray<NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _titlesArrays = titles;
        _titleViews = [NSMutableArray array];
        [self setupViews];
    }
    return self;
}
- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)setupViews
{
    self.clipsToBounds = YES;
    
    for (NSUInteger i = 0; i < self.titlesArrays.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [ UIColor blackColor];
        label.text = self.titlesArrays[i];
        label.textAlignment = self.textAlignment;
        [self.titleViews addObject:label];
        [self addSubview:label];
        
        [label setFrame:CGRectMake(0, i * self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    for (NSUInteger i = 0; i < self.titleViews.count; i++)
    {
        UILabel *label =  [self.titleViews objectAtIndex:i];
        label.textAlignment = textAlignment;
    }
}

- (void)start
{
    if (self.timer || self.titlesArrays.count < 2)
    {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
}
- (void)scrollToNext
{
    UILabel *lable_1 = [self.titleViews objectAtIndex:self.currentIndex];
    
    NSUInteger nextIndex = self.currentIndex + 1;
    if (nextIndex >= self.titlesArrays.count)
    {
        nextIndex = 0;
    }
    UILabel *lable_2 = [self.titleViews objectAtIndex:nextIndex];
    
    [UIView animateWithDuration:0.5 animations:^{
        [lable_1 setFrame: CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [lable_2 setFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [lable_1 setFrame: CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        self.currentIndex = nextIndex;
    }];
}
@end
