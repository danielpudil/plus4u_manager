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
    @IBOutlet weak var typeActivity: UIImageView!
    @IBOutlet weak var tableView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = CGSize(width: 4, height: 4)
        tableView.layer.shadowRadius = 15.0
        tableView.layer.shadowColor = UIColor.darkGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
