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
    //代理回调
    JWScrollView *scrollView1 = [[JWScrollView alloc] initWithFrame:CGRectMake(0, 20, sSize.width, 150)];
    scrollView1.delegate = self;
    [scrollView1 images:@[[UIImage imageNamed:@"活动默认图"]]];
    [self.view addSubview:scrollView1];
    
    //Block回调
    JWScrollView *scrollView2 = [[JWScrollView alloc] initWithFrame:CGRectMake(0, 220, sSize.width, 150)];
    scrollView2.blockDidClickImageAtIndex = ^(NSInteger index, JWScrollView *scrollView){
        NSLog(@"%ld---%@", index, scrollView);
    };
    scrollView2.duringTime = 2.0;
    [scrollView2 images:@[[UIImage imageNamed:@"活动默认图"], [UIImage imageNamed:@"活动默认图"]]];
    [self.view addSubview:scrollView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击
- (void)didClickImageAtIndex:(NSInteger)index scrollView:(JWScrollView *)scrollView{
    NSLog(@"%ld---%@", index, scrollView);
}
@end