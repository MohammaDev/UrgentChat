//
//  RoundedButton.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 19/02/2021.
//  Copyright © 2021 Mohammad Alotaibi. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    var isPressed: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 0.75
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
    }
}
