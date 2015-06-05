//
//  QMChatContainerView.m
//  Q-municate
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMChatContainerView.h"

@implementation QMChatContainerView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    
    [self drawWithRect:rect bgColor:self.bgColor cornerRadius:self.cornerRadius];
}

- (void)drawWithRect:(CGRect)rect bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius {
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [bgColor setFill];
    [rectanglePath fill];
}

- (void)setHighlighted:(BOOL)highlighted {
    
    if (_highlighted != highlighted) {
        
        _highlighted = highlighted;
        
        [self setNeedsDisplay];
        
    }
}

@end
