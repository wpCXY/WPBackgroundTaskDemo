//
//  ViewController.m
//  WPBackgroundTaskDemo
//
//  Created by 王鹏 on 2017/5/19.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "ViewController.h"
#import "WPBackgroundManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTaskToBackgroundManager];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 销毁后台队列
- (IBAction)destroy:(id)sender {
    [WPBackgroundManager destroy];
}
#pragma mark - 中途添加任务
- (IBAction)addANewTask:(id)sender {
    WPTaskBase *task = [[WPTaskBase alloc] init];
    [[WPBackgroundManager shareDefault] addTask:task];
}
#pragma mark - 创建子任务
- (NSArray *)creatTasks {
    NSMutableArray *tasks = [NSMutableArray array];
    for (int i = 0 ; i < 3  ; i++) {
        WPTaskBase *task = [[WPTaskBase alloc] init];
        [tasks addObject:task];
    }
    return tasks;
}

#pragma mark - 添加到后台
- (void)addTaskToBackgroundManager {
    [[WPBackgroundManager shareDefault] addTasks:[self creatTasks]];
}

@end
