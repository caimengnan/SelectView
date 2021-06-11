//
//  LZViewController.m
//  SelectView
//
//  Created by 570788791@qq.com on 06/11/2021.
//  Copyright (c) 2021 570788791@qq.com. All rights reserved.
//

#import "LZViewController.h"
#import "SelectView.h"

@interface LZViewController ()<SelectViewDelegate>

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SelectView *selevtView = [[SelectView alloc] initWithFrame:CGRectMake(0, self.view.center.y, [UIScreen mainScreen].bounds.size.width, 50)];
    selevtView.array = @[@"111",@"222",@"333",@"444",@"555",@"666",@"777",@"888",@"999",@"000"];
    [self.view addSubview:selevtView];
    selevtView.delegate = self;
}

- (void)selectViewDidSelectAtIndex:(NSInteger)index
{
    NSLog(@"点击的第%ld个",(long)index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
