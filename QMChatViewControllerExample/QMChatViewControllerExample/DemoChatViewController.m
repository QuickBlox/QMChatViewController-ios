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

NS_ENUM(NSUInteger, QMMessageType) {

    QMMessageTypeText = 0,
    QMMessageTypeCreateGroupDialog = 1,
    QMMessageTypeUpdateGroupDialog = 2,
    
    QMMessageTypeContactRequest = 4,
    QMMessageTypeAcceptContactRequest,
    QMMessageTypeRejectContactRequest,
    QMMessageTypeDeleteContactRequest
};

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
    
//    // Create test data source
//    //
//    QBChatMessage *message1 = [QBChatMessage message];
//    message1.senderID = QMMessageTypeContactRequest;
//    message1.senderNick = @"Andrey M. ";
//    message1.text = @"Andrey M.\nwould like to chat with you";
//    message1.dateSent = [NSDate dateWithTimeInterval:3.0f sinceDate:[NSDate date]];
//    //
//    //
//    QBChatMessage *message2 = [QBChatMessage message];
//    message2.senderID = self.senderID;
//    message2.senderNick = @"Andrey I.";
//    message2.text = @"Why Q-municate is a right choice?";
//    message2.dateSent = [NSDate dateWithTimeInterval:6.0f sinceDate:[NSDate date]];
//    //
//    //
//    QBChatMessage *message3 = [QBChatMessage message];
//    message3.senderID = 20001;
//    message3.senderNick = @"Andrey M.";
//    message3.text = @"Q-municate comes with powerful instant messaging right out of the box. Powered by the flexible XMPP protocol and Quickblox signalling technologies, with compatibility for server-side chat history, group chats, attachments and user avatars, it's pretty powerful. It also has chat bubbles and user presence (online/offline).";
//    message3.dateSent = [NSDate dateWithTimeInterval:9.0f sinceDate:[NSDate date]];
//    //
//    //
//    // message with an attachment
//    //
//    QBChatMessage *message4 = [QBChatMessage message];
//    message4.ID = @"4";
//    message4.senderID = 20001;
//    message4.senderNick = @"Andrey M.";
//    QBChatAttachment *attachment = [QBChatAttachment new];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"quickblox-image" ofType:@"png"];
//    attachment.url = imagePath;
//    message4.attachments = @[attachment];
//    message4.dateSent = [NSDate dateWithTimeInterval:12.0f sinceDate:[NSDate date]];
    
    QBChatMessage *message1 = [QBChatMessage message];
    message1.senderID = 20001;
    message1.senderNick = @"Message 1";
    message1.text = @"Message 1";
    message1.dateSent = [NSDate dateWithTimeIntervalSince1970:5555555555];
    
    QBChatMessage *message11 = [QBChatMessage message];
    message11.senderID = 20001;
    message11.senderNick = @"Message 1-1";
    message11.text = @"Message 1-1";
    message11.dateSent = [NSDate dateWithTimeIntervalSince1970:5555555556];
    
    QBChatMessage *message12 = [QBChatMessage message];
    message12.senderID = 20001;
    message12.senderNick = @"Message 1-2";
    message12.text = @"Message 1-2";
    message12.dateSent = [NSDate dateWithTimeIntervalSince1970:5555555557];
    
    QBChatMessage *message2 = [QBChatMessage message];
    message2.senderID = 2000;
    message2.senderNick = @"Message 4";
    message2.text = @"Message 4";
    message2.dateSent = [NSDate dateWithTimeIntervalSince1970:9999999999];
    
    QBChatMessage *message3 = [QBChatMessage message];
    message3.senderID = 2000;
    message3.senderNick = @"Message 3";
    message3.text = @"Message 3";
    message3.dateSent = [NSDate dateWithTimeIntervalSince1970:7777777777];
    
    QBChatMessage *message4 = [QBChatMessage message];
    message4.senderID = 20001;
    message4.senderNick = @"Message 2";
    message4.text = @"Message 2";
    message4.dateSent = [NSDate dateWithTimeIntervalSince1970:6666666666];
    
//    QBChatMessage *message5 = [QBChatMessage message];
//    message5.senderID = 20001;
//    message5.senderNick = @"Andrey M.";
//    message5.text = @"🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭🐭";
//    
//    message5.dateSent = [NSDate dateWithTimeInterval:15.0f sinceDate:[NSDate date]];
    
//    [self updateDataSourceWithMessages:@[message1, message2, message3, message4]];
    [self.chatSectionManager addMessages:@[message1, message2, message3, message12, message4, message11]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - QMChatCellDelegate

- (void)chatCellDidTapContainer:(QMChatCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    [self.chatSectionManager deleteMessage:message];
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
            if ((item.attachments != nil && item.attachments.count > 0)) {
                return [QMChatAttachmentIncomingCell class];
            } else {
                return [QMChatIncomingCell class];
            }
        } else {
            if ((item.attachments != nil && item.attachments.count > 0)) {
                return [QMChatAttachmentOutgoingCell class];
            } else {
                return [QMChatOutgoingCell class];
            }
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
    } else {
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
    [(QMChatCell *)cell setDelegate:self];
    
    if ([cell conformsToProtocol:@protocol(QMChatAttachmentCell)]) {
        QBChatMessage* message = [self.chatSectionManager messageForIndexPath:indexPath];
        
        if (message.attachments != nil) {
            QBChatAttachment* attachment = message.attachments.firstObject;
            NSData *imageData = [NSData dataWithContentsOfFile:attachment.url];
            [(UICollectionViewCell<QMChatAttachmentCell> *)cell setAttachmentImage:[UIImage imageWithData:imageData]];
            
            [cell updateConstraints];
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

@end
