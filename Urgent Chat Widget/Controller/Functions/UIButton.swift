//
//  UIButton.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

extension UIButton {
    
    var isArabic : Bool {
        if NSLocale.autoupdatingCurrent.languageCode == K.arabicCode {
            return true
        }
        return false
    }
    
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height/6
    }
    
    func setDubaiFont() {
        if isArabic {
            self.titleLabel?.font = UIFont(name: K.Fonts.regular, size: 21)
        }
    }
    
    func applyDisableStyle() {
        let title = NSLocalizedString(K.copyPhoneNumber, comment: K.empty)
        
        self.isEnabled = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: K.Colors.red), for: .normal)
        if !isArabic {self.titleLabel?.font = self.titleLabel?.font.withSize(19)}
    }
    
    func applyPasteFromClipboardStyle() {
        let title = NSLocalizedString(K.pasteFromClipBoard, comment: K.empty)
        
        self.isEnabled = true
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: K.Colors.green), for: .normal)
    }
    
    func applyStartChatingStyle() {
        let title = NSLocalizedString(K.startChating, comment: K.empty)
        
        self.isEnabled = true
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: K.Colors.green), for: .normal)
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
