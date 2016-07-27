# JWScrollView

[![Support](https://img.shields.io/badge/support-iOS%207%2B-brightgreen.svg)](https://github.com/JWXIAN/JWScrollView)
[![AppVeyor](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg?maxAge=2592000)](https://github.com/JWXIAN/JWScrollView)
[![Bintray](https://img.shields.io/badge/version-1.0-brightgreen.svg)](https://github.com/JWXIAN/JWScrollView)

--

![image](https://github.com/JWXIAN/JWScrollView/blob/master/gif.gif)

--
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
    
    
    - (void)didClickImageAtIndex:(NSInteger)index scrollView:(JWScrollView *)scrollView{
      NSLog(@"%ld---%@", index, scrollView);
     }
