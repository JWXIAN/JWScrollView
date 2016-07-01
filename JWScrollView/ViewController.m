//
//  ViewController.m
//  JWScrollView
//
//  Created by GJW on 16/6/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "ViewController.h"
#import "JWScrollView.h"

@interface ViewController ()<JWScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize sSize = [UIScreen mainScreen].bounds.size;
    NSArray *imageArr = @[[UIImage imageNamed:@"活动默认图"],
                          @"http://images.apple.com/cn/iphone-6s/overview/images/og.jpg",
                          @"http://images.apple.com/cn/ipad-pro/images/og_wechat.jpg",
                          [UIImage imageNamed:@"活动默认图"]];
    
    //Block
    JWScrollView *scroll = [JWScrollView initJWScrollViewWithBlock:CGRectMake(0, 20, sSize.width, 150) imageArr:imageArr duringTime:2.0 placeholder:[UIImage imageNamed:@"placeholder"] result:^(NSInteger index, JWScrollView *scrollView) {
        NSLog(@"%ld---%@", index, scrollView);
    }];
    [self.view addSubview:scroll];
    
    //Delegate
    JWScrollView *scroll1 = [JWScrollView initJWScrollViewWithDelegate:CGRectMake(0, 220, sSize.width, 150) imageArr:imageArr duringTime:3.0 placeholder:[UIImage imageNamed:@"placeholder"] delegate:self];
    [self.view addSubview:scroll1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 点击
- (void)didClickImageAtIndex:(NSInteger)index scrollView:(JWScrollView *)scrollView{
    NSLog(@"%ld---%@", index, scrollView);
}
@end
