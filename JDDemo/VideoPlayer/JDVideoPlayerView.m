//
//  JDVideoPlayerView.m
//  JDDemo
//
//  Created by 宋庆功 on 2019/2/13.
//  Copyright © 2019 京东. All rights reserved.
//

#import "JDVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface JDVideoPlayerView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) id playerPeriodicTime;
@property (nonatomic, strong) NSURL *videoUrl;

@end

@implementation JDVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)playVideoWithUrl:(NSURL *)url
{
    [self releasePlayer];
    self.videoUrl = url;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    [self addObserverToPlayerItem:self.playerItem];

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerPeriodicTime = nil;
    self.playerPeriodicTime = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        NSLog(@"当前播放进度%.2f",currentTime);
    }];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = playerItem.status;
        if(status == AVPlayerStatusReadyToPlay){
            [self.player play];
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }else if (status == AVPlayerStatusFailed) {
            NSLog(@"状态：失败");
        }else if (status == AVPlayerStatusUnknown) {
            NSLog(@"状态：未知");
        }
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        // 本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        CMTime endTime = CMTimeRangeGetEnd(timeRange);
        // 缓冲总长度
        Float64 totalBuffer = CMTimeGetSeconds(endTime);
        CMTime duration = playerItem.duration;
        Float64 totalDuration = CMTimeGetSeconds(duration);
        NSLog(@"共缓冲：%.2f  比例 = %.2f",totalBuffer, totalBuffer / totalDuration);
    }
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)releasePlayer
{
    if (self.playerItem) {
        [self removeObserverFromPlayerItem:self.playerItem];
    }
    
    self.playerItem = nil;
    [self.player removeTimeObserver:self.playerPeriodicTime];
    self.playerPeriodicTime = nil;
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
}

- (void)dealloc
{
    [self releasePlayer];
}

#pragma mark - playerItemNotification

- (void)playerItemDidPlayToEndTimeNotification:(NSNotification *)notification
{
    NSLog(@"播放完成");
}

- (void)playerItemFailedToPlayToEndTimeNotification:(NSNotification *)notification
{
    NSLog(@"播放失败");
}

- (void)playerItemPlaybackStalledNotification:(NSNotification *)notification
{
    NSLog(@"播放异常中断");
}

#pragma mark - playerItemNotification

- (void)audioSessionRouteChangeNotification:(NSNotification *)notification
{
    NSNumber *ada = [notification.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey];
    if ([ada isEqual:@(AVAudioSessionRouteChangeReasonOldDeviceUnavailable)]) {
        [self.player play];
    }
}

@end
