//
//  SelectView.h
//  OC Test
//
//  Created by The Man In Your Dream on 2021/6/11.
//  Copyright © 2021 The Man In Your Dream. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectViewDelegate <NSObject>
- (void)selectViewDidSelectAtIndex:(NSInteger)index;
@end

typedef void(^SelectViewDidSelectCallBack)(NSInteger index);

@interface SelectView : UIView
- (void)scrollToItemAtIndex:(NSInteger)index;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,assign) id<SelectViewDelegate> delegate;
@property (nonatomic,copy) SelectViewDidSelectCallBack selectCallBack;
@end

NS_ASSUME_NONNULL_END
