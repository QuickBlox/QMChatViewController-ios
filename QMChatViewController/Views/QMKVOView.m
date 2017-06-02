//
//  QMKVOView.m
//
//
//  Created by Vitaliy Gurkovsky on 10/12/16.
//
//

#import "QMKVOView.h"

static void * kQMFrameKeyValueObservingContext = &kQMFrameKeyValueObservingContext;

@interface QMKVOView()

@property (assign, nonatomic, getter=isObserverAdded) BOOL observerAdded;
@property (assign, nonatomic) NSInteger previosPos;
@end

@implementation QMKVOView

#pragma mark - Life cycle
- (void)dealloc {
    //ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

#pragma mark - Actions
- (void)setPos:(NSUInteger )pos {
    
//    if (_previosPos == pos || (self.superview.window.frame.size.height - pos) <= 44) {
//        return;
//    }
//    _previosPos = pos;
//    
    CGRect frame = self.superview.frame;
    frame.origin.y = pos;
    self.superview.frame = frame;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    
    _collectionView = collectionView;
    
    [_collectionView.panGestureRecognizer addTarget:self
                                             action:@selector(handlePanGestureRecognizer:)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (self.isObserverAdded) {
        
        if (self.hostViewFrameChangeBlock) {
            self.hostViewFrameChangeBlock(newSuperview, NO);
        }
        
        [self.superview removeObserver:self
                            forKeyPath:@"center"
                               context:kQMFrameKeyValueObservingContext];
    }
    
    [newSuperview addObserver:self
                   forKeyPath:@"center"
                      options:NSKeyValueObservingOptionNew
                      context:kQMFrameKeyValueObservingContext];
    
    self.observerAdded = YES;
    
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"center"] ) {
        
        if (self.hostViewFrameChangeBlock) {
            self.hostViewFrameChangeBlock(self.superview, _collectionView.panGestureRecognizer.state != UIGestureRecognizerStateChanged);
        }
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    
    if (self.superview == nil) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint panPoint = [gesture locationInView:self.window];
        CGRect hostViewRect = [self.window convertRect:self.superview.frame
                                                               toView:nil];
        CGFloat toolbarMinY =
        CGRectGetMinY(hostViewRect) - CGRectGetHeight(self.inputView.frame);
        
        if (panPoint.y >= toolbarMinY) {
            [self setPos:(int)panPoint.y];
        }
    }
}

@end
