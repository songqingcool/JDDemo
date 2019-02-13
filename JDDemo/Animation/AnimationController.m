//
//  AnimationController.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/28.
//  Copyright © 2018 京东. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController ()

@property (nonatomic, strong) UIView *aview;

@end

@implementation AnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.aview = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    self.aview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.aview];
    
    //    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    //    moveAnimation.duration = 0.8;//动画时间
    //    //动画起始值和终止值的设置
    //    moveAnimation.fromValue = @(self.aview.center.y);
    //    moveAnimation.toValue = @(self.aview.center.y-30);
    //    //一个时间函数，表示它以怎么样的时间运行
    //    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //    moveAnimation.repeatCount = HUGE_VALF;
    ////    moveAnimation.repeatDuration = 2;
    ////    moveAnimation.removedOnCompletion = YES;
    ////    moveAnimation.fillMode = kCAFillModeForwards;
    //    // 添加动画，后面有可以拿到这个动画的标识
    //    [self.aview.layer addAnimation:moveAnimation forKey:@"可以拿到这个动画的Key值"];
    
    
    //创建路径
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 450)];
    [bezierPath addCurveToPoint:CGPointMake(370, 500) controlPoint1:CGPointMake(350, 200) controlPoint2:CGPointMake(300, 600)]; //一个曲线
    //路径样式
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor; //填充色<默认黑色>
    shapeLayer.strokeColor = [UIColor blueColor].CGColor; //线色
    shapeLayer.lineWidth = 2;
    [self.view.layer addSublayer:shapeLayer];
    
    
    //    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    //    NSArray *rotationVelues = @[@(M_PI_4), @(-M_PI_4), @(M_PI_4)];
    //    animation.values = rotationVelues;
    //    animation.rotationMode = kCAAnimationRotateAuto;  //方向
    //    animation.duration = 3.0f;
    //    animation.keyTimes = @[@0.2 ,@0.8 ,@1];
    ////    animation.path = bezierPath.CGPath;
    //    animation.repeatCount = HUGE_VALF;
    //    [self.aview.layer addAnimation:animation forKey:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
