//
//  JDSocketService.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/15.
//  Copyright © 2018年 京东. All rights reserved.
//

#import "JDSocketService.h"
#import "GCDAsyncSocket.h"

@interface JDSocketService () <GCDAsyncSocketDelegate>

@property (nonatomic, copy) NSString *host;
@property (nonatomic) uint16_t port;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *readBuffer;

@end

@implementation JDSocketService

/**
 *  单例实现
 *
 *  @return 返回单例实例
 */
+ (instancetype)sharedInstance
{
    static JDSocketService *instance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [[JDSocketService alloc] init];
    });
    return instance;
}

#pragma mark - Socket Life Manager

/**
 *  创建并链接Socket Server
 */
- (GCDAsyncSocket *)createAndConnectSocket
{
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    BOOL isConntected = [socket connectToHost:self.host onPort:self.port withTimeout:-1 error:&error];
    if (isConntected) {
        self.clientSocket = socket;
        return socket;
    }else{
        NSLog(@"connectToHost:%@",error);
        return nil;
    }
}

- (void)releaseSocketSafely
{
    if (self.clientSocket.isConnected) {
        [self.clientSocket disconnect];
    }
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
    
}

- (void)writeSocketData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.clientSocket writeData:data withTimeout:timeout tag:tag];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"\n~~~~~~~~~ socket（1）建立连接~~~~~~~~~\nhost：%@， port：%d\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n", host, port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"\n~~~~~~~~~ socket（3）返回数据~~~~~~~~~\n%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n", data);
    // 将数据存入缓存区
    [self.readBuffer appendData:data];
    
    // 数据中前面有4个字节的头信息，其中前两位是固定的头长度(用处不大),后两位才是数据的长度。
    // 如果大于4个字节证明有消息，因为服务器只要发送数据，必定包含头
    while (self.readBuffer.length > 4) {
        
        // 将消息转化成byte，计算总长度 = 数据的内容长度 + 前面4个字节的头长度
        Byte *bytes = (Byte *)[self.readBuffer bytes];
        NSUInteger allLength = (bytes[2]<<8) + bytes[3] +4;
//        Byte *bytes = nil;
//        [self.readBuffer getBytes:bytes length:4];
        
        // 缓存区的长度大于总长度，证明有完整的数据包在缓存区，然后进行处理
        if (self.readBuffer.length >= allLength) {
            NSMutableData *msgData = [[self.readBuffer subdataWithRange:NSMakeRange(0, allLength)] mutableCopy];
            // 提取出前面4个字节的头内容，之所以提取出来，是因为在处理数据问题的时候，比如data转json的时候，头内容里面包含非法字符，会导致转化出来的json内容为空，所以要先去掉再处理数据问题
            [msgData replaceBytesInRange:NSMakeRange(0, 4) withBytes:NULL length:0];
            
            NSLog(@"开始处理数据问题");
            
            // 处理完数据后将处理过的数据移出缓存区
            self.readBuffer = [NSMutableData dataWithData:[self.readBuffer subdataWithRange:NSMakeRange(allLength, self.readBuffer.length - allLength)]];
        }else{
            // 缓存区内数据包不是完整的,中断while循环,再次从服务器获取数据
            break;
        }
    }
    
    // 读取到服务端数据值后,能再次读取
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"\n~~~~~~~~~ socket（2）上传数据~~~~~~~~~\ntag：%ld\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n", tag);
    [self.clientSocket readDataWithTimeout:-1 tag:tag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"\n~~~~~~~~~ socket（4）断开链接~~~~~~~~~\nerror:%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n ",err.localizedDescription);
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
}

@end
