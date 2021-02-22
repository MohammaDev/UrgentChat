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
        
        setupCard()
        self.setBouncing()
        self.setObservers()
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

//MARK: - SettingsViewControllerDelegate
extension HomeViewController {
    func setupCard() {
        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.view.clipsToBounds = true
        cardViewController.view.layer.cornerRadius = 50
        cardViewController.arrowImage.image = UIImage(named: "CardUpArrowImage")
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - 95 - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardPan(recognizer:)))
        cardViewController.handleArea.addGestureRecognizer(getTapGesture())
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        cardViewController.templatesButton.addGestureRecognizer(getTapGesture())
        cardViewController.historyButton.addGestureRecognizer(getTapGesture())
        self.cardViewController.historyButton.isPressed = true
    }
    
    func getTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardTap(recognzier:)))
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.5)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    self.cardViewController.arrowImage.image = UIImage(named: "CardDownArrowImage")
                    self.cardViewController.historyButton.gestureRecognizers?.removeAll()
                    self.cardViewController.templatesButton.gestureRecognizers?.removeAll()
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - 95 - self.cardHandleAreaHeight
                    self.cardViewController.arrowImage.image = UIImage(named: "CardUpArrowImage")
                    self.cardViewController.historyButton.addGestureRecognizer(self.getTapGesture())
                    self.cardViewController.templatesButton.addGestureRecognizer(self.getTapGesture())
                    self.cardViewController.historyButton.isPressed = true
                    self.cardViewController.templatesButton.isPressed = false
                    self.cardViewController.tableView.reloadData()
                    self.changeTheme(to: self.userDefaults.object(forKey: K.Theme.currentTheme) as? String)
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 50
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 50
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
