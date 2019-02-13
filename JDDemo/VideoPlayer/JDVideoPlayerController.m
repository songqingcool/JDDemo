//
//  JDVideoPlayerController.m
//  JDDemo
//
//  Created by 宋庆功 on 2019/2/13.
//  Copyright © 2019 京东. All rights reserved.
//

#import "JDVideoPlayerController.h"
#import "JDVideoPlayerView.h"

@interface JDVideoPlayerController ()

@property (nonatomic, strong) JDVideoPlayerView *playerView;

@end

@implementation JDVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playerView = [[JDVideoPlayerView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    [self.view addSubview:self.playerView];
    
    [self.playerView playVideoWithUrl:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
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
