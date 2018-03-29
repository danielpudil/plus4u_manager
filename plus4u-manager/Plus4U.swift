//
//  Plus4U.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 03.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import Foundation
import UIKit

class Plus4U: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func callLoginAlert() {
        print("fsdf")
        let alert = UIAlertController(title: "Zpráva pro byla úspěšně odeslána.", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true)
    }
}
