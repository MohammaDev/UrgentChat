//
//  Widget.swift
//  Urgent Chat Widget
//
//  Created by Mohammad Alotaibi on 21/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import NotificationCenter

extension WidgetViewController {
    
    var isArabic : Bool {
        if NSLocale.autoupdatingCurrent.languageCode == K.arabicCode {
            return true
        }
        return false
        
    }
    
    func setBouncing() {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(bounce), userInfo: nil, repeats: true)
    }
    
    @objc func bounce() {
        if clipboardHasStringAndTextFieldIsEmpty() {
            let bounds = chatButton.bounds
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                self.chatButton.bounds = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            }) { (success:Bool) in
                if success {
                    self.chatButton.bounds = bounds
                }
            }
        }
    }
    
    func changeButtonStatus() {
        if clipboardHasStringAndTextFieldIsEmpty() {
            chatButton.applyPasteFromClipboardStyle()
        }
        else if clipboardAndTextFieldAreEmpty() {
            chatButton.applyDisableStyle()
        }else {
            chatButton.applyStartChatingStyle()
        }
    }
    
    func clipboardHasStringAndTextFieldIsEmpty() -> Bool {
        return (UIPasteboard.general.string != nil) && ((textField.text?.isEmpty) == true)
    }
    
    func clipboardAndTextFieldAreEmpty() -> Bool {
        return (UIPasteboard.general.string == nil) && ((textField.text?.isEmpty) == true)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
