//
//  ViewController.m
//  CustomBlock
//
//  Created by wangfei on 2018/9/7.
//  Copyright © 2018年 wangfei. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+WXKVO.h"
#import "NextViewController.h"
#import "WXMutipleProxy.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _person = [[Person alloc]init];
    
    [_person wx_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    
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
    
}
- (IBAction)pushAction:(id)sender {
    
    NextViewController *nextVc = [[NextViewController alloc]init];
    [self.navigationController pushViewController:nextVc animated:YES];
    
}

- (void)testDemo {
    NSLog(@"%s", __func__);
}

@end
