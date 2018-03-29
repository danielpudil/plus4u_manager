//
//  IPAddress.swift
//  plus4u-manager
//
//  Created by Daniel Pudil on 29.03.18.
//  Copyright © 2018 Daniel Pudil. All rights reserved.
//

import Foundation

class IPAddress {
    
    var nameOfApp = "/plus4u-managerg01-main"
    var territory = "/00000000000000000000000000000000"
    var applicationWorkSpaceID = "-11111111111111111111111111111111"
    var typeOfUrl = "http:"
    
    func getCommandUri(command: String) -> String? {
        let nameCommand = "/\(command)"
        let ipAddress = "10.0.1.16"// self.getWiFiAddress() as! String
        
        return  "\(typeOfUrl)\(ipAddress):6221\(self.nameOfApp)\(self.territory)\(self.applicationWorkSpaceID)\(nameCommand)"
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}


