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
        notificationCenter.addObserver(self, selector: #selector(recheckClipboard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func setTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toggleKeyboard() {
        textField.resignFirstResponder()
    }
    
    @objc func recheckClipboard() {
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
        return (UIPasteboard.general.hasStrings) && ((textField.text?.isEmpty) == true)
    }
    
    func clipboardAndTextFieldAreEmpty() -> Bool {
        return (!UIPasteboard.general.hasStrings) && ((textField.text?.isEmpty) == true)
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
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.Button.backgroundColor)")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        }
        else if (cardViewController.templatesButton.isPressed){
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.Button.backgroundColor)")
        }
        else {
            cardViewController.historyButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
            cardViewController.templatesButton.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")
        }
        
        cardViewController.historyButton.setTitleColor(UIColor(named: "\(kind)\(K.TextField.textColor)"), for: .normal)
        cardViewController.templatesButton.setTitleColor(UIColor(named: "\(kind)\(K.TextField.textColor)"), for: .normal)
        
        cardViewController.historyButton.tintColor = UIColor(named: "\(kind)\(K.Card.Button.tint)")
        cardViewController.templatesButton.tintColor = UIColor(named: "\(kind)\(K.Card.Button.tint)")
        
        
        cardViewController.titleLable.textColor = UIColor(named: "\(kind)\(K.TextField.textColor)")
        
        cardViewController.tableView.backgroundColor = UIColor(named: "\(kind)\(K.Card.backgroundColor)")

        
        userDefaults.set(kind, forKey: K.Theme.currentTheme)
    }
    
    //MARK: - Card Setup
    
    func setupCard() {
        cardViewController = CardViewController(nibName:K.Card.identifier, bundle:nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.clipsToBounds = true
        cardViewController.view.layer.cornerRadius = 50
        cardViewController.historyButton.isPressed = true
        cardViewController.arrowImage.image = UIImage(named: K.Card.Arrow.up)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - 95, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.handleArea.addGestureRecognizer(getTapGesture())
        cardViewController.handleArea.addGestureRecognizer(getPanGesture())
        cardViewController.historyButton.addGestureRecognizer(getTapGesture())
        cardViewController.templatesButton.addGestureRecognizer(getTapGesture())
    }
    
    func getTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardTap(recognzier:)))
    }
    
    func getPanGesture() -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardPan(recognizer:)))
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
                    self.cardViewController.arrowImage.image = UIImage(named: K.Card.Arrow.down)
                    self.cardViewController.historyButton.gestureRecognizers?.removeAll()
                    self.cardViewController.templatesButton.gestureRecognizers?.removeAll()
                    
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - 95
                    self.cardViewController.arrowImage.image = UIImage(named: K.Card.Arrow.up)
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
