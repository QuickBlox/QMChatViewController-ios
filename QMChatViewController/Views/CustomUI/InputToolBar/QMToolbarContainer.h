//
//  QMToolbarContainer.h
//  Pods
//
//  Created by Vitaliy Gurkovsky on 3/9/17.
//
//

#import <UIKit/UIKit.h>

@interface QMToolbarContainer : UIToolbar

- (void)addButton:(UIButton *)button
           action:(nullable void(^)(UIButton *sender))action;

@end
