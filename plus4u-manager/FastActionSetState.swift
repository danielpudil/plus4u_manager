//
//  FastActionSetState.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 30.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import Foundation

class SetState {
    
    func seStateCommand(state:String, activityUri:String) -> () {
        let state = state
        let uri = activityUri
        let firstCode: String = UserDefaults.standard.object(forKey: "firstCode") as! String
        let secondCode: String = UserDefaults.standard.object(forKey: "secondCode") as! String
        
        let address: String = IPAddress().getCommandUri(command: "setState")!
        
        let url = "\(address)?" + "code1=\(firstCode)"
            + "&code2=\(secondCode)"
            + "&activityUri=\(uri)"
            + "&activityStateType=\(state)"
            + "&comment="
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("error")
            }
            else {

            }
        }
        task.resume()
    }
}
