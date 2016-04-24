//
//  DemoChatViewController.m
//  QMChatViewControllerExample
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "DemoChatViewController.h"
#import <Quickblox/Quickblox.h>
#import "UIColor+QM.h"
#import "UIImage+QM.h"
#import "UIImage+fixOrientation.h"
#import "STKStickerPipe.h"
#import "STKStickersPurchaseService.h"

NS_ENUM(NSUInteger, QMMessageType) {
    
    QMMessageTypeText = 0,
    QMMessageTypeCreateGroupDialog = 1,
    QMMessageTypeUpdateGroupDialog = 2,
    
    QMMessageTypeContactRequest = 4,
    QMMessageTypeAcceptContactRequest,
    QMMessageTypeRejectContactRequest,
    QMMessageTypeDeleteContactRequest
};

@interface DemoChatViewController() <STKStickerControllerDelegate> {
    NSString *packName;
    NSString *packPrice;
}

@end

@implementation DemoChatViewController

- (NSTimeInterval)timeIntervalBetweenSections {
    return 300.0f;
}

- (CGFloat)heightForSectionHeader {
    return 40.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.senderID = 2000;
    self.senderDisplayName = @"hello";
    self.title = @"Chat";
    
    // Create test data source
    //
    QBChatMessage *message1 = [QBChatMessage message];
    message1.senderID = QMMessageTypeContactRequest;
    message1.senderNick = @"Andrey M. ";
    message1.text = @"Andrey M.\nwould like to chat with you";
    message1.dateSent = [NSDate dateWithTimeInterval:-12.0f sinceDate:[NSDate date]];
    //
    //
    QBChatMessage *message2 = [QBChatMessage message];
    message2.senderID = self.senderID;
    message2.senderNick = @"Andrey I.";
    message2.text = @"Why Q-municate is a right choice?";
    message2.dateSent = [NSDate dateWithTimeInterval:-9.0f sinceDate:[NSDate date]];
    //
    //
    QBChatMessage *message3 = [QBChatMessage message];
    message3.senderID = 20001;
    message3.senderNick = @"Andrey M.";
    message3.text = @"Q-municate comes with powerful instant messaging right out of the box. Powered by the flexible XMPP protocol and Quickblox signalling technologies, with compatibility for server-side chat history, group chats, attachments and user avatars, it's pretty powerful. It also has chat bubbles and user presence (online/offline).";
    message3.dateSent = [NSDate dateWithTimeInterval:-6.0f sinceDate:[NSDate date]];
    //
    //
    // message with an attachment
    //
    QBChatMessage *message4 = [QBChatMessage message];
    message4.ID = @"4";
    message4.senderID = 20001;
    message4.senderNick = @"Andrey M.";
    QBChatAttachment *attachment = [QBChatAttachment new];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"quickblox-image" ofType:@"png"];
    attachment.url = imagePath;
    message4.attachments = @[attachment];
    message4.dateSent = [NSDate dateWithTimeInterval:-3.0f sinceDate:[NSDate date]];
    
    //    QBChatMessage *message5 = [QBChatMessage message];
    //    message5.senderID = 20001;
    //    message5.senderNick = @"Andrey M.";
    //    message5.text = @"🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭";
    //
    //    message5.dateSent = [NSDate dateWithTimeInterval:15.0f sinceDate:[NSDate date]];
    
    [self.chatSectionManager addMessages:@[message1, message2, message3, message4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.stickerController updateFrames];

}

#pragma mark Tool bar Actions

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    QBChatMessage *message = [QBChatMessage message];
    message.text = text;
    message.senderID = senderId;
    message.dateSent = [NSDate date];
    
    [self.chatSectionManager addMessage:message];
    
    [self finishSendingMessageAnimated:YES];

    [self.stickerController textMessageSent:text];
}

