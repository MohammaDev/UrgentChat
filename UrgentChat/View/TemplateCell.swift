//
//  TemplateCell.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 22/02/2021.
//  Copyright © 2021 Mohammad Alotaibi. All rights reserved.
//

import UIKit

class TemplateCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var templateLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
