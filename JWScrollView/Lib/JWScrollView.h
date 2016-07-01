//
//  JWScrollView.h
//  JWScrollView
//
//  Created by GJW on 16/6/30.
//  Copyright © 2016年 JW. All rights reserved.
//  https://github.com/JWXIAN/JWScrollView.git
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
typedef void(^blockDidClickImageAtIndex)(NSInteger index, JWScrollView *scrollView);
@property (weak, nonatomic) id<JWScrollViewDelegate> delegate;

/**
 *  间隔时间，0表示不自动滚动
 */
@property (assign, nonatomic) NSTimeInterval duringTime;
/**
 *  占位图
 */
@property (nonatomic, strong) UIImage *placeholder;

/**
 *  点击Block回调
 */
@property (nonatomic, copy) void(^blockDidClickImageAtIndex)(NSInteger index, JWScrollView *scrollView);

/**
 *  初始化Block回调
 *
 *  @param frame      frame
 *  @param imageArr   图片
 *  @param duringTime 间隔时间
 *  @param placeholder 占位图 - 本地图片可以Nil
 *  @param result     回调
 *
 *  @return self
 */
+ (instancetype)initJWScrollViewWithBlock:(CGRect)frame imageArr:(NSArray *)imageArr duringTime:(NSTimeInterval)duringTime placeholder:(UIImage *)placeholder result:(blockDidClickImageAtIndex)result;

/**
 *  初始化Delegate回调
 *
 *  @param frame      frame
 *  @param imageArr   图片
 *  @param duringTime 间隔时间
 *  @param placeholder 占位图  - 本地图片可以Nil
 *  @param delegate   delegate
 *
 *  @return self
 */
+ (instancetype)initJWScrollViewWithDelegate:(CGRect)frame imageArr:(NSArray *)imageArr duringTime:(NSTimeInterval)duringTime placeholder:(UIImage *)placeholder delegate:(id<JWScrollViewDelegate>)delegate;
/**
 *  传入图片
 *
 *  @param images 本地图片数组
 */
- (void)images:(NSArray *)images;
- (void)closeTimer;
- (void)openTimer;
@end