- (void)didPickAttachmentImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *resizedImage = [self resizedImageFromImage:[image fixOrientation]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        NSData *binaryImageData = UIImagePNGRepresentation(resizedImage);
        NSString *imageName = [NSString stringWithFormat:@"%f-attachment.png", [[NSDate date] timeIntervalSince1970]];
        NSString *imagePath = [basePath stringByAppendingPathComponent:imageName];
        
        [binaryImageData writeToFile:imagePath atomically:YES];
        
        QBChatMessage* message = [QBChatMessage new];
        message.senderID = self.senderID;
        
        QBChatAttachment *attacment = [[QBChatAttachment alloc] init];
        attacment.url = imagePath;
        
        message.attachments = @[attacment];
        
        [self.chatSectionManager addMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self finishSendingMessageAnimated:YES];
        });
    });
}


- (Class)viewClassForItem:(QBChatMessage *)item {
    
    if (item.senderID == QMMessageTypeContactRequest) {
        
        if (item.senderID != self.senderID) {
            
            return [QMChatContactRequestCell class];
        }
    }
    
    else if (item.senderID == QMMessageTypeRejectContactRequest) {
        
        return [QMChatNotificationCell class];
    }
    
    else if (item.senderID == QMMessageTypeAcceptContactRequest) {
        
        return [QMChatNotificationCell class];
    }
    else {
        
        if (item.senderID != self.senderID) {
            if ([STKStickersManager isStickerMessage:item.text]) {
                return [QMChatIncomingStickerCell class];
            } else if ((item.attachments != nil && item.attachments.count > 0)) {
                return [QMChatAttachmentIncomingCell class];
            } else {
                return [QMChatIncomingCell class];
            }
        } else  if ([STKStickersManager isStickerMessage:item.text]) {
            return [QMChatOutgoingStickerCell class];
        } else if ((item.attachments != nil && item.attachments.count > 0)) {
            return [QMChatAttachmentOutgoingCell class];
        } else {
            return [QMChatOutgoingCell class];
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(QMChatCollectionView *)collectionView dynamicSizeAtIndexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class viewClass = [self viewClassForItem:item];
    CGSize size;
    
    if (viewClass == [QMChatAttachmentIncomingCell class] || viewClass == [QMChatAttachmentOutgoingCell class]) {
        size = CGSizeMake(MIN(200, maxWidth), 200);
    } else if (viewClass == [QMChatOutgoingStickerCell class] ||
               viewClass == [QMChatIncomingStickerCell class]) {
        NSAttributedString *attributedString = [self bottomLabelAttributedStringForItem:item];
        
        CGSize bottomLabelSize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                                  withConstraints:CGSizeMake(MIN(200, maxWidth), CGFLOAT_MAX)
                                                           limitedToNumberOfLines:0];
        size = CGSizeMake(MIN(160, maxWidth), 160 + ceilf(bottomLabelSize.height));
    }
    
    
    else {
        NSAttributedString *attributedString = [self attributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(maxWidth, MAXFLOAT)
                                         limitedToNumberOfLines:0];
    }
    
    return size;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView minWidthAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    
    CGSize size;
    
    if (item != nil) {
        
        NSAttributedString *attributedString =
        [item senderID] == self.senderID ?  [self bottomLabelAttributedStringForItem:item] : [self topLabelAttributedStringForItem:item];
        
        size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                withConstraints:CGSizeMake(1000, 10000)
                                         limitedToNumberOfLines:1];
    }
    
    return size.width;
}

- (void)collectionView:(QMChatCollectionView *)collectionView configureCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
    QBChatMessage* message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    if ([cell conformsToProtocol:@protocol(QMChatAttachmentCell)]) {
        
        if (message.attachments != nil) {
            QBChatAttachment* attachment = message.attachments.firstObject;
            NSData *imageData = [NSData dataWithContentsOfFile:attachment.url];
            [(UICollectionViewCell<QMChatAttachmentCell> *)cell setAttachmentImage:[UIImage imageWithData:imageData]];
            
            [cell updateConstraints];
        }
    } else {
        Class viewClass = [self viewClassForItem:message];
        if (viewClass == [QMChatOutgoingStickerCell class]) {
            [[(QMChatOutgoingStickerCell *)cell stickerImage] stk_setStickerWithMessage:message.text placeholder:nil placeholderColor:nil progress:nil completion:nil];
        }
        else if (viewClass == [QMChatIncomingStickerCell class]) {
            [[(QMChatIncomingStickerCell *)cell stickerImage] stk_setStickerWithMessage:message.text placeholder:nil placeholderColor:nil progress:nil completion:nil];
        }
    }
    
    
    [super collectionView:collectionView configureCell:cell forIndexPath:indexPath];
}

- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView *)collectionView layoutModelAtIndexPath:(NSIndexPath *)indexPath {
    
    QMChatCellLayoutModel layoutModel = [super collectionView:collectionView layoutModelAtIndexPath:indexPath];
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    
    layoutModel.avatarSize = CGSizeMake(0.0f, 0.0f);
    
    if (item!= nil) {
        
        NSAttributedString *topLabelString = [self topLabelAttributedStringForItem:item];
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:topLabelString
                                                       withConstraints:CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGFLOAT_MAX)
                                                limitedToNumberOfLines:1];
        layoutModel.topLabelHeight = size.height;
    }
    
    return layoutModel;
}

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor = [messageItem senderID] == self.senderID ? [UIColor whiteColor] : [UIColor colorWithWhite:0.290 alpha:1.000];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : textColor,
                                 NSFontAttributeName : font};
    
    NSMutableAttributedString *attrStr;
    
    if ([messageItem.text length] > 0) {
        
        attrStr = [[NSMutableAttributedString alloc] initWithString:messageItem.text attributes:attributes];
    }
    
    return attrStr;
}

- (NSAttributedString *)topLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    
    if ([messageItem senderID] == self.senderID) {
        return nil;
    }
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:[UIColor colorWithRed:0.184 green:0.467 blue:0.733 alpha:1.000], NSFontAttributeName:font};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:messageItem.senderNick attributes:attributes];
    
    return attrStr;
}

- (NSAttributedString *)bottomLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor = [messageItem senderID] == self.senderID ? [UIColor colorWithWhite:1.000 alpha:0.510] : [UIColor colorWithWhite:0.000 alpha:0.490];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor, NSFontAttributeName:font};
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithString:[self timeStampWithDate:messageItem.dateSent]
                                           attributes:attributes];
    
    return attrStr;
}

- (NSString *)timeStampWithDate:(NSDate *)date {
    
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
    });
    
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    
    return timeStamp;
}

- (UIImage *)resizedImageFromImage:(UIImage *)image
{
    CGFloat largestSide = image.size.width > image.size.height ? image.size.width : image.size.height;
    CGFloat scaleCoefficient = largestSide / 560.0f;
    CGSize newSize = CGSizeMake(image.size.width / scaleCoefficient, image.size.height / scaleCoefficient);
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:(CGRect){0, 0, newSize.width, newSize.height}];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

#pragma mark - STKSTickerController delegate

- (UIViewController *)stickerControllerViewControllerForPresentingModalView {
    return self;
}

- (void)stickerController:(STKStickerController *)stickerController didSelectStickerWithMessage:(NSString *)message {
    
    QBChatMessage* stickerMessage = [QBChatMessage new];
    stickerMessage.senderID = self.senderID;
    stickerMessage.dateSent = [NSDate date];
    stickerMessage.text = message;
    
    [self.chatSectionManager addMessage:stickerMessage];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)purchasePack:(NSNotification *)notification {
    
    packName = notification.userInfo[@"packName"];
    packPrice = notification.userInfo[@"packPrice"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Purchase this stickers pack?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [alertView show];
    });
}

#pragma mark - Alert controller delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [[STKStickersPurchaseService sharedInstance] purchaseFailedError:nil];
            break;
        case 1:[[STKStickersPurchaseService sharedInstance] purchasInternalPackName:packName andPackPrice:packPrice];
            
        default:
            break;
    }
    
}

@end
