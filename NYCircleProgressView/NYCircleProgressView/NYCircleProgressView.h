//
//  NYCircleProgressView.h
//  NYCircleProgressView
//
//  Created by 牛严 on 16/6/20.
//  Copyright © 2016年 circleProgressView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYCircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, assign) CGFloat timeLenth;                    //一圈所用动画时间
@property (nonatomic, assign) CGFloat targetProgress;

- (void)startAnimation;

@end

@interface CircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@end

@interface CircleBackView : UIView

@end

@interface CenterView : UIView

@property (nonatomic, assign) CGFloat progress;      

@property (nonatomic, assign) NSInteger period;

@end