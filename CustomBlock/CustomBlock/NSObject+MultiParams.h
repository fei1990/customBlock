//
//  NSObject+MultiParams.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/25.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MultiParams)

- (id)wx_performSelector:(SEL)selector withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
