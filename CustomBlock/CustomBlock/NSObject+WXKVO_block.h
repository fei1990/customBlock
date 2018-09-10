//
//  NSObject+WXKVO_block.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KVO_block)(NSString *keyPath,NSDictionary *change);

@interface NSObject (WXKVO_block)

- (void)wx_addObserverForKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options callback:(KVO_block)callback;

@end
