//
//  DiaryTableViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 13.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class DiaryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var fetchedReservations = [Reservation]()
    var firstCode = ""
    var secondCode = ""
    let date = Date()
    let formatter = DateFormatter()
    var activityType = true
    
    @IBOutlet weak var actualDate: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        self.actualDate.title = result
        
        setCredetials()
        offlineMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedReservations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryTableViewCell
        
        tableView.rowHeight = 80
        self.tableView.rowHeight = 80
        cell.nameActivity.text = fetchedReservations[indexPath.row].subject
        
        let dateStringStart: String = fetchedReservations[indexPath.row].dateStart
        let dateStringEnd: String = fetchedReservations[indexPath.row].dateEnd
        
        let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let yourDateStart: NSDate = dateFormatter1.date(from: dateStringStart)! as NSDate
        let yourDateEnd: NSDate = dateFormatter1.date(from: dateStringEnd)! as NSDate
        
        dateFormatter1.dateFormat = "d. M. yyyy"
        let dateFrom = dateFormatter1.string(from: yourDateStart as Date)

        
        dateFormatter1.dateFormat = "HH:mm"
        let timeFrom = dateFormatter1.string(from: yourDateStart as Date)
        let timeTo = dateFormatter1.string(from: yourDateEnd as Date)
        
        cell.dateActivity.text = dateFrom
        cell.timeActivity.text = timeFrom
        
        
        if fetchedReservations[indexPath.row].activityStateType == "INITIAL" {
            cell.myState.image = #imageLiteral(resourceName: "state_initial.gif")
        }
        if fetchedReservations[indexPath.row].activityStateType == "ACTIVE" {
            cell.myState.image = #imageLiteral(resourceName: "state_active.gif")
        }
        if fetchedReservations[indexPath.row].activityStateType == "PROBLEM_ACTIVE" {
            cell.myState.image = #imageLiteral(resourceName: "dismiss.gif")
        }
  
        return cell
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }
    
    func offlineMode() {
        if let activities = UserDefaults.standard.object(forKey: "appDataReservations") {
            for activity in activities as! [AnyObject] {
                let end = activity["dateTo"] as! String
                let start = activity["dateStart"] as! String
                let subject = activity["name"] as! String
                let activityUri = activity["activityUri"] as! String
                let activityStateType = activity["activityStateType"] as! String
                
                self.fetchedReservations.append(Reservation(dateEnd: end, dateStart: start, subject: subject, activityUri: activityUri, activityStateType: activityStateType))
            }
            
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        else {
            print("sync data...")
            parseData()
        }
    }
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        self.parseData()
    }
    
    func parseData() {
        fetchedReservations = []
        self.loader.startAnimating()
        self.tableView.isHidden = true
        
        let address = IPAddress().getCommandUri(command: "getActivityList") as! String
        let url = "\(address)?" + "code1=\(firstCode)" + "&code2=\(secondCode)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("error")
                self.loader.stopAnimating()
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any]
                    
                    let activities = fetchedData["activities"] as! [NSArray]
                    
                    for activity in activities as [AnyObject] {
                        let end = activity["dateTo"] as! String
                        let start = activity["dateStart"] as! String
                        let subject = activity["name"] as! String
                        let activityUri = activity["activityUri"] as! String
                        let activityStateType = activity["activityStateType"] as! String
                        
                        self.fetchedReservations.append(Reservation(dateEnd: end, dateStart: start, subject: subject, activityUri: activityUri, activityStateType: activityStateType))
                    }
                    
                    UserDefaults.standard.set(activities, forKey: "appDataReservations")
                    
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.loader.stopAnimating()
                }
                catch {
                    print("error 2")
                    self.loader.stopAnimating()
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fetchedReservations.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let accept = UITableViewRowAction(style: .normal, title: "Účast akceptována") { action, index in
            print("accept")
            SetState().seStateCommand(state: "ACTIVE", activityUri: self.fetchedReservations[index.row].activityUri)
            self.parseData()
        }
        let dismiss = UITableViewRowAction(style: .normal, title: "Účast odmítnuta") { action, index in
            print("dismiss")
            SetState().seStateCommand(state: "PROBLEM_ACTIVE", activityUri: self.fetchedReservations[index.row].activityUri)
            self.parseData()
        }
        
        accept.backgroundColor = UIColor(red: (103/255.0), green: (188/255.0), blue: (61/255.0), alpha: 1.0)
        dismiss.backgroundColor = UIColor(red: (232/255.0), green: (69/255.0), blue: (60/255.0), alpha: 1.0)
        
        return [accept, dismiss]
    }
}

class Reservation {
    var dateEnd : String
    var dateStart : String
    var subject : String
    var activityUri : String
    var activityStateType : String
    
    init(dateEnd: String, dateStart: String, subject: String, activityUri: String, activityStateType: String) {
        self.dateEnd = dateEnd
        self.dateStart = dateStart
        self.subject = subject
        self.activityUri = activityUri
        self.activityStateType = activityStateType
    }
}
