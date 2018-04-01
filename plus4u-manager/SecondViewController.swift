//
//  SecondViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 02.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var findPersonButton: UIButton!
    @IBOutlet weak var findPersonText: UITextField!
    @IBOutlet weak var underline1: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        underline1.layer.shadowOpacity = 0.5
        underline1.layer.shadowOffset = CGSize(width: 3, height: 3)
        underline1.layer.shadowRadius = 5.0
        underline1.layer.shadowColor = UIColor.darkGray.cgColor
        
        findPersonButton.layer.shadowOpacity = 0.5
        findPersonButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        findPersonButton.layer.shadowRadius = 5.0
        findPersonButton.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.findPersonText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func findPerson(_ sender: UIButton) {
        if (findPersonText.text != "") {
            performSegue(withIdentifier: "go", sender: self)
        }
        else {
            self.callFailed()
        }
    }
    
    func callFailed() {
        let alert = UIAlertController(title: "Upozornění", message: "Pro nalezení uživatele musí být zadáno jméno!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let personName: String = (findPersonText.text )!
        let destVS = segue.destination as! PeopleViewController
        
        destVS.personName = personName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findPersonText.resignFirstResponder()
        return (true)
    }
}

