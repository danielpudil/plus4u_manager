//
//  WebViewController.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 10.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var artifactUri = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let aParameter = artifactUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as! String
        
        let url = URL(string: "https://plus4u.net/ues/sesm?SessFree=" + aParameter)
        webView.loadRequest(URLRequest(url: url!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
