//
//  Person.h
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXProtocolTest.h"

@interface Person : NSObject<WXProtocolTest>

@property (nonatomic, copy) NSString *name;

@end
