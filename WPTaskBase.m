//
//  WPTaskBase.m
//  WPBackgroundTaskDemo
//
//  Created by 王鹏 on 2017/5/19.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPTaskBase.h"
#import "WPBackgroundManager.h"
@interface WPTaskBase ()

@property (assign) BOOL isObserve;


@end

@implementation WPTaskBase

- (void)dealloc {
    if (_isObserve) {
        [self removeObserver:[WPBackgroundManager shareDefault] forKeyPath:@"state"];
    }
}
-(instancetype)init{
    if (self = [super init]) {
        _uuid = [self createUUIDString];
    }
    return self;
}
/*创建任务唯一标识符
 */
-(NSString *)createUUIDString{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * uuidString = (__bridge NSString *)(uuid);
    CFRelease(uuid);
    return uuidString;
}
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
    _isObserve = YES;
}
- (void)start {
    _state = WPTaskStateRunning;
    
    //模拟执行任务
    sleep(3);
    //结果
    _state = WPTaskStateSuccess;
    NSLog(@"--------子任务执行完毕---------");
    if ([_delegate respondsToSelector:@selector(taskDidComplete:)]) {
        [_delegate taskDidComplete:self];
    }
}
@end
