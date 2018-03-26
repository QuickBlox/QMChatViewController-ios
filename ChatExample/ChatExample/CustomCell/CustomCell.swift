//
//  CustomCell.swift
//  ChatExample
//
//  Created by Andrey Ivanov on 23/03/2018.
//  Copyright © 2018 Andrey Ivanov. All rights reserved.
//

import UIKit
import QMChatViewController.QMChatCell

class CustomCell: QMChatCell {
    
    static override func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static override func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    static override func layoutModel() -> QMChatCellLayoutModel {
        var model = super.layoutModel()
        model.avatarSize = .zero
        model.containerInsets = UIEdgeInsetsMake(8, 10, 8, 18)
        model.topLabelHeight = 0
        model.spaceBetweenTextViewAndBottomLabel = 0
        model.bottomLabelHeight = 14
        return model;
    }
}
