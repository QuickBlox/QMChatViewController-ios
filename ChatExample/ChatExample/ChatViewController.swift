//
//  ViewController.swift
//  ChatExample
//
//  Created by Andrey Ivanov on 23/03/2018.
//  Copyright © 2018 Andrey Ivanov. All rights reserved.
//

import UIKit
import QMChatViewController

class ChatViewController: QMChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderID = 1300340;
        self.senderDisplayName = "Sender name"
        self.view.backgroundColor = UIColor.white
        
        self.inputToolbar?.audioRecordingEnabled = false
        
        let msg = QBChatMessage()
        msg.text = "QuickBlox - Communication & cloud backend platform which brings superpowers to your mobile apps. QuickBlox is a suite of communication features & data services (APIs, SDKs, code samples, admin panel, tutorials) which help digital agencies, mobile developers and publishers to add great functionality to smartphone applications. Please read full iOS SDK documentation on the"
        msg.senderID = self.senderID
        msg.dateSent = Date()
        self.chatDataSource.add(msg)
        
        let msg2 = QBChatMessage()
        msg2.text = "QuickBlox"
        msg2.senderID = self.senderID
        msg2.dateSent = Date()
        
        self.chatDataSource.add(msg2)
        CustomCell.registerForReuse(inView: self.collectionView)
    }
    
    override func didPressSend(_ button: UIButton,
                               withMessageText text: String,
                               senderId: UInt,
                               senderDisplayName: String,
                               date: Date) {
    
        let msg = QBChatMessage()
        msg.text = text
        msg.senderID = senderId
        msg.dateSent = Date()
        self.chatDataSource.add(msg)
        self.finishSendingMessage(animated: true)
    }
    
    override func viewClass(forItem item: QBChatMessage) -> AnyClass {
        
        if item.isDateDividerMessage {
            return QMChatNotificationCell.self
        }
        else {
            return CustomCell.self
        }
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, dynamicSizeAt indexPath: IndexPath!, maxWidth: CGFloat) -> CGSize {
        
        let size = TTTAttributedLabel.sizeThatFitsAttributedString(self.attributedString(forItem: self.chatDataSource.message(for: indexPath)),
                                                                   withConstraints: CGSize(width:maxWidth, height:1000),
                                                                   limitedToNumberOfLines: 0)
        return size
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, minWidthAt indexPath: IndexPath!) -> CGFloat {
        
        let msg = self.chatDataSource.message(for: indexPath)
        let viewClass: AnyClass = self.viewClass(forItem: msg!)
        if viewClass == QMChatNotificationCell.self {
            return 60
        }
        return TTTAttributedLabel.sizeThatFitsAttributedString(self.attributedString(forItem: msg!),
                                                               withConstraints: CGSize(width:100, height:1000),
                                                               limitedToNumberOfLines: 0).width
    }
    
    override func topLabelAttributedString(forItem messageItem: QBChatMessage) -> NSAttributedString? {
        return nil
    }
    
    override func attributedString(forItem messageItem: QBChatMessage) -> NSAttributedString? {
        return NSAttributedString(string: messageItem.text!)
    }
    
    override func bottomLabelAttributedString(forItem messageItem: QBChatMessage) -> NSAttributedString? {
        return NSAttributedString(string: "sent")
    }
}
