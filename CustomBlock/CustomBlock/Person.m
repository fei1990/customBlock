//
//  Person.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "Person.h"
#import "WXMutipleProxy.h"

@implementation Person

- (void)dealloc {
    NSLog(@"%s", __func__);
    NSLog(@"%@", [WXMutipleProxy sharedInstance].weakRefTargets);
}

- (instancetype)init {
    if (self = [super init]) {
        
        
        
        
    }
    return self;
}

- (void)testDemo {
    NSLog(@"%s", __func__);
}


@end
