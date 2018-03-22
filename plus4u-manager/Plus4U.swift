//
//  Plus4U.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 03.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import Foundation

class Plus4U {
    let name:String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String:Any)
    }
    
    init(json:[String:Any]) throws {
        guard  let name = json["name"] as? String else {throw SerializationError.missing("name is missing")}
        
        self.name = name
    }
    
    static let basePath = "http://localhost:6221/plus4u-managerg01-main/00000000000000000000000000000000-11111111111111111111111111111111/test"
    
    
    static func forecast (completion: @escaping ([Plus4U]) -> ()) {
        let url = basePath
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var personsArray:[Plus4U] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        
                            if let persons = json["persons"] as? [[String:Any]] {
                                for person in persons {
                                    if let personObject = try? Plus4U(json: person) {
                                        personsArray.append(personObject)
                                    }
                                }
                            }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                completion(personsArray)
            }
        }
        task.resume()
    }
}
