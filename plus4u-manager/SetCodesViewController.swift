//
//  SetCodesViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 14.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class SetCodesViewController: UIViewController {

    var firstCodeAuth = ""
    var secondCodeAuth = ""
    
    @IBOutlet weak var firstCode: UITextField!
    @IBOutlet weak var secondCode: UITextField!
    @IBOutlet weak var changeCodes: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCredetials()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeCodesCommand(_ sender: UIButton) {
        if firstCode.text == "" || secondCode.text == "" {
            let alert = UIAlertController(title: "Oba přístupové kódy musí být vyplněné.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.chageCodesMethod()
        }
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCodeAuth = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCodeAuth = x
        }
    }
    
    func chageCodesMethod() {
        self.changeCodes.isEnabled = false
        
        let newCode1 = firstCode.text
        let newCode2 = secondCode.text
        
        let newCode1Parameter = newCode1?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
        
        let newCode2Parameter = newCode2?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
                
        var url = "http:10.0.1.16:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/changeCredentials?"
            url = url + "oldCode1=\(firstCodeAuth)"
                + "&oldCode2=\(secondCodeAuth)"
                + "&newCode1=\(newCode1Parameter)"
                + "&newCode2=\(newCode2Parameter)"
                
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
        
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
                
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("error")
                }
                else {
                    self.changeCodes.isEnabled = true
                    
                    UserDefaults.standard.set(newCode1Parameter, forKey: "firstCode")
                    UserDefaults.standard.set(newCode2Parameter, forKey: "secondCode")
                    
                    let alert = UIAlertController(title: "Přístupové kódy byly změněny.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }

}