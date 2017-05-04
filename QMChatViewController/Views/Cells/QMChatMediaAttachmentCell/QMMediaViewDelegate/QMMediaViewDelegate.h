//
//  QMMediaViewDelegate.h
//  QMPLayer
//
//  Created by Vitaliy Gurkovsky on 1/30/17.
//  Copyright © 2017 quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QMMediaPresenter;

@protocol QMMediaViewDelegate <NSObject>

@required

- (void)setupInitialState;
- (void)setOnLayoutUpdate;

@property (strong, nonatomic) QMMediaPresenter *presenter;

@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isActive;

@optional

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat progress;


- (void)setImage:(UIImage *)image;
- (void)showLoadingError:(NSError *)error;
- (void)showUploadingError:(NSError *)error;

@end
