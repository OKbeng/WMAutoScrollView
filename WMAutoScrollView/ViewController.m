//
//  ViewController.m
//  WMAutoScrollView
//
//  Created by Zhangwenmin on 2018/6/8.
//  Copyright © 2018年 Zhangwenmin. All rights reserved.
//

#import "ViewController.h"
#import "WMAutoScrollView/WMAutoScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WMAutoScrollView * scroll = [[WMAutoScrollView alloc] initWMAutoScrollViewWithFrame:self.view.bounds imageArray:@[@"qianqiani_1",@"qianqiani_2",@"qianqiani_3",@"qianqiani_4"]];
    scroll.isAuto = YES;
    scroll.isPageController = YES;
    scroll.second = 3;
    scroll.imageBlock = ^(NSInteger index) {
        
    };
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scroll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
