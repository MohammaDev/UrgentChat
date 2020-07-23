//
//  FPNTextField.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import FlagPhoneNumber

extension FPNTextField {
    
    var isArabic : Bool {
        if NSLocale.autoupdatingCurrent.languageCode == K.arabicCode {
            return true
        }
        return false
    }
    
    func setFlagSize() {
        flagButtonSize = CGSize(width: 40, height: 32)
    }

    func ForceAlignmentToLeft() {
        if isArabic {
            semanticContentAttribute           = .forceLeftToRight
            leftView?.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func clearPlaceholder() {
        hasPhoneNumberExample = false
        placeholder = K.empty
    }
    
    func EditClearButtonAppearence() {
        (text == K.empty) ? (rightViewMode = .never) : (rightViewMode = .whileEditing)
    }
    
    func setClearButton() {
        let image = UIImage(named: K.Image.clearButton)!
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        rightView = clearButton.setPadding(to: 15)
    }
    
    @objc func clear(_ sender : AnyObject) {
        text = K.empty
        (delegate as? FPNTextFieldDelegate)?.DidPressClearButton()
    }
}
