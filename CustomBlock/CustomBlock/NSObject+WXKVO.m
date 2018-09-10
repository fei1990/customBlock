//
//  NSObject+WXKVO.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "NSObject+WXKVO.h"
#import <objc/message.h>

static const char *WXKVO_observer = "WXKVO_observer";
static const char *WXKVO_getter = "WXKVO_getter";
static const char *WXKVO_setter = "WXKVO_setter";

@implementation NSObject (WXKVO)

- (void)wx_addObserver:(nonnull NSObject *)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    
    //1.动态创建子类
    //1.1 获取类名字
    NSString *className = NSStringFromClass([self class]);
    
    //1.2 在该类名称前拼前缀 WXKVONotifying_
    NSString *subClassName = [NSString stringWithFormat:@"WXKVONotifying_%@", className];
    
    //1.3 根据subClassName 获取新类
    Class subClass = objc_getClass(subClassName.UTF8String);
    
    if (!subClass) {
        subClass = objc_allocateClassPair([self class], subClassName.UTF8String, 0);  //创建 super class 的子类
        objc_registerClassPair(subClass);  //注册该新建的class
    }
    
    //2.重写被监听对象属性的set方法（属性名首字母大写，属性末尾拼":"）
    //2.1
    NSString *setMethodStr = [@"set" stringByAppendingString:[[[[keyPath substringToIndex:1] uppercaseString] stringByAppendingString:[keyPath substringFromIndex:1]] stringByAppendingString:@":"]];
    
    //2.2 为刚才新建的类添加 该set 方法
    //2.2.1 生成SEL  选择子
    SEL setSel = NSSelectorFromString(setMethodStr);
    
    //2.2.2  获取方法types keyPath：该属性的get方法 通过keyPath获取types types包含方法的参数、返回值等
    Method getMethod = class_getInstanceMethod([self class], @selector(keyPath));
    const char * types = method_getTypeEncoding(getMethod);
    
    //2.2.3 添加set 方法
    class_addMethod(subClass, setSel, (IMP)setMethod, types);
    
    //3.将该对象的isa指向新建的子类
    object_setClass(self, subClass);
    
    //4.关联对象 目的是为了在setMethod方法里 获取需要的值
    objc_setAssociatedObject(self, WXKVO_observer, observer, OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(self, WXKVO_getter, keyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, WXKVO_setter, setMethodStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
}

void setMethod(id self, SEL _cmd, id newValue) {
    
    //获取get set 方法名
    NSString *getMethodName = objc_getAssociatedObject(self, WXKVO_getter);
    NSString *setMethodName = objc_getAssociatedObject(self, WXKVO_setter);
    
    //获取子类
    Class class = [self class];
    
    //将isa指向原类
    object_setClass(self, class_getSuperclass(class));
    
    //调用原类的get方法  获取旧值
    id oldValue = objc_msgSend(self, NSSelectorFromString(getMethodName));
    
    //调用原类的set方法
    objc_msgSend(self, NSSelectorFromString(setMethodName), newValue);
    
    //获取observer
    id observer = objc_getAssociatedObject(self, WXKVO_observer);
    
    NSMutableDictionary *change = [NSMutableDictionary dictionary];
    
    if (oldValue) {
        change[NSKeyValueChangeOldKey] = oldValue;
    }
    
    if (newValue) {
        change[NSKeyValueChangeNewKey] = newValue;
    }
    
    //调用observer的 observeValueForKeyPath: ofObject: change: context:
    objc_msgSend(observer, @selector(observeValueForKeyPath: ofObject: change: context:), getMethodName, self, change, NULL);
    
    //self的isa重新指回子类
    object_setClass(self, class);
    
}

@end
