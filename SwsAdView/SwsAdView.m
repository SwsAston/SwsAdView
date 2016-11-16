//
//  SwsAdView.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#define TimeNum 5  // 广告时间

#import "SwsAdView.h"
#import "AppDelegate.h"

@interface SwsAdView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *skipView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, copy)   NSString *imageData;
@property (nonatomic, copy)   NSString *adUrl;

@end

@implementation SwsAdView

- (SwsAdView *)initWithImageData:(NSString *)imageData
                     launchTimes:(NSInteger)launchTimes
                           adUrl:(NSString *)adUrl {
    
    SwsAdView *view = [[[NSBundle mainBundle] loadNibNamed:@"SwsAdView" owner:self options:nil]firstObject];
    view.frame = [UIScreen mainScreen].bounds;
    view.timeNum = TimeNum;
    view.adUrl = adUrl;
    view.timeLabel.text = [NSString stringWithFormat:@"跳过 %ld", view.timeNum];
    view.skipView.layer.cornerRadius = 3.0;
    view.skipView.layer.masksToBounds = YES;
    view.imageData = imageData;
    
    if ([imageData hasPrefix:@"http"]) {
        
          view.imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageData]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [view.imageView sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
    } else {
        
        view.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageData ofType:nil]];
    }
    
    // 记录启动次数
    NSString *launchString = [[NSUserDefaults standardUserDefaults] objectForKey:imageData];
    if (launchTimes == [launchString integerValue]) {
        
        [view removeFromSuperview];
        return nil;
    } else {
        
        launchString = [NSString stringWithFormat:@"%ld", [launchString integerValue] + 1];
        [[NSUserDefaults standardUserDefaults] setObject:launchString forKey:imageData];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return view;
}

#pragma mark - TouchAd
- (IBAction)touchAd:(UIButton *)sender {
    
    [self dismiss];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_adUrl]];
}

#pragma mark - Skip
- (IBAction)skip:(UIButton *)sender {
    
    [self dismiss];
}

#pragma mark - show / dismiss
- (void)show {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    [window makeKeyAndVisible];
    [window addSubview:self];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subTime) userInfo:nil repeats:YES];
}

- (void)dismiss {
    
    __weak SwsAdView *view = self;
    
    [UIView animateWithDuration:.5 animations:^{
        
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
    }];
}

#pragma mark - SubTime
- (void)subTime {
    
    _timeNum--;
    _timeLabel.text = [NSString stringWithFormat:@"跳过 %ld", _timeNum];
    
    if (0 == _timeNum) {
        
        [_timer invalidate];
        _timer = nil;
        [self dismiss];
    }
}

@end
