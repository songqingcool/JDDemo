//
//  JDSphereView.m
//  YoungTag
//
//  Created by 宋庆功 on 2018/11/7.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "JDSphereView.h"
#import "JD3DPoint.h"

@interface JDSphereView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CADisplayLink *inertia;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGFloat velocity;
@property (nonatomic, strong) NSMutableArray *coordinate;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) JD3DPoint *normalDirection;

@end

@implementation JDSphereView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:gesture];
    
    self.inertia = [CADisplayLink displayLinkWithTarget:self selector:@selector(inertiaStep)];
    [self.inertia addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = [gesture locationInView:self];
        [self timerStop];
        [self inertiaStop];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        
        JD3DPoint *direction = [[JD3DPoint alloc] init];
        direction.x = self.lastPoint.y - current.y;
        direction.y = current.x - self.lastPoint.x;
        direction.z = 0.0;
        
        CGFloat distance = sqrt(direction.x * direction.x + direction.y * direction.y);
        CGFloat angle = distance / (self.frame.size.width / 2.0);
        
        for (NSInteger i = 0; i < self.tags.count; i ++) {
            [self updateFrameOfPoint:i direction:direction andAngle:angle];
        }
        self.normalDirection = direction;
        self.lastPoint = current;
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocityP = [gesture velocityInView:self];
        self.velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y);
        [self inertiaStart];
    }
}

- (void)inertiaStep
{
    if (self.velocity <= 0.0) {
        [self inertiaStop];
    }else {
        self.velocity -= 70.0;
        CGFloat angle = self.velocity / self.frame.size.width * 2.0 * self.inertia.duration;
        for (NSInteger i = 0; i < self.tags.count; i ++) {
            [self updateFrameOfPoint:i direction:self.normalDirection andAngle:angle];
        }
    }
}

- (void)autoTurnRotation
{
    for (NSInteger i = 0; i < self.tags.count; i ++) {
        [self updateFrameOfPoint:i direction:self.normalDirection andAngle:0.002];
    }
}

#pragma mark - inertia

- (void)inertiaStart
{
    [self timerStop];
    self.inertia.paused = NO;
}

- (void)inertiaStop
{
    [self timerStart];
    self.inertia.paused = YES;
}

#pragma mark - timer
- (void)timerStart
{
    self.timer.paused = NO;
}

- (void)timerStop
{
    self.timer.paused = YES;
}

#pragma mark - set frame of point

- (void)updateFrameOfPoint:(NSInteger)index direction:(JD3DPoint *)direction andAngle:(CGFloat)angle
{
    JD3DPoint *point = [self.coordinate objectAtIndex:index];
    
    JD3DPoint *rPoint = [point makeRotationWithDirection:direction angle:angle];
    [self.coordinate replaceObjectAtIndex:index withObject:rPoint];
    
    [self setTagOfPoint:rPoint andIndex:index];
}

- (void)setTagOfPoint:(JD3DPoint *)point andIndex:(NSInteger)index
{
    UIView *view = [self.tags objectAtIndex:index];
    
    // 控制3D球形的位置
    view.center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.0), (point.y + 1) * self.frame.size.width / 2.0);
    
    CGFloat transform = (point.z + 2) / 3;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transform, transform);
    view.layer.zPosition = transform;
    view.alpha = transform;
    if (point.z < 0) {
        view.userInteractionEnabled = NO;
    }else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - initial set

- (void)setCloudTags:(NSArray *)array
{
    self.tags = [NSMutableArray arrayWithArray:array];
    self.coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < self.tags.count; i ++) {
        UIView *view = [self.tags objectAtIndex:i];
        // 控制出现时的动画效果
        view.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0); // 中心散开
        //  右下出现
        //  view.center = CGPointMake(self.frame.size.width / 2.0+ 200, self.frame.size.height / 2.0 + 300);
    }
    
    CGFloat p1 = M_PI * (3 - sqrt(5));
    CGFloat p2 = 2.0 / self.tags.count;
    
    for (NSInteger i = 0; i < self.tags.count; i ++) {
        
        CGFloat y = i * p2 - 1 + (p2 / 2);
        CGFloat r = sqrt(1 - y * y);
        CGFloat p3 = i * p1;
        CGFloat x = cos(p3) * r;
        CGFloat z = sin(p3) * r;
        
        JD3DPoint *point = [[JD3DPoint alloc] init];
        point.x = x;
        point.y = y;
        point.z = z;
        [self.coordinate addObject:point];
        
        CGFloat time = (arc4random() % 10 + 10.0) / 20.0;
        [UIView animateWithDuration:time delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setTagOfPoint:point andIndex:i];
        } completion:nil];
    }
    
    NSInteger a =  arc4random() % 10 - 5;
    NSInteger b =  arc4random() % 10 - 5;
    JD3DPoint *normalDirection = [[JD3DPoint alloc] init];
    normalDirection.x = a;
    normalDirection.y = b;
    normalDirection.z = 0.0;
    self.normalDirection = normalDirection;
    [self timerStart];
}

@end
