//
//  WPBackgroundManager.m
//  WPBackgroundTaskDemo
//
//  Created by 王鹏 on 2017/5/19.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPBackgroundManager.h"

@interface WPBackgroundManager () <WPTaskDelegate>

@end

@implementation WPBackgroundManager
static WPBackgroundManager *instance = nil;

+ (instancetype)shareDefault {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[WPBackgroundManager alloc] init];
        }
    }
    return instance;
}
+ (void)destroy {
    // 销毁前需要把线程退出标志设置为YES
    instance.exitFlag = YES;
    instance = nil;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _runningTasks = [[NSMutableArray alloc] init];
        _waitingTasks = [[NSMutableArray alloc] init];
        _taskDict     = [[NSMutableDictionary alloc] init];
        [NSThread detachNewThreadSelector:@selector(taskThread) toTarget:self withObject:nil];

    }
    return self;
}
- (void)taskThread {
    while (!_exitFlag) {
        @autoreleasepool {
            WPTaskBase *task = [self getFirstWaitingTask];
            if (task) {
                [task start];
            } else {
                //休眠0.5秒
                usleep(500000);
                
            }
        }
    }
}
#pragma mark - 获取任务队列中的任务
- (WPTaskBase *)getFirstWaitingTask {
    WPTaskBase *task = nil;
    @synchronized (self) {
        if (_waitingTasks.count) {
            NSString *uuid = _waitingTasks.firstObject;
            [_runningTasks addObject:uuid];
            task = [_taskDict valueForKey:uuid];
            [_waitingTasks removeObjectAtIndex:0];
        }
    }
    return task;
}
#pragma mark - 添加任务
- (BOOL)addTask:(WPTaskBase *)task {
    if (task) {
        @synchronized (self) {
            [_waitingTasks addObject:task.uuid];
            [_taskDict setValue:task forKey:task.uuid];
            task.state = WPTaskStateWaiting;
        }
        return YES;
    }
    return NO;
}
- (BOOL)addTasks:(NSArray<WPTaskBase *> *)tasks {
    if (tasks.count) {
        for (WPTaskBase *task in tasks) {
            [self addTask:task];
        }
    }
    return NO;
}
#pragma mark - WPTaskDelegate
- (void)taskDidComplete:(WPTaskBase *)task {
    if (task) {
        @synchronized (self) {
            [_runningTasks removeObject:task.uuid];
            [_taskDict removeObjectForKey:task.uuid];
            if (_delegate) {
                if ([_delegate respondsToSelector:@selector(backgroundManager:taskFinish:)]) {
                    [_delegate backgroundManager:self taskFinish:task];
                }
                
            }
        }
    }
}

@end
