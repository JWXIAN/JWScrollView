//
//  JWScrollView.m
//  JWScrollView
//
//  Created by GJW on 16/6/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "JWScrollView.h"
#import "JWScrollViewCell.h"
#import "UIImageView+WebCache.h"
@interface JWScrollView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *images;              // 图片数组
@property (assign, nonatomic) NSInteger imageCount;         // 图片数量
@property (strong, nonatomic) NSMutableArray *cellData;     // 模型数组
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLock *mLock;
@end

static NSString *CollectionCellID = @"CollectionCellID";

@implementation JWScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initMainView];
    }
    return self;
}
- (void)initMainView{
    // 初始化 collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 注册cell重用
    [self.collectionView registerClass:[JWScrollViewCell class] forCellWithReuseIdentifier:CollectionCellID];
    [self addSubview:self.collectionView];
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    self.pageControl.tag = 100;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    self.backgroundColor = [UIColor whiteColor];
    self.mLock = [[NSLock alloc] init];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JWScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    NSInteger index = [_cellData[indexPath.row] integerValue];
    if ([_images[index] isKindOfClass:[UIImage class]]) {
        cell.imageV.image = _images[index];
    }else{
        [cell.imageV sd_setImageWithURL:_images[index] placeholderImage:_placeholder];
    }
    cell.index = index;
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 动画停止, 重新定位到第 50 组模型
    int inc = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % _imageCount;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount + inc inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.currentPage = inc;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JWScrollViewCell *cell = (JWScrollViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //代理回调
    if ([self.delegate respondsToSelector:@selector(didClickImageAtIndex:scrollView:)]) {
        [self.delegate didClickImageAtIndex:cell.index scrollView:self];
    }
    //Block回调
    if (self.blockDidClickImageAtIndex) {
        self.blockDidClickImageAtIndex(cell.index, self);
    }
}

#pragma mark - 初始化Block回调
+ (instancetype)initJWScrollViewWithBlock:(CGRect)frame imageArr:(NSArray *)imageArr duringTime:(NSTimeInterval)duringTime placeholder:(UIImage *)placeholder result:(blockDidClickImageAtIndex)result{
    JWScrollView *scroll = [[JWScrollView alloc] initWithFrame:frame];
    scroll.duringTime = duringTime;
    scroll.blockDidClickImageAtIndex = result;
    scroll.placeholder = placeholder;
    [scroll images:imageArr];
    return scroll;
}
#pragma mark - 初始化Delegate回调
+ (instancetype)initJWScrollViewWithDelegate:(CGRect)frame imageArr:(NSArray *)imageArr duringTime:(NSTimeInterval)duringTime placeholder:(UIImage *)placeholder delegate:(id<JWScrollViewDelegate>)delegate{
    JWScrollView *scroll = [[JWScrollView alloc] initWithFrame:frame];
    scroll.duringTime = duringTime;
    scroll.delegate=delegate;
    scroll.placeholder = placeholder;
    [scroll images:imageArr];
    return scroll;
}
- (void)setDuringTime:(NSTimeInterval)duringTime {
    _duringTime = duringTime;
    if (duringTime < 0.001) {
        return ;
    }
    [self closeTimer];
    [self openTimer];
}

- (void)images:(NSArray *)images {
    [self.mLock lock];
    [self closeTimer];
    
    _images = images;
    _imageCount = images.count;
    
    // 生成数据源
    self.cellData = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        for (int j=0; j<_imageCount; j++) {
            [self.cellData addObject:@(j)];
        }
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.hidden = _imageCount > 1 ? NO : YES;
    self.pageControl.numberOfPages = _imageCount;
    self.pageControl.currentPage = 0;
    
    [self openTimer];
    [self.mLock unlock];
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
}
- (void)openTimer {
    if (_duringTime > 0.8) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_duringTime target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}
- (void)onTimer {
    if (self.cellData.count > 0) {
        NSArray *array = [self.collectionView indexPathsForVisibleItems];
        if (array.count == 0) return ;
        
        NSIndexPath *indexPath = array[0];
        NSInteger row = indexPath.row;
        
        if (row % _imageCount == 0) {
            row = 50 * _imageCount;         // 重新定位
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.pageControl.currentPage = (row + 1) % _imageCount;
    }
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) [self closeTimer];
}
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}
@end
