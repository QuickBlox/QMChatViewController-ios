//
//  QMChatCell.m
//  Q-municate
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMChatCell.h"
#import "QMChatCellLayoutAttributes.h"
#import "TTTAttributedLabel.h"

static NSMutableSet *_qmChatCellMenuActions = nil;

@interface QMChatCell()

@property (weak, nonatomic) IBOutlet QMChatContainerView *containerView;
@property (weak, nonatomic) IBOutlet UIView *messageContainer;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *textView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *topLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *bottomLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContainerTopInsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContainerLeftInsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContainerBottomInsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContainerRightInsetConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLableHeightConstraint;

@property (weak, nonatomic, readwrite) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation QMChatCell

#pragma mark - Class methods

+ (void)initialize {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _qmChatCellMenuActions = [NSMutableSet new];
    });
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier {
    
    return NSStringFromClass([self class]);
}

+ (void)registerMenuAction:(SEL)action {
    
    [_qmChatCellMenuActions addObject:NSStringFromSelector(action)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
#if Q_DEBUG_COLORS == 0
    self.backgroundColor = [UIColor clearColor];
    self.messageContainer.backgroundColor = [UIColor clearColor];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.bottomLabel.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
#endif
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
    self.tapGestureRecognizer = tap;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    return layoutAttributes;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [super applyLayoutAttributes:layoutAttributes];
    
    QMChatCellLayoutAttributes *customAttributes = (id)layoutAttributes;
    self.avatarContainerViewHeightConstraint.constant = customAttributes.avatarSize.height;
    self.avatarContainerViewWidthConstraint.constant = customAttributes.avatarSize.width;
    self.containerWidthConstraint.constant = customAttributes.containerSize.width;
    self.topLableHeightConstraint.constant = customAttributes.topLabelHeight;
    self.bottomLableHeightConstraint.constant = customAttributes.bottomLabelHeight;
    
    self.messageContainerTopInsetConstraint.constant = customAttributes.containerInsets.top;
    self.messageContainerLeftInsetConstraint.constant = customAttributes.containerInsets.left;
    self.messageContainerBottomInsetConstraint.constant = customAttributes.containerInsets.bottom;
    self.messageContainerRightInsetConstraint.constant = customAttributes.containerInsets.right;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        self.contentView.frame = bounds;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    self.containerView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    self.containerView.highlighted = selected;
}


#pragma mark - Menu actions

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([_qmChatCellMenuActions containsObject:NSStringFromSelector(aSelector)]) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([_qmChatCellMenuActions containsObject:NSStringFromSelector(anInvocation.selector)]) {
        
        id sender;
        [anInvocation getArgument:&sender atIndex:0];
        [self.delegate chatCell:self didPerformAction:anInvocation.selector withSender:sender];
    }
    else {
        
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if ([_qmChatCellMenuActions containsObject:NSStringFromSelector(aSelector)]) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

#pragma mark - Gesture recognizers

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    
//    CGPoint touchPt = [tap locationInView:self];
    
//    if (CGRectContainsPoint(self.avatarContainerView.frame, touchPt)) {
//        [self.delegate messagesCollectionViewCellDidTapAvatar:self];
//    }
//    else if (CGRectContainsPoint(self.containerView.frame, touchPt)) {
//        
//        [self.delegate messagesCollectionViewCellDidTapMessageBubble:self];
//    }
//    else {
//        [self.delegate messagesCollectionViewCellDidTapCell:self atPosition:touchPt];
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint touchPt = [touch locationInView:self];
    
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return CGRectContainsPoint(self.containerView.frame, touchPt);
    }
    
    return YES;
}

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel defaultLayoutModel = {

        .avatarSize = CGSizeMake(30, 30),
        .containerInsets = UIEdgeInsetsMake(4, 7, 4, 5),
        .containerSize = CGSizeZero,
        .topLabelHeight = 18,
        .bottomLabelHeight = 18
    };
    
    return defaultLayoutModel;
}

@end
