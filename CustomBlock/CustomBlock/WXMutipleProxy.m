//
//  WXMutipleProxy.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/10.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "WXMutipleProxy.h"

@interface WXMutipleProxy()

@end

@implementation WXMutipleProxy

+ (instancetype)sharedInstance {
    
    static WXMutipleProxy *muProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        muProxy = [[WXMutipleProxy alloc]init];
        muProxy.weakRefTargets = [NSPointerArray weakObjectsPointerArray];
    });
    return muProxy;
}

- (void)muProxyAddObject:(id)target {
    
    [[WXMutipleProxy sharedInstance].weakRefTargets addPointer:(__bridge void *)target];
    
}

- (void)setDelegates:(NSArray *)delegates {
    
    for (id target in delegates) {
        [self.weakRefTargets addPointer:(__bridge void*)target];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (id target in self.weakRefTargets) {
            if ((signature = [target methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id target in self.weakRefTargets) {
        if ([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}

@end
