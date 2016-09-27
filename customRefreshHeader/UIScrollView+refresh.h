//
//  UIScrollView+refresh.h
//  customRefreshHeader
//
//  Created by xwwang_0102 on 16/9/11.
//  Copyright © 2016年 xwwang_0102. All rights reserved.
//
#import "EMLegandHeader.h"
#import <UIKit/UIKit.h>

@interface UIScrollView (refresh)

/** 传统的下拉刷新控件 */
//@property (nonatomic, readonly) MJRefreshLegendHeader *legendHeader;
@property (nonatomic, readonly) EMLegandHeader *legendHeader;

#pragma mark - 添加下拉刷新控件
/**
 * 添加一个传统的下拉刷新控件
 *
 * @param block 进入刷新状态就会自动调用这个block
 */
- (EMLegandHeader *)addLegendHeaderWithRefreshingBlock:(void (^)())block;

@end
