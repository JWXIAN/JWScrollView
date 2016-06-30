//
//  JWScrollView.h
//  JWScrollView
//
//  Created by GJW on 16/6/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWScrollView;
@protocol JWScrollViewDelegate <NSObject>
/**
 *  点击
 *
 *  @param index      index
 *  @param scrollView scrollView
 */
- (void)didClickImageAtIndex:(NSInteger)index scrollView:(JWScrollView *)scrollView;
@end
@interface JWScrollView : UIView
@property (weak, nonatomic) id<JWScrollViewDelegate> delegate;

/**
 *  间隔时间，0表示不自动滚动
 */
@property (assign, nonatomic) NSTimeInterval duringTime;

/**
 *  点击Block回调
 */
@property (nonatomic, copy) void(^blockDidClickImageAtIndex)(NSInteger index, JWScrollView *scrollView);

/**
 *  传入图片
 *
 *  @param images 本地图片数组
 */
- (void)images:(NSArray *)images;
- (void)closeTimer;
- (void)openTimer;
@end
