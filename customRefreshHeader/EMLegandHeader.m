//
//  EMLegandHeader.m
//  customRefreshHeader
//
//  Created by xwwang_0102 on 16/9/11.
//  Copyright © 2016年 xwwang_0102. All rights reserved.
//
#import "EMRefreshConst.h"
#import "EMLegandHeader.h"

NSString *const MJRefreshHeaderStateIdleText = @"下拉可以刷新";
NSString *const MJRefreshHeaderStatePullingText = @"松开立即刷新";
NSString *const MJRefreshHeaderStateRefreshingText = @"正在刷新数据中...";

@interface EMLegandHeader()

@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *stateLabel;

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation EMLegandHeader

- (id)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame])
    {
        self.state = MJRefreshHeaderStateIdle;
        
        // 初始化文字
        [self setTitle:MJRefreshHeaderStateIdleText forState:MJRefreshHeaderStateIdle];
        [self setTitle:MJRefreshHeaderStatePullingText forState:MJRefreshHeaderStatePulling];
        [self setTitle:MJRefreshHeaderStateRefreshingText forState:MJRefreshHeaderStateRefreshing];
    }
   
    
    return self;
}

#pragma mark - 懒加载

- (NSMutableDictionary *)stateTitles
{
    if (_stateTitles == nil) {
        _stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        stateLabel.backgroundColor = [UIColor redColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel = stateLabel];
    }
    return _stateLabel;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 箭头
    CGRect rect = self.bounds;
    CGFloat arrowX =  (rect.size.width * 0.5 - 100);
    self.arrowImage.center = CGPointMake(arrowX, rect.size.height * 0.5);
    self.activityView.center = self.arrowImage.center;
    self.stateLabel.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshHeaderState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    
    // 刷新当前状态的文字
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
    }
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
//        // 设置宽度
//        self.mj_w = newSuperview.mj_w;
//        // 设置位置
//        self.mj_x = 0;
//        
//        // 记录UIScrollView
//        self.scrollView = (UIScrollView *)newSuperview;
//        // 设置永远支持垂直弹簧效果
//        self.scrollView.alwaysBounceVertical = YES;
//        // 记录UIScrollView最开始的contentInset
//        self.scrollViewOriginalInset = self.scrollView.contentInset;
    }
}

#pragma mark KVO属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    // 遇到这些情况就直接返回
//    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.state == MJRefreshHeaderStateRefreshing) return;
    
    // 根据contentOffset调整state
    if ([keyPath isEqualToString:MJRefreshContentOffset]) {
       // NSLog(@"--->%@",change);
        [self adjustStateWithContentOffset];
    }
}

- (void)adjustStateWithContentOffset
{
    _scrollView.backgroundColor = [UIColor blueColor];
    CGFloat offsetY = _scrollView.contentOffset.y;
   // NSLog(@"此时 offset ＝ %f",offsetY);
    NSLog(@"此时 offset ＝ %f",offsetY);
    NSLog(@"此时 contentInset top ＝ %f",_scrollView.contentInset.top);
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - 64;//- _scrollViewOriginalInset.top;
    
    if (offsetY >= happenOffsetY) //向上滑动
    {
         self.state = MJRefreshHeaderStateIdle;
        return;
    }
    
    // 在刷新的 refreshing 状态，动态设置 content inset
    if (self.state == MJRefreshHeaderStateRefreshing ) {
        self.state = MJRefreshHeaderStatePulling;
//        if(_scrollView.contentOffset.y >= _scrollView.contentInset.top ) {
//            _scrollView.mj_insetT = _scrollViewOriginalInset.top;
//        } else {
//            _scrollView.mj_insetT = MIN(_scrollViewOriginalInset.top + self.mj_h,
//                                        _scrollViewOriginalInset.top - _scrollView.contentOffset.y);
//        }
        return;
    }

    
    
    if(_scrollView.isDragging){
        if( self.state == MJRefreshHeaderStateIdle && offsetY < (happenOffsetY )){
            self.state = MJRefreshHeaderStatePulling;//向下滚动
        }
        else if (self.state == MJRefreshHeaderStatePulling && offsetY > happenOffsetY){
            self.state = MJRefreshHeaderStateIdle;//向上滚动，且滚动超过初始设定值
        }
//        else if (self.state == MJRefreshHeaderStateRefreshing)
//        {
//            self.state = MJRefreshHeaderStatePulling;
//        }
        
    }
    else if (self.state == MJRefreshHeaderStatePulling){
         self.state = MJRefreshHeaderStateRefreshing;
    }

}

- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    _stateLabel.text = _stateTitles[@(state)];
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            NSLog(@"目前状态为默认状态");
            if (oldState == MJRefreshHeaderStateRefreshing)
            {
                self.arrowImage.transform = CGAffineTransformIdentity;
                 [self.activityView stopAnimating];
//                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                    self.activityView.alpha = 0.0;
//                } completion:^(BOOL finished) {
//                    self.arrowImage.alpha = 1.0;
//                    self.activityView.alpha = 1.0;
//                   
//                }];
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            NSLog(@"目前状态为下拉刷新中");
            
            [UIView animateWithDuration:0.5 animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            NSLog(@"目前状态为网络请求中");
            
            [self.activityView startAnimating];
            self.arrowImage.alpha = 0.0;
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
                // 增加滚动区域
                CGFloat top = 100;
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.top = top;
                    _scrollView.contentInset = inset;
                
                // 设置滚动位置
              //  _scrollView.contentOffset = CGPointMake(0, -top);
            } completion:^(BOOL finished) {
                // 回调
//                if (self.refreshingBlock) {
//                    self.refreshingBlock();
//                }
                
            }];
            
            break;
        }
            
        default:
            break;
    }
    
   // NSLog(@"目前状态为－》 %u",_state);
    _state = state;
}




@end
