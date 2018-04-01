//
//  CreateActivityViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 23.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController, UITextFieldDelegate {

    var firstCode = ""
    var secondCode = ""
    var executivePersons = [String]()
    
    @IBOutlet weak var nameActivity: UITextField!
    @IBOutlet weak var descriptionActivity: UITextView!
    @IBOutlet weak var executivesActivity: UITextField!
    @IBOutlet weak var fromActivity: UIDatePicker!
    @IBOutlet weak var toActivity: UIDatePicker!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var typeAction: UISegmentedControl!
    @IBOutlet weak var buttonPerson: UIButton!
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCredetials()

        self.nameActivity.delegate = self as? UITextViewDelegate as? UITextFieldDelegate
        self.descriptionActivity.delegate = self as? UITextViewDelegate
        self.executivesActivity.delegate = self as? UITextViewDelegate as? UITextFieldDelegate
        
        okButton.layer.shadowOpacity = 0.5
        okButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        okButton.layer.shadowRadius = 5.0
        okButton.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    @IBAction func addExecutivePerson(_ sender: UIButton) {
        if executivesActivity.text != "" {
            let number:Int? = Int(badgeTitle.text!)
            self.badgeTitle.text = String(number! + 1)
            self.badgeView.isHidden = false
            self.executivePersons.append(executivesActivity.text!)
            self.executivesActivity.text = ""
        }
    }
    
    @IBAction func createActivity(_ sender: UIButton) {
        if nameActivity.text != "" || descriptionActivity.text != "" || self.executivePersons.count != 0 {
        
            let aParameterName = nameActivity.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
            let aParameterDescription = descriptionActivity.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
            let aParameterExecutive = executivesActivity.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
            
            let artifactUri = UserDefaults.standard.object(forKey: "webUri") as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            let timeFrom = dateFormatter.string(from: fromActivity.date)
            let timeTo = dateFormatter.string(from: toActivity.date)

            let address = IPAddress().getCommandUri(command: "createActivity") as! String
            var url = "\(address)?" + "code1=\(firstCode)"
                + "&code2=\(secondCode)"
                + "&artifactUri=\(artifactUri)"
                + "&name=\(aParameterName)"
                + "&description=\(aParameterDescription)"
                + "&timeFrom=\(timeFrom)"
                + "&timeTo=\(timeTo)"
                + "&action=\(typeAction.selectedSegmentIndex)"
            
            var index = 0
            for person in self.executivePersons {
                url += "&executive\(index)=\(person)"
                index += 1
            }
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("error")
                }
                else {
                    let alert = UIAlertController(title: "Aktivita typu '\(self.typeAction.titleForSegment(at: self.typeAction.selectedSegmentIndex) as! String)' byla úspěšně vytvořena.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            task.resume()
        }
        else {
            let alert = UIAlertController(title: "Všechna pole musí být vyplněna!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameActivity.resignFirstResponder()
        descriptionActivity.resignFirstResponder()
        executivesActivity.resignFirstResponder()
        return (true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
