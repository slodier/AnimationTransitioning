//
//  CubeTransitioning.h
//  Sasuke
//
//  Created by CC on 2016/12/20.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {CubeAnimationWayHorizontal, CubeAnimationWayVertical} CubeAnimationWay;
typedef enum {CubeAnimationTypeInverse, CubeAnimationTypeNormal} CubeAnimationType;

@interface CubeTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CubeAnimationWay cubeAnimationWay;
@property (nonatomic, assign) CubeAnimationType cubeAnimationType;

@property (nonatomic, assign) BOOL reverse;

@end
