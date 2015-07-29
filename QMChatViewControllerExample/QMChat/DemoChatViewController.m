//
//  DemoChatViewController.m
//  QMChat
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "DemoChatViewController.h"
#import <Quickblox/Quickblox.h>
#import "UIColor+QM.h"
#import "UIImage+QM.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    
    self.senderID = 2000;
    self.senderDisplayName = @"hello";
    self.title = @"Chat";
    // Do any additional setup after loading the view, typically from a nib.
    self.showLoadEarlierMessagesHeader = YES;
    //Customize your toolbar buttons
    self.inputToolbar.contentView.leftBarButtonItem = [self accessoryButtonItem];
    self.inputToolbar.contentView.rightBarButtonItem = [self sendButtonItem];
    
    // Create test data source
    QBChatMessage *msg = [QBChatMessage message];
    msg.ID = @"1";
    msg.senderID = QMMessageTypeContactRequest;
    msg.senderNick = @"Andrey M. ";
    msg.text = @"Andrey M.\nwould like to chat with you";
    msg.dateSent = [NSDate date];
    [self.items addObject:msg];

    QBChatMessage *msg2 = [QBChatMessage message];
    msg2.ID = @"2";
    msg2.senderID = 2000;
    msg2.senderNick = @"Andrey I.";
    msg2.text = @"Why Q-municate is a right choice?";
    msg2.dateSent = [NSDate date];
    [self.items addObject:msg2];

    QBChatMessage *msg3 = [QBChatMessage message];
    msg3.ID = @"3";
    msg3.senderID = 20001;
    msg3.senderNick = @"Andrey M.";
    msg3.text = @"Q-municate comes with powerful instant messaging right out of the box. Powered by the flexible XMPP protocol and Quickblox signalling technologies, with compatibility for server-side chat history, group chats, attachments and user avatars, it's pretty powerful. It also has chat bubbles and user presence (online/offline).";
    msg3.dateSent = [NSDate date];
    [self.items addObject:msg3];
    
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.collectionView.collectionViewLayout.springResistanceFactor = 1000;
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

#pragma mark - Tool bar

- (UIButton *)accessoryButtonItem {
    
    UIImage *accessoryImage = [UIImage imageNamed:@"attachmentBtn"];
    UIImage *normalImage = [accessoryImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [accessoryImage imageMaskedWithColor:[UIColor darkGrayColor]];
    
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 32.0f)];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    accessoryButton.backgroundColor = [UIColor clearColor];
    accessoryButton.tintColor = [UIColor lightGrayColor];
    
    return accessoryButton;
}

- (UIButton *)sendButtonItem {
    
    NSString *sendTitle = NSLocalizedString(@"Send", nil);
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[[UIColor blueColor] colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    sendButton.titleLabel.minimumScaleFactor = 0.85f;
    sendButton.contentMode = UIViewContentModeCenter;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.tintColor = [UIColor blueColor];
    
    CGFloat maxHeight = 32.0f;
    
    CGRect sendTitleRect = [sendTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{ NSFontAttributeName : sendButton.titleLabel.font }
                                                   context:nil];
    
    sendButton.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(CGRectIntegral(sendTitleRect)), maxHeight);
    
    return sendButton;
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
    
    QBChatAttachment *attacment = [[QBChatAttachment alloc] init];
    message.attachments = @[attacment];
    
    [self.items addObject:message];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    
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
            
            return [QMChatIncomingCell class];
        }
        else {
            
            return [QMChatOutgoingCell class];
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(QMChatCollectionView *)collectionView dynamicSizeAtIndexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth {
    
    QBChatMessage *item = self.items[indexPath.item];
    
    NSAttributedString *attributedString = [self attributedStringForItem:item];
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                   withConstraints:CGSizeMake(maxWidth, MAXFLOAT)
                                            limitedToNumberOfLines:0];
    return size;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView minWidthAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = self.items[indexPath.item];
    
    NSAttributedString *attributedString =
    [item senderID] == self.senderID ?  [self bottomLabelAttributedStringForItem:item] : [self topLabelAttributedStringForItem:item];
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                   withConstraints:CGSizeMake(1000, 10000)
                                            limitedToNumberOfLines:1];
    
    return size.width;
}

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    
    UIColor *textColor = [messageItem senderID] == self.senderID ? [UIColor whiteColor] : [UIColor colorWithWhite:0.290 alpha:1.000];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:textColor, NSFontAttributeName:font};

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:messageItem.text attributes:attributes];
    
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

@end
