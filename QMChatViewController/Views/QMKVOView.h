//
//  QMKVOView.h
//  
//
//  Created by Vitaliy Gurkovsky on 10/12/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMKVOView : UIView

@property (nonatomic, copy, nullable) void (^hostViewFrameChangeBlock)(UIView *view);

@end
NS_ASSUME_NONNULL_END
