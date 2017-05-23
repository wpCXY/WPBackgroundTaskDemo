//
//  WPTaskBase.h
//  WPBackgroundTaskDemo
//
//  Created by 王鹏 on 2017/5/19.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPTaskBase;
typedef void(^TaskComplete)(WPTaskBase *task);



@protocol WPTaskDelegate <NSObject>

- (void)taskDidComplete:(WPTaskBase *)task;

@end

typedef NS_ENUM(NSInteger, WPTaskState){
    WPTaskStateWaiting = 1,
    WPTaskStateRunning,
    WPTaskStateFinish,
    WPTaskStateSuccess,
    WPTaskStateStop,
    WPTaskStateFail,
    WPTaskStateFail_1,
    WPTaskStateFail_2,
    WPTaskStateFail_3,

};


/**
 task的基类
 1、task的状态只有等待和运行状态是确定的，其他状态需要跟读业务的具体逻辑进行判断赋值。
 2、关于子任务的执行完成情况：在子任务执行完成后，需要告诉后台的任务队列，把后台任务队列中的任务删除，以及每个任务的完成回调。
    可以通过代理回调，子线程任务执行完成后，代理回调。
    block回调。
    KVO：在BackgroundManager中观察每个task的State从而对任务队列进行管理
 3、思考问题，子线程任务执行完成后是否真的需要回调？
 从task调用Start开始，标志这子任务开始执行，当任务执行完成后，线程又会执行下一个任务，在这个过程中只要确保，已经执行或者正在执行的任务从任务队列中剔除了。至于执行中的任务队列就可有可无了。
 若果业务需求需要知道每个子任务执行完成的结果 就需要回调
 4、思考问题：关于子任务的进度回调
 */
@interface WPTaskBase : NSObject

/**
 task状态
 */
@property (nonatomic, assign) WPTaskState state;

/**
 task唯一标识
 */
@property (nonatomic, strong) NSString *uuid;

/**
 task代理 主要是用于task任务执行完成后的回调
 */
@property (nonatomic, weak) id<WPTaskDelegate>delegate;


/**
 task开始执行任务
 */
- (void)start;
@end
