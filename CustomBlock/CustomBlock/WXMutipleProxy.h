//
//  WXMutipleProxy.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/10.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXMutipleProxy : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray *delegates;

@property (nonatomic, strong) NSPointerArray *weakRefTargets;

- (void)muProxyAddObject:(id)target;



@end
