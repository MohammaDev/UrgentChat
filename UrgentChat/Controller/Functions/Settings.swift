//
//  Settings.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    func reloadSettings(_ status : String) {
        switch status {
        case K.Theme.dark:
            darkSwitchOn()
        case K.Theme.light:
            lightSwitchOn()
        default:
            systemSwitchOn()
        }
    }
    
    func systemSwitchOn() {
        systemModeSwitch.isOn = true
        lightModeSwitch.isOn = false
        darkModeSwitch.isOn = false
    }
    
    func lightSwitchOn() {
        lightModeSwitch.isOn = true
        systemModeSwitch.isOn = false
        darkModeSwitch.isOn = false
    }
    
    func darkSwitchOn() {
        darkModeSwitch.isOn = true
        lightModeSwitch.isOn = false
        systemModeSwitch.isOn = false
    }
    
    func askForChangeThem(to theme : String) {
        SettingsViewController.delegate?.didUpdateTheme(self, theme)
    }
    
    func getURL( _ segueIdentifier : String) -> String{
        if segueIdentifier == K.Identifiers.privacy {
            return K.URL.privacyPolicy
        }
        else {
            return K.URL.credits
        }
    }
}
