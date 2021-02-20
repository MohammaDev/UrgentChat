//
//  K.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 09/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import Foundation

struct K {
    
    static let Back                 = "Back"
    static let empty                = ""
    static let loading              = "loading"
    static let plusSign             = "+"
    static let arabicCode           = "ar"
    static let startChating         = "Start Chating"
    static let enterPhoneNumber     = "Enter a Phone Number"
    static let pasteFromClipBoard   = "Paste from Clipboard"
    static let dictionaryIdentifier = "CFBundleShortVersionString"

    struct URL {
        static let whatsapp       = "https://api.whatsapp.com/send?phone="
        static let credits        = "https://mohammadev.github.io/UrgentChat_Credits/"
        static let privacyPolicy  = "https://mohammadev.github.io/UrgentChat_PrivacyPolicy/"
    }
    
    struct Identifiers {
        static let privacy         = "Privacy Cell"
        static let barButtonSegue  = "Go to Settings"
    }
    
    struct Fonts {
        static let bold    = "Dubai-Bold"
        static let light   = "Dubai-Light"
        static let regular = "Dubai-Regular"
    }
    
    struct Theme {
        static let dark             = "Dark"
        static let light            = "Light"
        static let dynamic          = "Dynamic"
        static let currentTheme     = "currentTheme"
    }
    
    struct TextField {
        static let textColor        = "TextFieldTextColor"
        static let borderColor      = "TextFieldBorderColor"
        static let backgroundColor  = "TextFieldBackgroundColor"
        static let placeholderColor = "TextFieldPlaceholderColor"
    }
    
    struct Button {
        static let titleColor      = "ButtonTitleColor"
        static let backgroundColor = "ButtonBackgroundColor"
    }
    
    struct Card {
        static let backgroundColor = "CardBackgroundColor"
    }
    
    struct Image {
        static let gear        = "GearImage"
        static let clearButton = "CrossImage"
        static let wallpaper   = "WallpaperImage"
    }
    
    struct Lable {
        static let textColor = "WelcomeTextColor"
    }
}
