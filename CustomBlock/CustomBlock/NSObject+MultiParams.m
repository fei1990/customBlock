//
//  NSObject+MultiParams.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/25.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "NSObject+MultiParams.h"

@implementation NSObject (MultiParams)

//NS_REQUIRES_NIL_TERMINATION：是对多参数传递值得一个宏  结尾已nil结束
- (id)wx_performSelector:(SEL)selector withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION {
    //根据类名以及SEL 获取方法签名的实例
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    if (signature == nil) {
        
        NSLog(@"--- 使用实例方法调用 为nil ---");
        
        signature = [self methodSignatureForSelector:selector];
        
        if (signature == nil) {
            
            NSLog(@"使用类方法调用 也为nil， 此时return");
            
            return nil;
            
        }
        
    }
    
    //NSInvocation是一个消息调用类，它包含了所有OC消息的成分：target、selector、参数以及返回值。
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    
    invocation.selector = selector;
    
    NSUInteger argCount = signature.numberOfArguments;
    
    // 参数必须从第2个索引开始，因为前两个已经被target和selector使用
    
    argCount = argCount > 2 ? argCount - 2 : 0;
    
    NSMutableArray *objs = [NSMutableArray arrayWithCapacity:0];
    
    if (object) {
        
        [objs addObject:object];
        
        //定义一个指向个数可变的参数列表指针
        va_list args;
        
        //va_start(args,object)：object为第一个参数，也就是最右边的已知参数,这里就是获取第一个可选参数的地址.使参数列表指针指向函数参数列表中的第一个可选参数，函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。
        va_start(args, object);
        
        //va_arg(args,id)：返回参数列表中指针所指的参数，返回类型为id，并使参数指针指向参数列表中下一个参数。
        while ((object = va_arg(args, id))){
            
            [objs addObject:object];
            
            
        }
        
        //清空参数列表，并置参数指针args无效。
        va_end(args);
        
    }
    
    if (objs.count != argCount){
        
        NSLog(@"--- objs.count != argCount! please check it! ---");
        
        return nil;
        
    }
    
    //设置参数列表
    for (NSInteger i = 0; i < objs.count; i++) {
        
        id obj = objs[i];
        
        if ([obj isKindOfClass:[NSNull class]]) {
            
            continue;
            
        }
        
        [invocation setArgument:&obj atIndex:i+2];
        
    }
    
    [invocation invoke];
    
    //获取返回值
    id returnValue = nil;
    
    if (signature.methodReturnLength != 0 && signature.methodReturnLength) {
        
        [invocation getReturnValue:&signature];
    
    }
    
    return returnValue;
    
}
    

@end
