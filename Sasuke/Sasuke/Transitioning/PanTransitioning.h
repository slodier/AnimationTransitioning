//
//  PanTransitioning.h
//  Sasuke
//
//  Created by CC on 2016/12/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, assign) NSTimeInterval duration;

@end
