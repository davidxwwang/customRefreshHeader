//
//  UIScrollView+refresh.m
//  customRefreshHeader
//
//  Created by xwwang_0102 on 16/9/11.
//  Copyright © 2016年 xwwang_0102. All rights reserved.
//
#import <objc/runtime.h>
#import "UIScrollView+refresh.h"
static char MJRefreshHeaderKey;

@implementation UIScrollView (refresh)


- (void)setLegendHeader:(EMLegandHeader *)legendHeader
{
    objc_setAssociatedObject(self, &MJRefreshHeaderKey,legendHeader,OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:legendHeader];
    
    
//    if (header != self.header) {
//        [self.header removeFromSuperview];
//        
////        [self willChangeValueForKey:@"header"];
////        objc_setAssociatedObject(self, &MJRefreshHeaderKey,
////                                 header,
////                                 OBJC_ASSOCIATION_ASSIGN);
////        [self didChangeValueForKey:@"header"];
//        
//        [self addSubview:header];
//    }
}

- (UIView *)legendHeader
{
    return objc_getAssociatedObject(self, &MJRefreshHeaderKey);
}


- (EMLegandHeader *)addLegendHeaderWithRefreshingBlock:(void (^)())block;
{
    UIView *view = [[EMLegandHeader alloc]initWithFrame:CGRectMake(0, 0 - 44, 370, 44)];
    view.backgroundColor = [UIColor yellowColor];
    self.legendHeader = view;
    block();
    return self.legendHeader;
}


@end
