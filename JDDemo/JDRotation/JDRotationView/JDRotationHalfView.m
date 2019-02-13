//
//  JDRotationHalfView.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/12/3.
//  Copyright © 2018 京东. All rights reserved.
//

#import "JDRotationHalfView.h"

@interface JDRotationHalfView ()

// 白色圆环
@property (nonatomic, strong) CAShapeLayer *circularLayer;
//
@property (nonatomic, strong) UIView *contentView;
// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;
// 数据源
@property (nonatomic, strong) NSArray *modelArray;

// 手势开始的点
@property (nonatomic) CGPoint beginPoint;
// 累计旋转的弧度
@property (nonatomic) CGFloat originRotation;
// 最大的角度
@property (nonatomic) CGFloat maxAngle;
// 最小的角度
@property (nonatomic) CGFloat minAngle;
// 初始的偏移角度
@property (nonatomic) CGFloat startAngleOffset;
// item间隔角度
@property (nonatomic) CGFloat spacingAngle;

@end

@implementation JDRotationHalfView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.startAngleOffset = 60.0;
        self.spacingAngle = 45.0;
        
        self.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:250/255.0 alpha:1.0];
        UIPanGestureRecognizer *gecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeMove:)];
        [self addGestureRecognizer:gecognizer];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat contentW = CGRectGetWidth(self.bounds);
    CGFloat contentH = CGRectGetWidth(self.bounds);
    CGFloat contentX = 0.0;
    CGFloat contentY = CGRectGetHeight(self.bounds)-contentH+contentH/2.0;
    self.contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    self.contentView.layer.cornerRadius = contentW/2.0;
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 背景圆环
    [self.circularLayer removeFromSuperlayer];
    self.circularLayer.frame = self.bounds;
    [[UIColor whiteColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)) radius:CGRectGetWidth(self.bounds)/2.0 startAngle:M_PI endAngle:0.0 clockwise:YES];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-80.0, CGRectGetHeight(self.bounds))];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)) radius:CGRectGetWidth(self.bounds)/2.0-80.0 startAngle:0.0 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(0.0, CGRectGetHeight(self.bounds))];
    [path fill];
    [path closePath];
    self.circularLayer.path = path.CGPath;
    [self.layer addSublayer:self.circularLayer];
}

- (CAShapeLayer *)circularLayer
{
    if (!_circularLayer) {
        _circularLayer = [CAShapeLayer layer];
        _circularLayer.fillColor = [UIColor clearColor].CGColor;
        _circularLayer.backgroundColor = [UIColor clearColor].CGColor;
        _circularLayer.shadowOffset = CGSizeMake(1.0, 1.0);
        _circularLayer.shadowOpacity = 0.8;
        _circularLayer.shadowColor = [UIColor blackColor].CGColor;
        _circularLayer.shadowRadius = 4.0;
    }
    return _circularLayer;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)reloadWithModelList:(NSArray *)list
{
    self.modelArray = list;
    self.maxAngle = self.startAngleOffset + 2 * self.spacingAngle;
    self.minAngle = self.startAngleOffset - self.spacingAngle*(list.count-1);
    self.originRotation = 0.0;
    
    [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnArray removeAllObjects];
    
    CGFloat btnWidth = 80.0;
    // 各btn的center,在以为圆心,半径为r的圆上
    CGFloat radius = (CGRectGetWidth(self.frame)- btnWidth)/2.0;
    CGFloat offset = self.startAngleOffset/180.0*M_PI;
    CGFloat spacing = self.spacingAngle/180.0*M_PI;
    CGFloat x = CGRectGetWidth(self.frame)/2.0;
    CGFloat y = CGRectGetWidth(self.frame)/2.0;
    for (int i = 0; i < list.count; i++) {
        NSDictionary *model = [list objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(0.0, 0.0, btnWidth, btnWidth);
        CGFloat currentCorner = M_PI + i*spacing + offset;
        btn.center = CGPointMake(x+radius * cos(currentCorner), y+radius * sin(currentCorner));
        btn.transform = CGAffineTransformMakeRotation(0);
        NSString *title = [model objectForKey:@"title"];
        NSString *iconName = [model objectForKey:@"icon"];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = btnWidth/2.0;
        btn.clipsToBounds = YES;
        btn.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:btn];
        [self.btnArray addObject:btn];
    }
    [self updateItemsVisibility];
}

- (void)btnDidClicked:(UIButton *)sender
{
    NSDictionary *model = [self.modelArray objectAtIndex:sender.tag];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}

#pragma mark -通过旋转手势转动转盘
- (void)changeMove:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = [sender locationInView:self];
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat changeX = [sender locationInView:self].x - self.beginPoint.x;
        
        CGFloat value = self.originRotation + changeX/100.0;
        CGFloat angle = value/M_PI*180.0;
        if (angle > (self.maxAngle - self.startAngleOffset)) {
            self.originRotation = (self.maxAngle-self.startAngleOffset)/180.0*M_PI;
        } else if (angle < (self.minAngle-self.startAngleOffset)) {
            self.originRotation = (self.minAngle-self.startAngleOffset)/180.0*M_PI;
        } else {
            self.originRotation = value;
        }
        self.contentView.transform = CGAffineTransformMakeRotation(self.originRotation);
        for (UIButton *btn in self.btnArray) {
            btn.transform = CGAffineTransformMakeRotation(-(self.originRotation));
        }
        // 更新可见控件
        [self updateItemsVisibility];
        self.beginPoint = [sender locationInView:self];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat originRotationAngle = self.originRotation/M_PI*180.0;
        if (originRotationAngle > (self.maxAngle - self.spacingAngle - self.startAngleOffset)) {
            CGFloat value = (self.maxAngle - self.spacingAngle - self.startAngleOffset)/180.0*M_PI;
            self.originRotation = value;
            [UIView animateWithDuration:0.5 animations:^{
                self.contentView.transform = CGAffineTransformMakeRotation(self.originRotation);
                for (UIButton *btn in self.btnArray) {
                    btn.transform = CGAffineTransformMakeRotation(-self.originRotation);
                }
            }];
            // 更新可见控件
            [self updateItemsVisibility];
        }else if (originRotationAngle < (self.minAngle + self.spacingAngle - self.startAngleOffset)) {
            CGFloat value = (self.minAngle + self.spacingAngle - self.startAngleOffset)/180.0*M_PI;
            self.originRotation = value;
            [UIView animateWithDuration:0.5 animations:^{
                self.contentView.transform = CGAffineTransformMakeRotation(self.originRotation);
                for (UIButton *btn in self.btnArray) {
                    btn.transform = CGAffineTransformMakeRotation(-self.originRotation);
                }
            }];
            // 更新可见控件
            [self updateItemsVisibility];
        }
    }
}

- (void)updateItemsVisibility
{
    CGFloat originRotationAngle = self.originRotation/M_PI*180.0;
    int i = 0;
    for (UIButton *btn in self.btnArray) {
        CGFloat placeAngle = self.startAngleOffset + i*self.spacingAngle;
        if (originRotationAngle>(-placeAngle-10) && originRotationAngle<(180-placeAngle+10)) {
            btn.hidden = NO;
        }else{
            btn.hidden = YES;
        }
        i++;
    }
}

@end
