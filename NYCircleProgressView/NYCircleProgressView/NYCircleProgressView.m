//
//  NYCircleProgressView.m
//  NYCircleProgressView
//
//  Created by 牛严 on 16/6/20.
//  Copyright © 2016年 circleProgressView. All rights reserved.
//

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * (degrees))/ 180)
#define FrameSize self.frame.size
#define BackInColor [UIColor colorWithRed:(float)(253/255.0f) green:(float)(228/255.0f) blue:(float)(65/255.0f) alpha:1.0]
#define BackOutColor [UIColor colorWithRed:(float)(255/255.0f) green:(float)(240/255.0f) blue:(float)(149/255.0f) alpha:1.0]
#define FrontOutColor [UIColor colorWithRed:(float)(247/255.0f) green:(float)(91/255.0f) blue:(float)(95/255.0f) alpha:1.0]
#define FrontInColor [UIColor colorWithRed:(float)(249/255.0f) green:(float)(45/255.0f) blue:(float)(46/255.0f) alpha:1.0]

#import "NYCircleProgressView.h"

@interface NYCircleProgressView ()

@property (nonatomic, strong) CircleBackView *circleBackView;

@property (nonatomic, strong) CircleProgressView *circleProgressView;

@property (nonatomic, strong) CenterView *centerView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, assign) CGFloat currentProgress;

@end

@implementation NYCircleProgressView

static const CGFloat fontSize = 46.f;

#pragma mark Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.timeLenth = 1.0f;
        self.currentProgress = 0;
        self.targetProgress = 0.5;
        [self addSubview:self.circleBackView];          //背景圆环
        [self addSubview:self.circleProgressView];      //进度条圆环
        [self addSubview:self.centerView];           //进度Label
    }
    return self;
}

#pragma mark CADisplayLink Methods
/**
 *  开始动画
 */
- (void)startAnimation
{
    self.currentProgress = 0;
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTask)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

/**
 *  随着屏幕刷新帧率执行的绘制方法
 */
- (void)displayLinkTask
{
    self.progress = self.currentProgress/self.timeLenth;
    self.currentProgress += 1/60.0f;
    if (self.currentProgress >= self.targetProgress)
    {
        [self.displayLink invalidate];
        self.progress = self.targetProgress;
        return;
    }
}

#pragma Get/Set Methods
- (void)setProgress:(CGFloat)progress
{
    _progress = progress > 1? 1:(progress < 0? 0 :progress);
    self.circleProgressView.progress = _progress;
    self.centerView.progress = _progress;
}

- (void)setPeriod:(NSInteger)period
{
    self.centerView.period = period;
}

- (CircleBackView *)circleBackView
{
    if (!_circleBackView) {
        _circleBackView = [[CircleBackView alloc]initWithFrame:CGRectMake(0, 0, FrameSize.width, self.frame.size.height)];
    }
    return _circleBackView;
}

- (CircleProgressView *)circleProgressView
{
    if (!_circleProgressView) {
        _circleProgressView = [[CircleProgressView alloc]initWithFrame:self.circleBackView.frame];
    }
    return _circleProgressView;
}

- (CenterView *)centerView
{
    if (!_centerView) {
        _centerView = [[CenterView alloc]initWithFrame:self.circleBackView.frame];
    }
    return _centerView;
}

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGPoint cirCenter = CGPointMake(size.width/2, size.height/2);
    CGFloat circleLineWidth = size.width * 0.044;       //圆线宽
    CGFloat radius = (size.width - circleLineWidth)/2 ;      //圆半径
    
    CGFloat startRadian = 0;            //开始弧度
    CGFloat progressDegree = 0;         //完成百份之几对应的角度
    CGFloat endRadian = 0;              //结束弧度
    
    //进度条圆弧
    startRadian = DEGREES_TO_RADIANS(-90);
    progressDegree = self.progress * 360;
    endRadian = DEGREES_TO_RADIANS(progressDegree-90);
    
    UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:cirCenter radius:radius startAngle:startRadian endAngle:endRadian clockwise:YES];
    [FrontOutColor setStroke];
    progressCircle.lineCapStyle = kCGLineCapButt;
    progressCircle.lineWidth = circleLineWidth;
    [progressCircle stroke];
    
    CGFloat inCircleLineWidth = circleLineWidth * 0.7f;
    CGFloat inCircleRadius = radius - (inCircleLineWidth + circleLineWidth)/2;
    UIBezierPath *inProgressCircle = [UIBezierPath bezierPathWithArcCenter:cirCenter radius:inCircleRadius startAngle:startRadian endAngle:endRadian clockwise:YES];
    [FrontInColor setStroke];
    inProgressCircle.lineCapStyle = kCGLineCapButt;
    inProgressCircle.lineWidth = inCircleLineWidth;
    [inProgressCircle stroke];

}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress > 1? 1:(progress < 0? 0 :progress);
    [self setNeedsDisplay];
}

