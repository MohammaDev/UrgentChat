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
    
    enum CardState {
        case expanded
        case collapsed
    }
    var cardViewController:CardViewController!
    lazy var cardHeight:CGFloat = {return (self.view.frame.size.height-120)/2}()
    let cardHandleAreaHeight:CGFloat = 65
    var cardVisible = false
    var nextState:CardState {return cardVisible ? .collapsed : .expanded}
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCard()
        self.setBouncing()
        self.setObservers()
        self.setTapRecognizer()
        self.setDubaiFont()
        self.changeButtonStatus()
        self.setActionForRightBarButton()
        self.changeTheme(to: userDefaults.object(forKey: K.Theme.currentTheme) as? String)
        
        textField.setFlagSize()
        textField.delegate = self
        textField.setClearButton()
        textField.ForceAlignmentToLeft()
        
        chatButton.setCornerRadius()
        
        cardViewController.delegate = self

        SettingsViewController.delegate = self
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        if chatButton.titleLabel?.text == NSLocalizedString(K.pasteFromClipBoard, comment: K.empty) {
            textField.set(phoneNumber: UIPasteboard.general.string!)
        }
        else{
            let number = textField.getFormattedPhoneNumber(format: .E164)!
            AppManager.openURL(number)
            
            
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            let newRecord = HistoryRecord(
                recordImage: Image(withImage: textField.flagButton.currentImage!),
                recordNumber: textField.text!,
                recordDate: formatter.string(from: currentDateTime)
            )
            
            cardViewController.arrayOfRecords.append(newRecord)
            cardViewController.arrayOfRecords.reverse()
            userDefaults.set(try? PropertyListEncoder().encode(cardViewController.arrayOfRecords), forKey: "Records")
            cardViewController.tableView.reloadData()
            
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
//MARK: - CardDelegate
extension HomeViewController: CardViewControllerDelegate {
    func didSelectButton() {
        changeTheme(to: (userDefaults.object(forKey: K.Theme.currentTheme) as? String))
    }
    
    func didSelectRecord(phoneNumber : String) {
        textField.set(phoneNumber: phoneNumber)
    }
    
    func didSelectTemplate() {
        //
    }
}

//MARK: - SettingsViewControllerDelegate
extension HomeViewController : SettingsViewControllerDelegate {
    
    func didUpdateTheme(_ SettingsViewController: UITableViewController, _ selectedTheme: String) {
        self.changeTheme(to: selectedTheme)
        cardViewController.tableView.reloadData()
    }
}

//MARK: - FPNTextFieldDelegate
extension HomeViewController : FPNTextFieldDelegate {
    
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

