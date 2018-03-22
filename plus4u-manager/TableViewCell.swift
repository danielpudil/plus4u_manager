//
//  TableViewCell.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 05.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myState: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
