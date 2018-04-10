//
//  FirstViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 02.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var activity = ActivityViewController()
    var fetchedActivities = [Activities]()
    var filteredData = [Activities]()
    var refresher : UIRefreshControl!
    
    var firstCode = ""
    var secondCode = ""
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCredetials()
        
        tableView.dataSource = self
        self.tableView.isHidden = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        offlineMode()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refresher = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]

        refresher.attributedTitle = NSAttributedString(string: "Potažením aktualizujte", attributes: attributes)
        refresher.addTarget(self, action: #selector(FirstViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refresher.tintColor = UIColor.white
        
        tableView.addSubview(refresher)
        tableView.refreshControl = refresher
    }
    
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {

    }
    
    func offlineMode() {
        if let territories = UserDefaults.standard.object(forKey: "appDataActivities") {
            for activity in territories as! [AnyObject] {
                let name = activity["name"] as! String
                let description = activity["activityStateDescription"] as! String
                let state = activity["activityStateType"] as! String
                let artifact = activity["artifactName"] as! String
                let uri = activity["artifactUri"] as! String
                let activityUri = activity["activityUri"] as! String
                let competent = activity["competentRoleName"] as! String
                let executive = activity["executiveRoleName"] as! String
                let unRead = activity["isUnread"] as! Bool
                let dateTo = activity["dateTo"] as! String
                let type = activity["activityType"] as! String
                
                self.fetchedActivities.append(Activities(name: name, description: description, state: state, artifact: artifact, competent: competent, executive: executive, uri: uri, unRead: unRead, activityUri: activityUri, dateTo: dateTo, type: type))
            }
            
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        else {
            print("sync data...")
            parseData()
        }
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        parseData()
    }
    
    @objc func parseData() {
        self.tableView.isHidden = true
        self.loader.startAnimating()
        fetchedActivities = []
        
        let address = IPAddress().getCommandUri(command: "listActivities") as! String
        let url = "\(address)?" + "code1=\(firstCode)" + "&code2=\(secondCode)"
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                 self.loader.stopAnimating()
                print("error")
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any]
                    
                    let territories = fetchedData["activities"] as! [NSArray]
  
                    for activity in territories as [AnyObject] {
                            let name = activity["name"] as! String
                            let description = activity["activityStateDescription"] as! String
                            let state = activity["activityStateType"] as! String
                            let artifact = activity["artifactName"] as! String
                            let uri = activity["artifactUri"] as! String
                            let activityUri = activity["activityUri"] as! String
                            let competent = activity["competentRoleName"] as! String
                            let executive = activity["executiveRoleName"] as! String
                            let unRead = activity["isUnread"] as! Bool
                            let dateTo = activity["dateTo"] as! String
                            let type = activity["activityType"] as! String

                        self.fetchedActivities.append(Activities(name: name, description: description, state: state, artifact: artifact, competent: competent, executive: executive, uri: uri, unRead: unRead, activityUri: activityUri, dateTo: dateTo,type: type))
                    }
                    
                    UserDefaults.standard.set(territories, forKey: "appDataActivities")
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    self.tableView.isHidden = false
                    self.loader.stopAnimating()
                }
                catch {
                    self.loader.stopAnimating()
                    print("error 2")
                }
            }
        }
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let yourDateStart: NSDate = dateFormatter1.date(from: fetchedActivities[indexPath.row].dateTo)! as NSDate
        
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        let dateTo = dateFormatter1.string(from: yourDateStart as Date)
        
        print(dateTo)
        print(result)
        print(dateTo < result)
        
        let value = dateTo < result
        
        if value {
            cell.myLabel.textColor = UIColor.red
        }
        else {
            cell.myLabel.textColor = UIColor.black
        }
        
        
        cell.myLabel.text = fetchedActivities[indexPath.row].name

        cell.myDescription.text = "Kompetentí role: " + fetchedActivities[indexPath.row].competent
        
        if fetchedActivities[indexPath.row].state == "INITIAL" {
            cell.myState.image = #imageLiteral(resourceName: "state_initial.gif")
        }
        if fetchedActivities[indexPath.row].state == "ACTIVE" {
            cell.myState.image = #imageLiteral(resourceName: "state_active.gif")
        }
        if fetchedActivities[indexPath.row].state == "FINAL" {
            cell.myState.image = #imageLiteral(resourceName: "state_final.gif")
        }
        
        if fetchedActivities[indexPath.row].type == "TASK" {
            cell.typeActivity.image = #imageLiteral(resourceName: "doit.gif")
        }
        if fetchedActivities[indexPath.row].type == "MESSAGE" {
            cell.typeActivity.image = #imageLiteral(resourceName: "message.gif")
        }
        if fetchedActivities[indexPath.row].type == "TIME_RESERVATION" {
            cell.typeActivity.image = #imageLiteral(resourceName: "reservation.gif")
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            var selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
            let destVS = segue.destination as! ActivityViewController
            
            destVS.name = fetchedActivities[(selectedIndex?.row)!].name
            destVS.descriptionActivity = fetchedActivities[(selectedIndex?.row)!].description
            destVS.artifact = fetchedActivities[(selectedIndex?.row)!].artifact
            destVS.uri = fetchedActivities[(selectedIndex?.row)!].uri
            destVS.competent = fetchedActivities[(selectedIndex?.row)!].competent
            destVS.executive = fetchedActivities[(selectedIndex?.row)!].executive
            destVS.activityUri = fetchedActivities[(selectedIndex?.row)!].activityUri
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fetchedActivities.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "Dokončeno") { action, index in
            SetState().seStateCommand(state: "FINAL", activityUri: self.fetchedActivities[index.row].activityUri)
            self.fetchedActivities.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        share.backgroundColor = UIColor(red: (21/255.0), green: (126/255.0), blue: (251/255.0), alpha: 1.0)
        
        return [share]
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        parseData()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Activities {
    var name : String
    var description : String
    var state : String
    var type : String
    var artifact : String
    var competent : String
    var executive : String
    var uri : String
    var unRead : Bool
    var activityUri: String
    var dateTo: String
    
    init(name: String, description: String, state: String, artifact: String, competent: String, executive: String, uri: String, unRead: Bool, activityUri: String, dateTo: String, type: String) {
        self.name = name
        self.description = description
        self.state = state
        self.artifact = artifact
        self.competent = competent
        self.executive = executive
        self.uri = uri
        self.unRead = unRead
        self.activityUri = activityUri
        self.dateTo = dateTo
        self.type = type
    }
}

