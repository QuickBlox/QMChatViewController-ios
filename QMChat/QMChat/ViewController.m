//
//  ViewController.m
//  QMChat
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "ViewController.h"
#import <Quickblox/Quickblox.h>
#import "QMBubbleImage.h"
#import "QMChatBubbleImageFactory.h"
#import "UIColor+QM.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) QMBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) QMBubbleImage *incomingBubbleImageData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.senderId = 1;
    self.senderDisplayName = @"hello";
    self.title = @"Chat";
    // Do any additional setup after loading the view, typically from a nib.
    
    
    QMChatBubbleImageFactory *bubbleFactory = [[QMChatBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor messageBubbleGreenColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    self.showLoadEarlierMessagesHeader = YES;
    
    self.array = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        QBChatMessage *msg = [QBChatMessage message];
        msg.ID = [NSString stringWithFormat:@"%tu", i];
        msg.senderID = i+1;
        msg.senderNick = [NSString stringWithFormat:@"user %tu", i];
        msg.datetime = [NSDate date];
        msg.text = @"Q-municate ☺️☺️☺️☺️☺️☺️ text cell has a `height` delegate method that corresponds to its text dataSource method";
        [self.array addObject:msg];
    }
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.collectionView.collectionViewLayout.springResistanceFactor = 1000;
//    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (UICollectionViewCell *)collectionView:(QMChatCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    QMChatCollectionViewCell *cell = (id)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    QBChatMessage *msg = self.array[indexPath.row];
    
    if (msg.senderID == self.senderId) {
        
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

#pragma mark - QBChatMessage CollectionView DataSource


- (NSAttributedString *)collectionView:(QMChatViewController *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    return [[NSAttributedString alloc] initWithString:@"Hello"];
}

- (NSAttributedString *)collectionView:(QMChatViewController *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *message = [self.array objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if (message.senderID == self.senderId) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        
        QBChatMessage *previousMessage = [self.array objectAtIndex:indexPath.item - 1];
        if (previousMessage.senderID == message.senderID) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderNick];
}

- (id<QMChatMessageData>)collectionView:(QMChatViewController *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.array[indexPath.row];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.array count];
}

- (id<QMChatBubbleImageDataSource>)collectionView:(QMChatCollectionView *)collectionView
         messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QBChatMessage *msg = self.array[indexPath.item];
    
    if (msg.senderID == 1) {
        
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}

- (id<QMChatAvatarImageDataSource>)collectionView:(QMChatCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView
                   layout:(QMChatCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
     QBChatMessage *msg = self.array[indexPath.row];
    if (msg.senderID == self.senderId ) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        QBChatMessage *previousMessage = [self.array objectAtIndex:indexPath.item - 1];
        if (previousMessage.senderID == msg.senderID) {
            return 0.0f;
        }
    }
    
    return kQMChatCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView
                   layout:(QMChatCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */

    return 20;
}

- (CGFloat)collectionView:(QMChatCollectionView *)collectionView
                   layout:(QMChatCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return kQMChatCollectionViewCellLabelHeightDefault;
}

- (NSAttributedString *)collectionView:(QMChatCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
   
    UIColor *color = [UIColor lightGrayColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    QBChatMessage *msg = self.array[indexPath.row];
    
    if (msg.senderID == self.senderId ) {
        paragraphStyle.alignment = NSTextAlignmentRight;
    }
    
    NSDictionary *dateTextAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0f],
                                          NSForegroundColorAttributeName : color,
                                          NSParagraphStyleAttributeName : paragraphStyle };
    
    return [[NSAttributedString alloc] initWithString:@"Hello" attributes:dateTextAttributes];
}


@end
