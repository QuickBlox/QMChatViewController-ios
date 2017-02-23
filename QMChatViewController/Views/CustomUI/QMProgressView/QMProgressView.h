//
//  QMProgressView.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 2/20/17.
//
//

#import <UIKit/UIKit.h>

@interface QMProgressView : UIView

@property (nonatomic, assign, readonly) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
