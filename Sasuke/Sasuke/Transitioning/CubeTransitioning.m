//
//  CubeTransitioning.m
//  Sasuke
//
//  Created by CC on 2016/12/20.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "CubeTransitioning.h"

#define PERSPECTIVE -1.0 / 200.0
#define ROTATION_ANGLE M_PI_2

@interface CubeTransitioning ()

@property (nonatomic) NSUInteger folds;

@end

@implementation CubeTransitioning

- (id)init {
    self = [super init];
    if (self) {
        self.cubeAnimationWay = CubeAnimationWayHorizontal;
        _folds = 2;
    }
    return self;
}

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

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    
    //计算方向
    int dir = self.reverse ? 1 : -1;
    
    //创建不同的 3D 动画
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;
    
    //创建一个内容视图来做转换动画
    UIView *generalContentView = [transitionContext containerView];
    
    switch (self.cubeAnimationWay) {
        case CubeAnimationWayHorizontal:
            viewFromTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            [toView.layer setAnchorPoint:CGPointMake(dir==1?0:1, 0.5)];
            [fromView.layer setAnchorPoint:CGPointMake(dir==1?1:0, 0.5)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(dir*(generalContentView.frame.size.width)/2.0, 0)];
            break;
            
        case CubeAnimationWayVertical:
            viewFromTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            [toView.layer setAnchorPoint:CGPointMake(0.5, dir==1?0:1)];
            [fromView.layer setAnchorPoint:CGPointMake(0.5, dir==1?1:0)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(0, dir*(generalContentView.frame.size.height)/2.0)];
            break;
            
        default:
            break;
    }
    
    viewFromTransform.m34 = PERSPECTIVE;
    viewToTransform.m34 = PERSPECTIVE;
    
    toView.layer.transform = viewToTransform;
    
    //创建阴影
    UIView *fromShadow = [self addOpacityToView:fromView withColor:[UIColor blackColor]];
    UIView *toShadow = [self addOpacityToView:toView withColor:[UIColor blackColor]];
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
    
    //Add the to- view
    [generalContentView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        switch (self.cubeAnimationWay) {
            case CubeAnimationWayHorizontal:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(-dir*generalContentView.frame.size.width/2.0, 0)];
                break;
                
            case CubeAnimationWayVertical:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(0, -dir*(generalContentView.frame.size.height)/2.0)];
                break;
                
            default:
                break;
        }
        
        fromView.layer.transform = viewFromTransform;
        toView.layer.transform = CATransform3DIdentity;
        
        [fromShadow setAlpha:1.0];
        [toShadow setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
        //设置每个元素的最终位置
        [generalContentView setTransform:CGAffineTransformIdentity];
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
        [fromView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [toView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        
        [fromShadow removeFromSuperview];
        [toShadow removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
        } else {
            [fromView removeFromSuperview];
        }
        //通知上下文的完成
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (UIView *)addOpacityToView:(UIView *) view withColor:(UIColor *)theColor
{
    UIView *shadowView = [[UIView alloc] initWithFrame:view.bounds];
    [shadowView setBackgroundColor:[theColor colorWithAlphaComponent:0.8]];
    [view addSubview:shadowView];
    return shadowView;
}

@end
