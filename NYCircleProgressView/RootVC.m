//
//  RootVC.m
//  NYCircleProgressView
//
//  Created by 牛严 on 16/6/20.
//  Copyright © 2016年 circleProgressView. All rights reserved.
//

#import "RootVC.h"
#import "NYCircleProgressView.h"

@interface RootVC ()

@property (nonatomic, strong) NYCircleProgressView *progressView;

@property (nonatomic, strong) UIButton *button;

@end

@implementation RootVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressView = [[NYCircleProgressView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.progressView.targetProgress = 0.618f;
    self.progressView.period = 24;
    [self.view addSubview:self.progressView];
    [self.progressView startAnimation];
    
    [self.view addSubview:self.button];
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 100, 50)];
        _button.backgroundColor = [UIColor blackColor];
        [_button addTarget:self.progressView action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
