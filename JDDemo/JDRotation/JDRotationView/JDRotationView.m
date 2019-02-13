//
//  JDRotationView.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/28.
//  Copyright © 2018 京东. All rights reserved.
//

#import "JDRotationView.h"

@interface JDRotationView ()

// 中间按钮
@property (nonatomic, strong) UIButton *centerButton;
// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;
// 数据源
@property (nonatomic, strong) NSArray *modelArray;

// 手势开始的点
@property (nonatomic) CGPoint beginPoint;
// 旋转的弧度
@property (nonatomic) CGFloat rotationAngleInRadians;

@end

@implementation JDRotationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(frame)/2.0;
        self.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *gecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeMove:)];
        [self addGestureRecognizer:gecognizer];
    }
    return self;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        [_centerButton addTarget:self action:@selector(centerButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton.clipsToBounds = YES;
    }
    return _centerButton;
}

- (void)centerButtonDidClicked:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock(self.centerModel);
    }
}

- (void)setCenterModel:(NSDictionary *)centerModel
{
    _centerModel = centerModel;
    
    [self.centerButton removeFromSuperview];
    CGFloat btnWidth = 80.0;
    self.centerButton.frame = CGRectMake(0.0, 0.0, btnWidth, btnWidth);
    self.centerButton.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetWidth(self.frame)/2.0);
    NSString *title = [centerModel objectForKey:@"title"];
    NSString *iconName = [centerModel objectForKey:@"icon"];
    [self.centerButton setTitle:title forState:UIControlStateNormal];
    [self.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    self.centerButton.layer.cornerRadius = btnWidth/2.0;
    self.centerButton.backgroundColor = [UIColor greenColor];
    [self addSubview:self.centerButton];
}

- (void)reloadWithModelList:(NSArray *)list
{
    self.modelArray = list;
    
    [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnArray removeAllObjects];
    CGFloat btnWidth = 80.0;
    CGFloat corner = M_PI * 2.0 / list.count;
    // 各btn的center,在以self.center为圆心半径为r的圆上
    CGFloat r = (CGRectGetWidth(self.frame)- btnWidth)/2.0;
    CGFloat x = CGRectGetWidth(self.frame)/2.0;
    CGFloat y = CGRectGetWidth(self.frame)/2.0;
    for (int i = 0; i < list.count; i++) {
        NSDictionary *model = [list objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(0.0, 0.0, btnWidth, btnWidth);
        CGFloat currentCorner = i*corner - M_PI_2;
        btn.center = CGPointMake(x + r * cos(currentCorner), y + r * sin(currentCorner));
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
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
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
        CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
        CGPoint currentTouchPoint = [sender locationInView:self];
        CGPoint previousTouchPoint = self.beginPoint;
        // 根据反正切函数计算角度
        CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
        
        self.rotationAngleInRadians += angleInRadians;
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians);
            self.centerButton.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians));
            for (UIButton *btn in self.btnArray) {
                btn.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians));
            }
        }];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        int num = self.rotationAngleInRadians/(M_PI/3);
        int last = ((int)(self.rotationAngleInRadians*(180/M_PI)))%(60);
        if (abs(last)>=30) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI/3*(last>0?(num+1):(num-1)));
                self.centerButton.transform = CGAffineTransformMakeRotation(-(M_PI/3*(last>0?(num+1):(num-1))));
                for (UIButton *btn in self.btnArray) {
                    btn.transform = CGAffineTransformMakeRotation(-(M_PI/3*(last>0?(num+1):(num-1))));
                }
            }];
            //偏转角度保存。
            self.rotationAngleInRadians = M_PI/3*(last>0?(num+1):(num-1));
            NSLog(@"偏转角度 = %lf ", self.rotationAngleInRadians*(180/M_PI));
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI/3*num);
                self.centerButton.transform = CGAffineTransformMakeRotation(-(M_PI/3*num));
                for (UIButton *btn in self.btnArray) {
                    btn.transform = CGAffineTransformMakeRotation(-(M_PI/3*num));
                }
            }];
            //偏转角度保存。
            self.rotationAngleInRadians = M_PI/3*num;
        }
    }
}

@end
