//
//  LoginViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 04.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var firstCode: UITextField!
    @IBOutlet weak var secondCode: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var test: UIView!
    @IBOutlet weak var underline1: UIView!
    @IBOutlet weak var underline2: UIView!
    
    var login = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoLogin()
        self.touchID()
        UIApplication.shared.applicationIconBadgeNumber = 0 //F4F5F7
        
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        loginButton.layer.shadowRadius = 5.0
        loginButton.layer.shadowColor = UIColor.darkGray.cgColor
        
        underline1.layer.shadowOpacity = 0.5
        underline1.layer.shadowOffset = CGSize(width: 3, height: 3)
        underline1.layer.shadowRadius = 5.0
        underline1.layer.shadowColor = UIColor.darkGray.cgColor
        
        underline2.layer.shadowOpacity = 0.5
        underline2.layer.shadowOffset = CGSize(width: 3, height: 3)
        underline2.layer.shadowRadius = 5.0
        underline2.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        self.loader.startAnimating()
        
        //        let alert = UIAlertController(title: nil, message: "Přihlášování...", preferredStyle: .alert)
        //
        //        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        //        loadingIndicator.hidesWhenStopped = true
        //        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //        loadingIndicator.startAnimating();
        //
        //        alert.view.addSubview(loadingIndicator)
        //        self.present(alert, animated: true, completion: nil)

        parseData { (hasSucceed) in
            if hasSucceed {
                UserDefaults.standard.set(self.firstCode.text, forKey: "firstCode")
                UserDefaults.standard.set(self.secondCode.text, forKey: "secondCode")
                UserDefaults.standard.set(true, forKey: "login")
                
                self.performSegue(withIdentifier: "yes", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Byl zadán chybný přístupový kód 1 nebo přístupový kód 2.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func autoLogin() {
        if let x = UserDefaults.standard.object(forKey: "Automatické přihlašování") as? Bool {
            if x == true {
                print("fdsfd")
                OperationQueue.main.addOperation {
                    [weak self] in
                    self?.performSegue(withIdentifier: "yes", sender: self)
                }
            }
        }
    }
    
    func touchID() {
        if let x = UserDefaults.standard.object(forKey: "Přihlášení otiskem prstů") as? Bool {
            
            if x == true {
                let context:LAContext = LAContext()
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Pro přihlášení do aplikace přiložte prst.", reply: { (wasSuccessful, error) in
                        
                        if wasSuccessful {
                            self.setCodes()
                            
                            self.parseData { (hasSucceed) in
                                if hasSucceed {
                                    UserDefaults.standard.set(true, forKey: "login")
                                    self.performSegue(withIdentifier: "yes", sender: self)
                                }
                            }
                        }
                        else {
                            self.callFailedTouchId()
                        }
                    })
                }
                self.loader.stopAnimating()
            }
        }
    }
    
    func setCodes(){
        DispatchQueue.main.sync()
        {
            self.loader.startAnimating()
            self.firstCode.text = UserDefaults.standard.object(forKey: "firstCode") as? String
            self.secondCode.text = UserDefaults.standard.object(forKey: "secondCode") as? String
        }
    }
    
    func parseData(completion : @escaping ( ( Bool ) -> Void)){
        
        let aFirstCode = self.firstCode.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
        let aSecondCode = self.secondCode.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String

        //192.168.242.208 10.0.1.16
        let address = IPAddress().getCommandUri(command: "login") as! String
        let url = "\(address)?" + "code1=\(aFirstCode)" + "&code2=\(aSecondCode)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        var login = false
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print("error")
                self.loader.stopAnimating()
                self.callAlert()
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any]
                    
                    if (fetchedData["state"] as? Bool) != nil {
                        login = true
                    }
                    else {
                        login = false
                    }
                    self.loader.stopAnimating()
                }
                catch {
                    print("error 2")
                    self.loader.stopAnimating()
                    self.callAlert()
                }
            completion(login)
            }
        }
        task.resume()
    }
    
    func callAlert() {
        let alert = UIAlertController(title: "Chyba spojení", message: "Aplikace nemůže navázat spojení se serverem.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callFailedTouchId() {
        let alert = UIAlertController(title: "Upozornění", message: "Omlouváme se, stala se chyba při komunikaci. Opakujte akci znovu!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

