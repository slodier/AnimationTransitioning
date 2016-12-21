//
//  TurnTransitioning.h
//  Sasuke
//
//  Created by CC on 2016/12/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CEDirection) {
    CEDirectionHorizontal,
    CEDirectionVertical
};

@interface TurnTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CEDirection flipDirection;

@property (nonatomic, assign) BOOL reverse;

@end
