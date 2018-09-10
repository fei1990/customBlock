//
//  NSObject+WXKVO.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WXKVO)

- (void)wx_addObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
