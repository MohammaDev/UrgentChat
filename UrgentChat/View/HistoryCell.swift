//
//  HistoryCell.swift
//  UrgentChat
//
//  Created by Mohammad Alotaibi on 20/02/2021.
//  Copyright © 2021 Mohammad Alotaibi. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var flageImage: UIImageView!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
