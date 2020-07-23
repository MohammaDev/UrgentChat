//
//  AppManager.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 12/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

struct AppManager {
    
    static func openURL(_ number : String){
        let phoneNumber = number.replacingOccurrences(of: K.plusSign, with: K.empty)
        guard let url   = URL(string: "\(K.URL.whatsapp)\(phoneNumber)") else { return }
        UIApplication.shared.open(url)
    }
}
