//
//  WXDelegateMediation.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "WXDelegateMediation.h"

@implementation WXDelegateMediation

+ (instancetype)sharedInstance {
    
    static WXDelegateMediation *mediation = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediation = [[[self class] alloc] init];
        
        mediation.callback = ^(NSString *str) {
            
        };
        
        objc_setAssociatedObject(mediation, callbackKey, mediation.callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
    });
    
    return mediation;
}

@end
