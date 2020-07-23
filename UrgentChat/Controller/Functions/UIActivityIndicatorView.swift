//
//  UIActivityIndicatorView.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 13/07/2020.
//  Copyright © 2020 Mohammad Alotaibi. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func setBackgraoundTransparency() {
        self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.8)
    }
    
    func setCornerRadious() {
        self.layer.cornerRadius = self.frame.height / 10
    }
}
