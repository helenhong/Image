//
//  HiImageScroller.m
//  ImageBrowser
//
//  Created by 洪一敏 on 2018/2/11.
//  Copyright © 2018年 hongyimin. All rights reserved.
//

#import "HiImageScroller.h"

#define sWidth self.bounds.size.width

@interface HiImageScrollerCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation HiImageScrollerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        UIView *masksView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 100, self.bounds.size.width, 100)];
        masksView.backgroundColor = [UIColor blackColor];
        
        NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor];
        gradientLayer.locations = locations;
        gradientLayer.frame = masksView.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint   = CGPointMake(0, 1);
        masksView.layer.mask = gradientLayer;
        [self.contentView addSubview:masksView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        UIView *masksView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 100, self.bounds.size.width, 100)];
        masksView.backgroundColor = [UIColor blackColor];
        
        NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor];
        gradientLayer.locations = locations;
        gradientLayer.frame = masksView.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint   = CGPointMake(0, 1);
        masksView.layer.mask = gradientLayer;
        [self.contentView addSubview:masksView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}
@end

@interface HiImageScroller () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HiImageScroller
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self ) {
        [self setupSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[HiImageScrollerCell class] forCellWithReuseIdentifier:@"HiImageScrollerCell"];
    
    _bounces = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
    [self addSubview:_collectionView];
    [self addSubview:_pageControl];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    textLayer.string = @"Hello~";
    textLayer.frame = CGRectMake(0, 0, 100, 20.0); // text和label的边距有间距
    
    UIFont *font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    
    textLayer.font = fontRef;
    textLayer.fontSize = 17.0;
    textLayer.alignmentMode = kCAAlignmentRight;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;//字体的颜色
    
    CFRelease(fontRef); //release
    
    [self.layer addSublayer:textLayer];
}
- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)layoutSubviews
{
    self.collectionView.frame = self.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView scrollRectToVisible:CGRectMake(sWidth, 0, sWidth, 0) animated:NO];
    
    self.imageArr = [NSMutableArray array];
    [self.imageArr addObject:self.images.lastObject];
    [self.imageArr addObjectsFromArray:self.images];
    [self.imageArr addObject:self.images.firstObject];
    
    self.pageControl.frame = CGRectMake(self.frame.size.width/2 - 40, self.frame.size.height - 28, 80, 28);
    self.pageControl.numberOfPages = self.imageArr.count - 2;
    self.pageControl.currentPage = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HiImageScrollerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HiImageScrollerCell" forIndexPath:indexPath];
    cell.imageView.image = self.imageArr[indexPath.item];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x / sWidth > self.imageArr.count - 2) {
        [scrollView scrollRectToVisible:CGRectMake(sWidth, 0, sWidth, 80) animated:NO];
    }
    else if (scrollView.contentOffset.x < sWidth)
    {
        [scrollView scrollRectToVisible:CGRectMake(sWidth * (self.imageArr.count - 2), 0, sWidth, 80) animated:NO];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x / sWidth > self.imageArr.count - 2) {
        self.pageControl.currentPage = 0;
    }
    else if (scrollView.contentOffset.x < sWidth)
    {
        self.pageControl.currentPage = self.imageArr.count - 2;
    }
    else
    {
        self.pageControl.currentPage = scrollView.contentOffset.x / sWidth - 1;
    }
}
- (void)scrollToNext
{
    if (self.collectionView.contentOffset.x / sWidth > self.imageArr.count - 2) {
        [self.collectionView scrollRectToVisible:CGRectMake(sWidth, 0, sWidth, 80) animated:NO];
    }
    else if (self.collectionView.contentOffset.x < sWidth)
    {
        [self.collectionView scrollRectToVisible:CGRectMake(sWidth * (self.imageArr.count - 2), 0, sWidth, 80) animated:NO];
    }
    else {
        [self.collectionView scrollRectToVisible:CGRectMake(self.collectionView.contentOffset.x + sWidth, self.collectionView.contentOffset.y, sWidth, self.bounds.size.width) animated:YES];
    }
}
@end
