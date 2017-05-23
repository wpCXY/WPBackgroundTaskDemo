//
//  WPBackgroundManager.h
//  WPBackgroundTaskDemo
//
//  Created by 王鹏 on 2017/5/19.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPTaskBase.h"


@class WPBackgroundManager;

@protocol WPBackgroundManagerDelegate <NSObject>
@optional
/**
 子任务执行完成

 @param bgManager 任务队列管理类
 @param task 子任务
 */
- (void)backgroundManager:(WPBackgroundManager *)bgManager taskFinish:(WPTaskBase *)task;

@end

/**
 后台任务管理类
 将添加到任务队列中的task都执行一次
 每个task执行完成后都可以通过代理回调出来
 任务队列不关心执行的结果，执行完后就执行下一个，没有任务时就会进入每0.5秒一次的轮询
 销毁后台任务管理时，线程也会被销毁，所有添加进来的task都不会保存
 所有task的添加删除都是线程安全的
 
 思考：关于后台任务队列多个任务并行执行
 开启多个线程同时执行任务,线程的个数可以设置，保证任务队列中的任务存取是线程安全即可
 */
@interface WPBackgroundManager : NSObject

/**
 runningTasks存放的是当前执行的Task的UUID 
 可有可无的属性
 或者可改为 runningTask 保存当前执行的task
 */
@property (nonatomic, strong) NSMutableArray      *runningTasks;

/**
 waitingTasks存放的是等待执行的Task的UUID
 */
@property (nonatomic, strong) NSMutableArray      *waitingTasks;

/**
 taskDict存放的是所有的Task(包括执行中的和等待执行的) 
 key：Task的UUID value：Task
 */
@property (nonatomic, strong) NSMutableDictionary *taskDict;

/**
 子线程退出标志
 */
@property (nonatomic, assign) BOOL exitFlag;

/**
 后台任务回调：子任务执行完成
 */
@property (nonatomic, weak) id<WPBackgroundManagerDelegate>delegate;


/**
 单例创建

 @return self
 */
+ (instancetype)shareDefault;

/**
 单例销毁
 */
+ (void)destroy;

/**
 添加子任务

 @param task 子任务
 @return YES 添加成功 NO 添加失败
 */
- (BOOL)addTask:(WPTaskBase *)task;

/**
 添加子任务数组

 @param tasks 子任务数组
 @return YES 添加成功 NO 添加失败
 */
- (BOOL)addTasks:(NSArray <WPTaskBase *> *)tasks;

@end
