//
//  QMChatContainerView.m
//  QMChatViewController
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatContainerView.h"

@interface QMChatContainerView()

@property (strong, nonatomic) UIImageView *preview;
@property (readwrite, strong, nonatomic) UIBezierPath *maskPath;

@end

@implementation QMChatContainerView

static NSMutableDictionary *_imaages = nil;

+ (void)initialize {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imaages = [NSMutableDictionary dictionary];
    });
}

+ (UIImage *)bubleImageWithArrowSize:(CGSize)arrowSize
                           fillColor:(UIColor *)fillColor
                        cornerRadius:(NSUInteger)cornerRadius
                           leftArrow:(BOOL)leftArrow {
    
    NSString *identifier = [NSString stringWithFormat:@"%@_%tu_%tu_%d",
                            NSStringFromCGSize(arrowSize),
                            fillColor.hash,
                            cornerRadius,
                            leftArrow];
    
    UIImage *img = _imaages[identifier];
    
    if (img) {
        
        for (UIImage *img in _imaages.allValues) {
            
        }
        return img;
    }
    
    CGSize size = CGSizeMake(20+cornerRadius, 20);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [fillColor setFill];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    BOOL arrow = arrowSize.width + arrowSize.height;
    
    UIBezierPath* rectanglePath = nil;
    if (!arrow) {
        
        rectanglePath =
        [UIBezierPath bezierPathWithRoundedRect:rect
                                   cornerRadius:cornerRadius];
    }
    else {
        
        CGFloat x = leftArrow ? arrowSize.width : CGRectGetMinX(rect);
        CGFloat y = CGRectGetMinY(rect);
        CGFloat w = CGRectGetWidth(rect);
        CGFloat h = CGRectGetHeight(rect);
        //// Subframes
        CGRect arrowRect = CGRectMake((leftArrow ?  0 : x + w - arrowSize.width),
                                      y + h - arrowSize.height,
                                      arrowSize.width, arrowSize.height);
        //// Rectangle Drawing
        rectanglePath =
        [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w - arrowSize.width, h)
                              byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | (leftArrow ? UIRectCornerBottomRight : UIRectCornerBottomLeft)
                                    cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        [rectanglePath moveToPoint:CGPointMake(CGRectGetMaxX(arrowRect) + arrowSize.width,
                                               CGRectGetMaxY(arrowRect))];
        
        [rectanglePath addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect),
                                                  CGRectGetMaxY(arrowRect))];
        [rectanglePath addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect) - (leftArrow ?  0 : arrowSize.width),
                                                  CGRectGetMaxY(arrowRect) - arrowSize.height)];
        [rectanglePath addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect) - arrowSize.width,
                                                  CGRectGetMaxY(arrowRect))];
    }
    
    [rectanglePath fill];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    img = [img stretchableImageWithLeftCapWidth:arrowSize.width + cornerRadius
                                   topCapHeight:cornerRadius*2];
    UIGraphicsEndImageContext();
    
    _imaages[identifier] = img;
    
    return img;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _preview =
    [[UIImageView alloc] initWithFrame:self.bounds];
    _preview.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *bubleImg =
    [QMChatContainerView bubleImageWithArrowSize:self.arrowSize
                                       fillColor:self.bgColor
                                    cornerRadius:self.cornerRadius
                                       leftArrow:self.leftArrow];
    
    _preview.image = bubleImg;
    
    _preview.highlightedImage = bubleImg;
    
    [self insertSubview:_preview atIndex:0];
}

- (UIImage *)backgroundImage {
    return _preview.image;
}

- (void)setBgColor:(UIColor *)bgColor {
    
    if (![_bgColor isEqual:bgColor]) {
        
        //awakefromnib
        if (_bgColor) {
            
            UIImage *bubleImg =
            [QMChatContainerView bubleImageWithArrowSize:self.arrowSize
                                               fillColor:bgColor
                                            cornerRadius:self.cornerRadius
                                               leftArrow:self.leftArrow];
            _preview.image = bubleImg;
        }
        
        _bgColor = bgColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        
        _preview.alpha = highlighted ? 0.6 : 1;
    }
}

@end
