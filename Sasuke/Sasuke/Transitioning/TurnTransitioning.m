//
//  TurnTransitioning.m
//  Sasuke
//
//  Created by CC on 2016/12/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "TurnTransitioning.h"
#import <QuartzCore/QuartzCore.h>

@interface TurnTransitioning ()

@property (nonatomic) NSUInteger folds;

@end

@implementation TurnTransitioning

- (id)init {
    if (self = [super init]) {
        self.folds = 2;
        self.flipDirection = CEDirectionVertical;
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
    [containerView addSubview:toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    // reverse?
    float factor = self.reverse ? 1.0 : -1.0;
    
    // flip the to VC halfway round - hiding it
    toView.layer.transform = [self rotate:factor * -M_PI_2];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from view
                                                                    fromView.layer.transform = [self rotate:factor * M_PI_2];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the to view
                                                                    toView.layer.transform =  [self rotate:0.0];
                                                                }];
                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
    
}

- (CATransform3D) rotate:(CGFloat) angle {
    if (self.flipDirection == CEDirectionHorizontal)
        return  CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0);
    else
        return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}


@end
