//
//  TodayViewController.swift
//  Urgent Chat Widget
//
//  Created by Mohammad Alotaibi on 21/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import NotificationCenter
import FlagPhoneNumber

class WidgetViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var textField: FPNTextField!
    @IBOutlet weak var chatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBouncing()
        textField.setFlagSize()
        chatButton.setDubaiFont()
        self.changeButtonStatus()
        textField.delegate = self
        textField.setClearButton()
        chatButton.setCornerRadius()
        textField.clearPlaceholder()
        textField.ForceAlignmentToLeft()
        // Mohammad Abdu
    }
        
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        if chatButton.titleLabel?.text == NSLocalizedString(K.pasteFromClipBoard, comment: K.empty) {
            textField.set(phoneNumber: UIPasteboard.general.string!)
        }
        else{
            let number = textField.getFormattedPhoneNumber(format: .E164)!
            let phoneNumber = number.replacingOccurrences(of: K.plusSign, with: K.empty)
            guard let url   = URL(string: "\(K.URL.whatsapp)\(phoneNumber)") else { return }
            openURL(url)
        }
    }
}

//MARK: - FPNTextFieldDelegate
extension WidgetViewController : FPNTextFieldDelegate {
    
    /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.changeButtonStatus()
        textField.EditClearButtonAppearence()
    }
    
    /// Lets you know when the clear button got pressed
    func DidPressClearButton() {
        self.changeButtonStatus()
        textField.EditClearButtonAppearence()
    }
    
    /// The place to present/push the listController if you choosen displayMode = .list
    func fpnDisplayCountryList() {}
    
    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
}
