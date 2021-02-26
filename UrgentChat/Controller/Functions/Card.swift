//
//  Card.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 26/02/2021.
//  Copyright © 2021 Mohammad Alotaibi. All rights reserved.
//

import UIKit

extension CardViewController {
    func setHistoryButton() {
        // add padding to the edges
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }
    
    func retrieveArrays() {
        // retrieving the history array
        if let encodedData = userDefaults.value(forKey:"Records") as? Data {
            arrayOfRecords = try! PropertyListDecoder().decode([HistoryRecord].self, from: encodedData)
        }
        
        // retrieving the templates array
        arrayOfTemplates = userDefaults.object(forKey: "Template") as? [String] ?? arrayOfTemplates
    }
}
