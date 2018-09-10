//
//  WXDelegateMediation.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol WXDelegateMediationDelegate<NSObject>

- (void)testDelegate:(NSString *)str;

@end

typedef void(^Callback)(NSString *str);

static const char *callbackKey;

@interface WXDelegateMediation : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<WXDelegateMediationDelegate> delegate;

@property (nonatomic, copy) Callback callback;

@end