@end


@implementation CircleBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGPoint cirCenter = CGPointMake(size.width/2, size.height/2);
    CGFloat circleLineWidth = size.width * 0.044;       //圆线宽
    CGFloat radius = (size.width - circleLineWidth)/2 ;      //圆半径
    
    CGFloat startRadian = 0;            //开始弧度
    CGFloat progressDegree = 0;         //完成百份之几对应的角度
    CGFloat endRadian = 0;              //结束弧度
    
    //背景圆弧
    startRadian = DEGREES_TO_RADIANS(-90);
    progressDegree = 1 * 360;
    endRadian = DEGREES_TO_RADIANS(progressDegree - 90);
    
    UIBezierPath *outCircle = [UIBezierPath bezierPathWithArcCenter:cirCenter radius:radius startAngle:startRadian endAngle:endRadian clockwise:YES];
    [BackOutColor setStroke];
    outCircle.lineCapStyle = kCGLineCapButt;
    outCircle.lineWidth = circleLineWidth;
    [outCircle stroke];
    
    CGFloat inCircleLineWidth = circleLineWidth * 0.7f;
    CGFloat inCircleRadius = radius - (inCircleLineWidth + circleLineWidth)/2;
    UIBezierPath *inCircle = [UIBezierPath bezierPathWithArcCenter:cirCenter radius:inCircleRadius startAngle:startRadian endAngle:endRadian clockwise:YES];
    [BackInColor setStroke];
    inCircle.lineCapStyle = kCGLineCapButt;
    inCircle.lineWidth = inCircleLineWidth;
    [inCircle stroke];
}

@end


@interface CenterView ()

@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UILabel *progressLabel;       //进度
@property (nonatomic, strong) UILabel *desLabel;            //下方描述
@property (nonatomic, strong) UIView *bottomLine;           //下划线

@end

@implementation CenterView
{
    CGRect _frame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _frame = frame;
        [self addSubview:self.progressLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
        [self addSubview:self.desLabel];
    }
    return self;
}

#pragma mark Private Methods
- (void)progressLabelSetAttributedTextWithProgress:(CGFloat )progress
{
    NSString *labelStr = [NSString stringWithFormat:@"%.2f%%",progress * 20];
    
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc]initWithString:labelStr];
    [labelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, labelStr.length - 1)];
    [labelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize/2] range:NSMakeRange(labelStr.length - 1, 1)];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGRect rect = [labelStr boundingRectWithSize:CGSizeMake(_frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    self.progressLabel.attributedText = labelText;
    
    CGRect lineRect = self.bottomLine.frame;
    lineRect.origin.x = (_frame.size.width - rect.size.width + 30)/2;
    lineRect.size.width = rect.size.width - 25;
    
    self.bottomLine.frame = lineRect;
}

#pragma mark Set/Get Methods
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self progressLabelSetAttributedTextWithProgress:_progress];
}

- (void)setPeriod:(NSInteger)period
{
    _period = period;
    self.desLabel.text = [NSString stringWithFormat:@"期限%ld天",(long)_period];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _progressLabel.frame.origin.y - 35, _frame.size.width - 40, 30)];
        _titleLabel.text = @"年化收益率";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (_frame.size.height - fontSize)/2 - fontSize/5, _frame.size.width-40,fontSize)];
        _progressLabel.textColor = FrontInColor;
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.font = [UIFont systemFontOfSize:fontSize];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(_progressLabel.frame.origin.x, _progressLabel.frame.origin.y + _progressLabel.frame.size.height + 4, _progressLabel.frame.size.width, 1)];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(float)(222/255.0f) green:(float)(222/255.0f) blue:(float)(222/255.0f) alpha:1.0];
    }
    return _bottomLine;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bottomLine.frame.origin.x, _bottomLine.frame.origin.y + 13, _bottomLine.frame.size.width, 14)];
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}

@end
