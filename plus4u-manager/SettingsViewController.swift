//
//  SettingsViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 06.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var settings = ["Automatické přihlašování", "Přihlášení otiskem prstů"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLogout: UITableView!
    @IBOutlet weak var tableViewCredentials: UITableView!
    
    let cellIdentifier : String = "Settings"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableViewLogout.dataSource = self
        tableViewCredentials.dataSource = self
        
        tableView.delegate = self
        tableViewLogout.delegate = self
        tableViewCredentials.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1) {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        if (tableView.tag == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as! SettingsTableViewCell
            
            cell.nameOfSetting.text = self.settings[indexPath.row]
            
            if let x = UserDefaults.standard.object(forKey: settings[indexPath.row]) as? Bool {
                cell.actionState.isOn = x
            }
        
            return cell
        }
        else if (tableView.tag == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as! SettingsMoreTableViewCell
            
            cell.nameAction.text = "Odhlásit se"
       
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath)
            
            cell.textLabel?.text = "Změna přístupových kódů"
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2 {
            UserDefaults.standard.set(false, forKey: "Přihlášení otiskem prstů")
            UserDefaults.standard.set(false, forKey: "Automatické přihlašování")
            self.dismiss(animated: true, completion: {});
        }
    }
    
    func callAlert() {
        let alert = UIAlertController(title: "Odhlášení", message: "Odhlášení z aplikace proběhlo úspěšně!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
