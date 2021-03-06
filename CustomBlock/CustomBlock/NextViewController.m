//
//  NextViewController.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "NextViewController.h"
#import "Person.h"
#import "NSObject+WXKVO.h"
#import "NSObject+WXKVO_block.h"
#import "WXMutipleProxy.h"

@interface NextViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation NextViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [[WXMutipleProxy sharedInstance] muproxyRemoveObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _person = [[Person alloc]init];
    
//    [_person wx_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    
    [_person wx_addObserverForKeyPath:@"name" options:NSKeyValueObservingOptionNew callback:^(NSString *keyPath, NSDictionary *change) {
        
        if ([keyPath isEqualToString:@"name"]) {
            NSString *newValue = change[NSKeyValueChangeNewKey];
            
            NSLog(@"name : %@", newValue);
        }
        
    }];
    
    [[WXMutipleProxy sharedInstance] muProxyAddObject:self.person];
    [[WXMutipleProxy sharedInstance] muProxyAddObject:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"name"]) {
        
        NSString *newValue = change[NSKeyValueChangeNewKey];
        
        NSLog(@"name : %@", newValue);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    int i = random() % 100;
    
    _person.name = [NSString stringWithFormat:@"%d", i];
    
    [[WXMutipleProxy sharedInstance] performSelector:@selector(testDemo)];
    
    [[WXMutipleProxy sharedInstance] wx_performSelector:@selector(testMutiParams:obj2:obj3:) withObject:[NSObject new], [NSObject new], [NSObject new], nil];

}

#pragma mark - wx delegate
- (void)testDemo {
    NSLog(@"%s", __func__);
}

- (void)testMutiParams:(id)obj1 obj2:(id)obj2 obj3:(id)obj3 {
    
    NSLog(@"obj1 :%p", obj1);
    
    NSLog(@"obj2 :%p", obj2);
    
    NSLog(@"obj3 :%p", obj3);
    
}

@end
