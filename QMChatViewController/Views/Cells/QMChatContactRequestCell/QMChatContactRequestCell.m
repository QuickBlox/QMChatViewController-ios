//
//  QMChatContactRequestCell.m
//  QMChatViewController
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatContactRequestCell.h"
#import "QMChatCellLayoutAttributes.h"

@interface QMChatContactRequestCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rejectButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *acceptButton;

@end

@implementation QMChatContactRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rejectButton.layer.cornerRadius = 4;
    self.rejectButton.clipsToBounds = YES;
    
    self.acceptButton.layer.cornerRadius = 4;
    self.acceptButton.clipsToBounds = YES;
}

#pragma mark - Actions

- (IBAction)pressRejectRequestBtn:(id)sender {
    
    [self.actionsHandler chatContactRequestDidAccept:NO sender:self];
}

- (IBAction)pressAcceptBtn:(id)sender {
    
    [self.actionsHandler chatContactRequestDidAccept:YES sender:self];
}

+ (QMChatCellLayoutModel)layoutModel {
    
    QMChatCellLayoutModel contactRequestModel = {
        .staticContainerSize = CGSizeMake(225, 130)
    };
    
    return contactRequestModel;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
}

@end
