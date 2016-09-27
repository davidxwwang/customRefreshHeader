//
//  EMLegandHeader.h
//  customRefreshHeader
//
//  Created by xwwang_0102 on 16/9/11.
//  Copyright © 2016年 xwwang_0102. All rights reserved.
//

#import <UIKit/UIKit.h>
// 下拉刷新控件的状态
typedef enum {
    /** 普通闲置状态 */
    MJRefreshHeaderStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MJRefreshHeaderStatePulling,
    /** 正在刷新中的状态 */
    MJRefreshHeaderStateRefreshing,
    /** 即将刷新的状态 */
    MJRefreshHeaderStateWillRefresh
} MJRefreshHeaderState;



@interface EMLegandHeader : UIView

@property (nonatomic ,assign)MJRefreshHeaderState state;
@property (nonatomic ,weak)UIScrollView *scrollView;

@end
