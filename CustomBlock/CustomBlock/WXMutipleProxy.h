//
//  WXMutipleProxy.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/10.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXProtocolTest.h"
#import "NSObject+MultiParams.h"

@interface WXMutipleProxy : NSObject

+ (instancetype)sharedInstance;

- (void)muProxyAddObject:(id)target;

- (void)muproxyRemoveObject;

@end

@interface TmpObj : NSObject<WXProtocolTest>


@end
