//
//  WXMutipleProxy.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/10.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "WXMutipleProxy.h"
#import <malloc/malloc.h>
#import <objc/runtime.h>

@interface WXMutipleProxy()

@property (nonatomic, strong) NSPointerArray *weakRefTargets;

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

- (void)muproxyRemoveObject {

    //先执行addPointer:NULL 是为了保证 compact 可以remove掉所有NULL value
    [self.weakRefTargets addPointer:NULL];
    
    //Removes NULL values
    [self.weakRefTargets compact];
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
//    if (self.weakRefTargets.count == 0) {
//        TmpObj *tmpObj = [TmpObj new];
//        NSMethodSignature *sig = [tmpObj methodSignatureForSelector:aSelector];
//        return sig;
//    }
    
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

@implementation TmpObj

//- (void)testDemo {}
//
//- (void)testMutiParams:(id)obj1 obj2:(id)obj2 obj3:(id)obj3{}

@end
