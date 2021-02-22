//
//  HomeViewControllerExtension.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import AudioToolbox

extension HomeViewController {
    
    var isArabic : Bool {
        if NSLocale.autoupdatingCurrent.languageCode == K.arabicCode {
            return true
        }
        return false
        
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
    
    func setObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(toggleKeyboard), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(reloadClipboard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func toggleKeyboard() {
        textField.resignFirstResponder()
    }
    
    @objc func reloadClipboard() {
        changeButtonStatus()
    }
    
    func setBouncing() {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(bounce), userInfo: nil, repeats: true)
    }
    
    func setActionForRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: K.empty, style: .plain, target: self, action: #selector(settingsButtonAction))
    }
    
    @objc func settingsButtonAction() {
        toggleKeyboard()
        self.performSegue(withIdentifier: K.Identifiers.barButtonSegue, sender: self)
    }
    
    func setDubaiFont() {
        if isArabic {
//            chatButton.titleLabel?.font = UIFont(name: K.Fonts.regular, size: 23)
//            urgentChatLable.font = UIFont(name: K.Fonts.bold, size: 40)
//            encourageLable.font = UIFont(name: K.Fonts.light, size: 23)
//            lablesStack.spacing = 0
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
    
    func changeTheme(to optional : String?) {
        optional != nil ? performChange(optional!) : performChange(K.Theme.dynamic)
    }
    
    func performChange(_ kind : String) {
        
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "\(kind)\(K.Image.gear)")?.withRenderingMode(.alwaysOriginal)
        
        imageView.image                 =  UIImage(named: "\(kind)\(K.Image.wallpaper)")
        encourageLable.textColor        =  UIColor(named: "\(kind)\(K.Lable.textColor)")
        urgentChatLable.textColor       =  UIColor(named: "\(kind)\(K.Lable.textColor)")
        
        textField.layer.borderWidth     =  1.0
        textField.layer.cornerRadius    =  5.0
        textField.layer.masksToBounds   =  true
        textField.textColor             =  UIColor(named: "\(kind)\(K.TextField.textColor)")
        textField.backgroundColor       =  UIColor(named: "\(kind)\(K.TextField.backgroundColor)")
        textField.layer.borderColor     =  UIColor(named: "\(kind)\(K.TextField.borderColor)")?.cgColor
        textField.attributedPlaceholder =  NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "\(kind)\(K.TextField.placeholderColor)")!])
        
        chatButton.backgroundColor      =  UIColor(named: "\(kind)\(K.Button.backgroundColor)")
        chatButton.setTitleColor(UIColor(named: "\(kind)\(K.Button.titleColor)"), for: .normal)
        
        cardViewController.view.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        cardViewController.handleArea.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        
        if (cardViewController.historyButton.isPressed){
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)CardButtonBackgroundColor")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        }
        else if (cardViewController.templatesButton.isPressed){
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)CardButtonBackgroundColor")
        }
        else {
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        }
        
        cardViewController.historyButton.setTitleColor(UIColor(named: "\(kind)\(K.TextField.textColor)"), for: .normal)
        cardViewController.templatesButton.setTitleColor(UIColor(named: "\(kind)\(K.TextField.textColor)"), for: .normal)
        
        cardViewController.titleLable.textColor = UIColor(named: "\(kind)\(K.TextField.textColor)")
        
        cardViewController.tableView.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")

        
        userDefaults.set(kind, forKey: K.Theme.currentTheme)
    }
}
