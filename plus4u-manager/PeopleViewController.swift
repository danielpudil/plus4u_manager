//
//  PeopleViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 04.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var personName = ""
    var firstCode = ""
    var secondCode = ""
    
    var fetchedPerson = [PeopleViewController.Person]()
    var selectedPerson = [PeopleViewController.Person]()
    var num: [Int] = []
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCredetials()
                
        tableView.dataSource = self
        
        parseData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }
    
    func parseData() {
        self.loader.startAnimating()
        fetchedPerson = []
        let aPersonName = personName
        let aParameter = aPersonName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
        
        var url = "http:10.0.1.16:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/findPersonByParameters?"
        url = url + "code1=\(firstCode)" + "&code2=\(secondCode)" + "&clientName=\(aParameter)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("error")
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any]
                    
                    let listPersons = fetchedData["cardList"] as! [NSArray]
                    
                    for person in listPersons as! [AnyObject] {
                        let name = person["name"] as! String
                        let p4u_id = person["p4u_id"] as! String
                        let uri = person["uri"] as! String
                        self.fetchedPerson.append(Person(name: name, p4u_id: p4u_id, uri: uri))
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.loader.stopAnimating()
                }
                catch {
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
        return fetchedPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = fetchedPerson[indexPath.row].name
        cell.detailTextLabel?.text = fetchedPerson[indexPath.row].p4u_id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.num.append(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
        let destVS = segue.destination as! SendMessageViewController
        
        destVS.personName = fetchedPerson[(selectedIndex?.row)!].name
        destVS.personUID = fetchedPerson[(selectedIndex?.row)!].p4u_id
        destVS.personUri = fetchedPerson[(selectedIndex?.row)!].uri
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Person {
        var name : String
        var p4u_id : String
        var uri : String
        
        init(name: String, p4u_id: String, uri: String) {
            self.name = name
            self.p4u_id = p4u_id
            self.uri = uri
        }
    }
}
