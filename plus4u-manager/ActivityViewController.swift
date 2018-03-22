//
//  ActivityViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 04.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var name = ""
    var descriptionActivity = ""
    var state = ""
    var artifact = ""
    var uri = ""
    var competent = ""
    var executive = ""
    var activityUri = ""
    
    var firstCode = ""
    var secondCode = ""
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var competentName: UILabel!
    @IBOutlet weak var executiveName: UILabel!
    @IBOutlet weak var artifactButton: UIButton!
    
    @IBOutlet weak var setState: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewExe: UITableView!
    @IBOutlet weak var tableArtefact: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCredetials()
        
        tableView.delegate = self
        tableViewExe.delegate = self
        tableArtefact.delegate = self
        
        tableView.dataSource = self
        tableViewExe.dataSource = self
        tableArtefact.dataSource = self
        
        activityName.text! = name
        descriptionText.text! = descriptionActivity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVS = segue.destination as! WebViewController
        destVS.artifactUri = self.uri
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }

    @IBAction func setStateAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Nastavení stavu", message: "Nastavte stav aktivitě dle možností.", preferredStyle: .actionSheet)
        
        let initial = UIAlertAction(title: "INITIAL", style: .default) {
            (action) in self.seStateCommand(x: "INITIAL")
        }
        
        let active = UIAlertAction(title: "ACTIVE", style: .default) {
            (action) in self.seStateCommand(x: "ACTIVE")
        }
        
        let final = UIAlertAction(title: "FINAL", style: .default) {
            (action) in self.seStateCommand(x: "FINAL")
        }
        
        let canceled = UIAlertAction(title: "CANCELED", style: .default) {
            (action) in self.seStateCommand(x: "CANCELED")
        }
        
        //cancel this action
        let cancel = UIAlertAction(title: "zrušit", style: .cancel) {
            (action) in print("canceled")
        }
        
        alert.addAction(initial)
        alert.addAction(active)
        alert.addAction(final)
        alert.addAction(canceled)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func seStateCommand(x:String) -> () {
        let state = x
            
        let aParameter = descriptionActivity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
            
        var url = "http:10.0.1.16:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/setState?"
        url = url + "code1=\(firstCode)"
                + "&code2=\(secondCode)"
                + "&activityUri=\(activityUri)"
                + "&activityStateType=\(state)"
                + "&comment=\(aParameter)"
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
            
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("error")
            }
            else {
                let alert = UIAlertController(title: "Aktivita nastavena na stav - \(state).", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        if tableView.tag == 1 {
            cell.textLabel?.text = competent
        }
        if tableView.tag == 2 {
            cell.textLabel?.text = executive
        }
        if tableView.tag == 3 {
            cell.textLabel?.text = artifact
        }
            
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
