//
//  SettingsTableViewCell.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 06.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfSetting: UILabel!
    @IBOutlet weak var actionState: UISwitch!
    
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if nameOfSetting.text == "Automatické přihlašování" {
            UserDefaults.standard.set(false, forKey: "Přihlášení otiskem prstů")
        }
        UserDefaults.standard.set(sender.isOn, forKey: nameOfSetting.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSwitch()
    }
    
    public func setSwitch() {
        if let x = UserDefaults.standard.object(forKey: nameOfSetting.text!) as? Bool {
            actionState.isOn = x
        }
        else {
            actionState.isOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
