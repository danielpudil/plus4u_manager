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
    
    var messageTextField: UITextField?
    
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
        
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }
    
    func messageTextField(textField: UITextField!) {
        messageTextField = textField
    }
    
    @IBAction func setStateAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Nastav stav zprávy", message: "Komentář", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: messageTextField)

        let initial = UIAlertAction(title: "Přiděleno", style: .default) {
            (action) in self.seStateCommand(x: "INITIAL")
        }

        let active = UIAlertAction(title: "Akceptováno/Informováno", style: .default) {
            (action) in self.seStateCommand(x: "ACTIVE")
        }

        let final = UIAlertAction(title: "Dokončeno/Přečteno (FINAL)", style: .default) {
            (action) in self.seStateCommand(x: "FINAL")
        }

        let canceled = UIAlertAction(title: "Zrušeno (FINAL)", style: .default) {
            (action) in self.seStateCommand(x: "CANCELED")
        }

        let cancel = UIAlertAction(title: "zrušit", style: .cancel) {
            (action) in print("canceled")
        }

        alertController.addAction(initial)
        alertController.addAction(active)
        alertController.addAction(final)
        alertController.addAction(canceled)
        alertController.addAction(cancel)

        self.present(alertController, animated: true)
    }
    
    func seStateCommand(x:String) -> () {
        let state = x
            
        var aParameter = messageTextField?.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String

        let address = IPAddress().getCommandUri(command: "setState") as! String
        let url = "\(address)?" + "code1=\(firstCode)"
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
                let alert = UIAlertController(title: "Aktivita nastavena na stav - \(state).", message: nil, preferredStyle: UIAlertControllerStyle.alert)
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
            UserDefaults.standard.set(self.uri, forKey: "webUri")
        }
            
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
