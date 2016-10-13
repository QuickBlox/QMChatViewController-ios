//
//  QMKVOView.m
//  Pods
//
//  Created by Vitaliy Gurkovsky on 10/12/16.
//
//

#import "QMKVOView.h"
static void * kQMInputToolbarKeyValueObservingContext = &kQMInputToolbarKeyValueObservingContext;
@interface QMKVOView()

@property (assign, nonatomic) BOOL isObserving;
@property (nonatomic, assign, getter=isObserverAdded) BOOL observerAdded;

@end
@implementation QMKVOView

#pragma mark - Actions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    
    if (self.isObserverAdded) {
        
        [self.superview removeObserver:self
                            forKeyPath:@"frame"
                               context:kQMInputToolbarKeyValueObservingContext];
        [self.superview removeObserver:self
                            forKeyPath:@"center"
                               context:kQMInputToolbarKeyValueObservingContext];
    }
    
    [newSuperview addObserver:self
                   forKeyPath:@"frame"
                      options:0
                      context:kQMInputToolbarKeyValueObservingContext];
    
    [newSuperview addObserver:self
                   forKeyPath:@"center"
                      options:0
                      context:kQMInputToolbarKeyValueObservingContext];
    
    self.observerAdded = YES;
    
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Key-value observing
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.frameChangedBlock) {
        CGRect frame = self.superview.frame;
        self.frameChangedBlock(frame);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.superview && ([keyPath isEqualToString:@"frame"] ||
                                     [keyPath isEqualToString:@"center"])) {
        
        if  (self.frameChangedBlock) {
            CGRect frame = self.superview.frame;
            self.frameChangedBlock(frame);
        }
    }
    
}

@end
