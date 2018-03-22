//
//  FirstViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 02.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var isSearching = false
    
    var activity = ActivityViewController()
    var fetchedPerson = [Activities]()
    var filteredData = [Activities]()
    var refresher : UIRefreshControl!
    
    var firstCode = ""
    var secondCode = ""
    
    @IBOutlet weak var calendar: UIBarButtonItem!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCredetials()
        
        tableView.dataSource = self
        self.tableView.isHidden = true

        parseData()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refresher = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        

        refresher.attributedTitle = NSAttributedString(string: "Potažením aktualizujte", attributes: attributes)
        refresher.addTarget(self, action: #selector(FirstViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refresher.tintColor = UIColor.white
        
        tableView.addSubview(refresher)
        tableView.refreshControl = refresher
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
    }
    
    
    
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        searchBar.isHidden = !searchBar.isHidden
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
        fetchedPerson = []
        
        var url = "http:10.0.1.16:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/listActivities?"
        url = url + "code1=\(firstCode)" + "&code2=\(secondCode)"
        
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
                    
                    for territory in territories {
                        for activity in territory as! [AnyObject] {
                            let name = activity["name"] as! String
                            let description = activity["activityStateDescription"] as! String
                            let state = activity["activityStateType"] as! String
                            let artifact = activity["artifactName"] as! String
                            let uri = activity["artifactUri"] as! String
                            let activityUri = activity["activityUri"] as! String
                            let competent = activity["competentRoleName"] as! String
                            let executive = activity["executiveRoleName"] as! String
                            let unRead = activity["isUnread"] as! Bool

                            self.fetchedPerson.append(Activities(name: name, description: description, state: state, artifact: artifact, competent: competent, executive: executive, uri: uri, unRead: unRead, activityUri: activityUri))
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    self.tableView.isHidden = false
                    self.loader.stopAnimating()
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Nové aktivity"
                    content.body = "Byly zobrazeny nejnovější aktivity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "timeDone", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
        if isSearching {
            return filteredData.count
        }
        
        return fetchedPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.myLabel.text = fetchedPerson[indexPath.row].name

        cell.myDescription.text = "Kompetentí role: " + fetchedPerson[indexPath.row].competent
        
        if isSearching {
            if filteredData[indexPath.row].state == "INITIAL" {
                cell.myState.image = #imageLiteral(resourceName: "state_initial.gif")
            }
            if filteredData[indexPath.row].state == "ACTIVE" {
                cell.myState.image = #imageLiteral(resourceName: "state_active.gif")
            }
            if filteredData[indexPath.row].state == "FINAL" {
                cell.myState.image = #imageLiteral(resourceName: "state_final.gif")
            }
        }
        else {
            if fetchedPerson[indexPath.row].state == "INITIAL" {
                cell.myState.image = #imageLiteral(resourceName: "state_initial.gif")
            }
            if fetchedPerson[indexPath.row].state == "ACTIVE" {
                cell.myState.image = #imageLiteral(resourceName: "state_active.gif")
            }
            if fetchedPerson[indexPath.row].state == "FINAL" {
                cell.myState.image = #imageLiteral(resourceName: "state_final.gif")
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            print(sender as Any)
            var selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
            let destVS = segue.destination as! ActivityViewController
            
            destVS.name = fetchedPerson[(selectedIndex?.row)!].name
            destVS.descriptionActivity = fetchedPerson[(selectedIndex?.row)!].description
            destVS.artifact = fetchedPerson[(selectedIndex?.row)!].artifact
            destVS.uri = fetchedPerson[(selectedIndex?.row)!].uri
            destVS.competent = fetchedPerson[(selectedIndex?.row)!].competent
            destVS.executive = fetchedPerson[(selectedIndex?.row)!].executive
            destVS.activityUri = fetchedPerson[(selectedIndex?.row)!].activityUri
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fetchedPerson.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "Dokončeno") { action, index in
            //self.activity.seStateCommand(x: "FINAL")
        }
        share.backgroundColor = UIColor(red: (21/255.0), green: (126/255.0), blue: (251/255.0), alpha: 1.0)
        
        return [share]
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        parseData()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            isSearching = true
            filteredData = fetchedPerson.filter({$0.name.contains(searchBar.text!)})
            tableView.reloadData()
        }
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
    var artifact : String
    var competent : String
    var executive : String
    var uri : String
    var unRead : Bool
    var activityUri: String
    
    init(name: String, description: String, state: String, artifact: String, competent: String, executive: String, uri: String, unRead: Bool, activityUri: String) {
        self.name = name
        self.description = description
        self.state = state
        self.artifact = artifact
        self.competent = competent
        self.executive = executive
        self.uri = uri
        self.unRead = unRead
        self.activityUri = activityUri
    }
}

