//
//  FoldTransitioning.m
//  Sasuke
//
//  Created by CC on 2016/12/20.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "FoldTransitioning.h"

@interface FoldTransitioning ()

@property (nonatomic) NSUInteger folds;

@end

@implementation FoldTransitioning

- (id)init {
    if (self = [super init]) {
        self.folds = 2;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _folds;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    
    // 移出屏幕
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
    [containerView addSubview:toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
    containerView.layer.sublayerTransform = transform;
    
    CGSize size = toView.frame.size;
    
    float foldWidth = size.width * 0.5 / (float)self.folds ;
    
    // 保存屏幕快照的数组
    NSMutableArray* fromViewFolds = [NSMutableArray new];
    NSMutableArray* toViewFolds = [NSMutableArray new];
    
    // 创建视图的折叠
    for (int i=0 ;i<self.folds; i++){
        float offset = (float)i * foldWidth * 2;
        
        // 左侧和右侧的折叠,伴随着转换和透明度为 0
        // 阴影中,每个视图在其初始位置
        UIView *leftFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset left:YES];
        leftFromViewFold.layer.position = CGPointMake(offset, size.height/2);
        [fromViewFolds addObject:leftFromViewFold];
        [leftFromViewFold.subviews[1] setAlpha:0.0];
        
        UIView *rightFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset + foldWidth left:NO];
        rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
        [fromViewFolds addObject:rightFromViewFold];
        [rightFromViewFold.subviews[1] setAlpha:0.0];
        
        // 左侧和右侧的折叠,伴随着转动 90°且透明度为 1.0
        // 阴影中,每个视图位于屏幕的边缘
        UIView *leftToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset left:YES];
        leftToViewFold.layer.position = CGPointMake(self.reverse ? size.width : 0.0, size.height/2);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset + foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(self.reverse ? size.width : 0.0, size.height/2);
        rightToViewFold.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:rightToViewFold];
    }
    
    // 移出屏幕
    fromView.frame = CGRectOffset(fromView.frame, fromView.frame.size.width, 0);
    
    // 创建动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        // 设置每个折叠的最终状态
        for (int i=0; i<self.folds; i++){
            
            float offset = (float)i * foldWidth * 2;
            
            // 左侧和右侧的折叠,转动 90°且透明度为 1.0
            // 阴影中,每个视图位于屏幕的边缘
            UIView* leftFromView = fromViewFolds[i*2];
            leftFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView* rightFromView = fromViewFolds[i*2+1];
            rightFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
            rightFromView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 1.0, 0);
            [rightFromView.subviews[1] setAlpha:1.0];
            
            // 左侧和右侧折叠,身份转换且透明度为 0
            // 阴影中,每个视图在其最终状态
            UIView* leftToView = toViewFolds[i*2];
            leftToView.layer.position = CGPointMake(offset, size.height/2);
            leftToView.layer.transform = CATransform3DIdentity;
            [leftToView.subviews[1] setAlpha:0.0];
            
            UIView* rightToView = toViewFolds[i*2+1];
            rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
            rightToView.layer.transform = CATransform3DIdentity;
            [rightToView.subviews[1] setAlpha:0.0];
        }
    }  completion:^(BOOL finished) {
        // 删除屏幕快照
        for (UIView *view in toViewFolds) {
            [view removeFromSuperview];
        }
        for (UIView *view in fromViewFolds) {
            [view removeFromSuperview];
        }
        
        BOOL transitionFinished = ![transitionContext transitionWasCancelled];
        if (transitionFinished) {
            // 恢复到初始位置
            toView.frame = containerView.bounds;
            fromView.frame = containerView.bounds;
        }
        else {
            // 如果取消,恢复到初始位置
            fromView.frame = containerView.bounds;
        }
        [transitionContext completeTransition:transitionFinished];
    }];
}

#pragma mark - 在给定视图创建屏幕快照
-(UIView*) createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left {
    
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)self.folds ;
    
    UIView* snapshotView;
    
    if (!afterUpdates) {
        // 创建有规律的屏幕快照
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    }else{
        // 由于某种原因,快照需要一段时间才能创建,这里我们放置快照
        // 另一个视图,具有相同的bckground颜色,以便在快照初始呈现时不太明显
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        // 屏幕快照的背景颜色和视图的背景颜色一致
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
    }
    
    // 创建一个阴影
    UIView* snapshotWithShadowView = [self addShadowToView:snapshotView reverse:left];
    
    // 添加到容器
    [containerView addSubview:snapshotWithShadowView];
    
    // 将锚点设置为视图的左边缘或右边缘
    snapshotWithShadowView.layer.anchorPoint = CGPointMake(left ? 0.0 : 1.0, 0.5);
    
    return snapshotWithShadowView;
}

#pragma mark - 通过创建一个包含给定视图的UIView来为图像添加一个渐变和梯度作为子视图
- (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse {
    
    // 创建一个相同 frame 的 view
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // 创建阴影
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // 将原始视图添加进新的视图
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // 阴影置于最顶
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

@end
