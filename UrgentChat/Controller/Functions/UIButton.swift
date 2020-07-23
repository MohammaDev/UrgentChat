//
//  UIButton.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setAccessibility(Enable bool : Bool, Alpha alpha : CGFloat) {
        self.isEnabled = bool
        self.alpha = alpha
    }
    
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height/6
    }
    
    func applyDisableStyle() {
        let title = NSLocalizedString(K.enterPhoneNumber, comment: K.empty)
        self.setTitle(title, for: .normal)
        self.setAccessibility(Enable: false, Alpha: 0.55)
        
    }
    
    func applyPasteFromClipboardStyle() {
        let title = NSLocalizedString(K.pasteFromClipBoard, comment: K.empty)
        self.setTitle(title, for: .normal)
        self.setAccessibility(Enable: true, Alpha: 1)
    }
    
    func applyStartChatingStyle() {
        let title = NSLocalizedString(K.startChating, comment: K.empty)
        self.setTitle(title, for: .normal)
        self.setAccessibility(Enable: true, Alpha: 1)
    }
    
    func setPadding(to padding : CGFloat) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(self)
        
        outerView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width:  self.frame.size.width  + padding,
                height: self.frame.size.height + padding
            )
        )
        
        self.center = CGPoint(
            x: outerView.bounds.size.width  / 2,
            y: outerView.bounds.size.height / 2
        )
        
        return outerView
    }
}
