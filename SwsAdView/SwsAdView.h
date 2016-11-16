//
//  SwsAdView.h
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwsAdView : UIView

/** SwsAdView */
- (SwsAdView *)initWithImageData:(NSString *)imageData
                     launchTimes:(NSInteger)launchTimes
                           adUrl:(NSString *)adUrl;

/** show */
- (void)show;

@end
