//
//  SendMessageViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 04.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController, UITextFieldDelegate {

    var personName = ""
    var personUID = ""
    var personUri = ""
    var firstCode = ""
    var secondCode = ""

    @IBOutlet weak var namePerson: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var uidPerson: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = personName
        self.message.delegate = self as? UITextViewDelegate
        
        let aParameter = personUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
        let urlKey = "https://plus4u.net/ues/uiwcp/ues/core/property/UESProperty/getImageData;jsessionid=F10963C2B6C49BAF809DF6FC7978DECF.0tcde02?uesuri=\(aParameter)%3AUU.PLUS4UPPL%2FPHOTO_MT"
        print(urlKey)
        
        if let url = URL(string: urlKey) {
            do {
                let data = try Data(contentsOf: url)
                self.image.image = UIImage(data: data)
            }
            catch let err {
                print(" Error : \(err.localizedDescription)")
            }
        }
        
        setCredetials()
        
        namePerson.text! = personName
        uidPerson.text! = personUID
    }
    
    func setCredetials() {
        if let x = UserDefaults.standard.object(forKey: "firstCode") as? String {
            firstCode = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "secondCode") as? String {
            secondCode = x
        }
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        if message.text != "" {
            self.loader.isHidden = false
            self.sendButton.isEnabled = false
            self.sendButton.isHighlighted = true
            
            let aUri = personUri
            let aUID = personUID
            let aMessage = message.text!
            
            let aParameter = aMessage.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
            
            var url = "http:10.0.1.16:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/sendMessage?"
            url = url + "code1=\(firstCode)"
                      + "&code2=\(secondCode)"
                      + "&uri=\(aUri)"
                      + "&p4u_id=\(aUID)"
                      + "&message=\(aParameter)"
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("error")
                }
                else {
                    self.loader.isHidden = true
                    self.sendButton.isEnabled = true
                    self.sendButton.isHighlighted = false
                    
                    let alert = UIAlertController(title: "Zpráva pro \(self.personName) byla úspěšně odeslána.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            task.resume()
        }
        else {
            let alert = UIAlertController(title: "Zpráva nemůže být odeslána.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        message.resignFirstResponder()
        return (true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
