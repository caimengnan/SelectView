//
//  SelectView.m
//  OC Test
//
//  Created by The Man In Your Dream on 2021/6/11.
//  Copyright © 2021 The Man In Your Dream. All rights reserved.
//

#import "SelectView.h"

#define btnCount 5
#define scrollHeight 50
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SelectView()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat contentOffsetX;
@end

@implementation SelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    //创建Button
    CGFloat width = WIDTH/btnCount;
    for (int i = 0; i < array.count; i++) {
        UIButton *seletBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [seletBtn setTitle:array[i] forState:(UIControlStateNormal)];
        seletBtn.frame = CGRectMake(width * i, 0, WIDTH/btnCount, scrollHeight);
        [seletBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        seletBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        seletBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        seletBtn.backgroundColor = [UIColor greenColor];
        [self.scrollView addSubview:seletBtn];
        [seletBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
        seletBtn.tag = 10000 + i;
    }
    self.scrollView.contentSize = CGSizeMake(array.count * width, scrollHeight);
}

//点击Item scrollView滑动
- (void)selectAction:(UIButton *)sender
{
    if (self.scrollView.contentSize.width < WIDTH) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    
    //响应代理
    if ([self.delegate respondsToSelector:@selector(selectViewDidSelectAtIndex:)]) {
        [self.delegate selectViewDidSelectAtIndex:sender.tag-10000];
    }
    
    //回调
    if (self.selectCallBack) {
        self.selectCallBack(sender.tag-10000);
    }
    
    //1，当前按钮的中心x(scrollview上)
    CGFloat currentBtnCenterXOnScrollView = sender.center.x;
    //2，当前按钮的中心x(父视图上)
    CGFloat currentBtnCenterXOnSuperView = [self.scrollView convertPoint:sender.center toView:self].x;
    
    //3，当前父视图中心点
    CGFloat centerX = self.center.x;
    
    NSLog(@"%f,%f",currentBtnCenterXOnScrollView,currentBtnCenterXOnSuperView);
    
    //中心点距离父视图中心点的距离
    CGFloat distanceToSuperCenter = currentBtnCenterXOnSuperView - centerX;
    //对比大小，判断按钮在父视图的左边还是右边
    if (distanceToSuperCenter < 0) {
        NSLog(@"在中心点左边");
        //判断是否需要向右移动，判断方法：按钮中心到父视图中心距离M scrollView偏移量N 对比M、N的大小，若N大于M，则可以右移，否则不做处理
        //移动,移动距离为两中心的距离
        if (self.contentOffsetX > fabs(distanceToSuperCenter)) {
            [self.scrollView setContentOffset:CGPointMake(distanceToSuperCenter+self.contentOffsetX, 0) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        NSLog(@"在中心点右边");
        //计算可向左滑动的最大距离
        CGFloat canScrollDistance = self.scrollView.contentSize.width-self.contentOffsetX-WIDTH;
        //判断是否可继续向左滑动
        if (canScrollDistance > distanceToSuperCenter) {
            [self.scrollView setContentOffset:CGPointMake(distanceToSuperCenter + self.contentOffsetX, 0) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-WIDTH, 0) animated:YES];
        }
    }
}

//TODO:可以添加是否需要动画
///外部事件控制滑动到第几个Item
- (void)scrollToItemAtIndex:(NSInteger)index
{
    NSInteger tag = index + 10000;
    UIButton *targetBtn = (UIButton *)[self viewWithTag:tag];
    [self selectAction:targetBtn];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    self.contentOffsetX = contentOffsetX;
}

@end
