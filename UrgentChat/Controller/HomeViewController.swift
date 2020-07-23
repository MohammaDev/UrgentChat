//
//  ViewController.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 04/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit
import FlagPhoneNumber

            
class HomeViewController: UIViewController {
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var textField: FPNTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urgentChatLable: UILabel!
    @IBOutlet weak var encourageLable: UILabel!
    @IBOutlet weak var lablesStack: UIStackView!
        
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBouncing()
        self.setObservers()
        self.setDubaiFont()
        textField.setFlagSize()
        self.changeButtonStatus()
        textField.delegate = self
        textField.setClearButton()
        chatButton.setCornerRadius()
        textField.ForceAlignmentToLeft()
        self.setActionForRightBarButton()
        SettingsViewController.delegate = self
        self.changeTheme(to: userDefaults.object(forKey: K.Theme.currentTheme) as? String)
        // Git Me
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
       
        if chatButton.titleLabel?.text == NSLocalizedString(K.pasteFromClipBoard, comment: K.empty) {
            textField.set(phoneNumber: UIPasteboard.general.string!)
        }
        else{
            let number = textField.getFormattedPhoneNumber(format: .E164)!
            AppManager.openURL(number)
        }
        self.toggleKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as! SettingsViewController
        settingsVC.selectedTheme = userDefaults.object(forKey: K.Theme.currentTheme) as? String
    }
    
    /// To manage the app theme once the user change the mode from the Control Center
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                let appMode = userDefaults.object(forKey: K.Theme.currentTheme) as? String
                if (appMode == nil) || (appMode == K.Theme.dynamic) {
                    self.changeTheme(to: K.Theme.dynamic)
                }
            }
        }
    }
}

//MARK: - SettingsViewControllerDelegate
extension HomeViewController : SettingsViewControllerDelegate {
    
    func didUpdateTheme(_ SettingsViewController: UITableViewController, _ selectedTheme: String) {
        self.changeTheme(to: selectedTheme)
    }
}

//MARK: - FPNTextFieldDelegate
extension HomeViewController : FPNTextFieldDelegate {
 
    /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.changeButtonStatus()
        textField.EditClearButtonAppearence()
    }
    
    /// Let you know when the clear button got pressed
    func DidPressClearButton() {
        self.changeButtonStatus()
        textField.EditClearButtonAppearence()
    }
    
    /// The place to present/push the listController if you choosen displayMode = .list
    func fpnDisplayCountryList() {}
    
    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
}
