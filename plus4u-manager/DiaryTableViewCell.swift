//
//  DiaryTableViewCell.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 14.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameActivity: UILabel!
    @IBOutlet weak var dateActivity: UILabel!
    @IBOutlet weak var timeActivity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
