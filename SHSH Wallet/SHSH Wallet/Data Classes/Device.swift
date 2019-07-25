//
//  Device.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import Foundation
import ObjectMapper

class Device: Mappable{
    
    var name: String?
    var boardConfig: String?
    var platform: String?
    var firmwaresDict: [[String:Any]]?
    var firmwares = [Firmware]()
    var image: UIImage?
    var modelID: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        boardConfig <- map["BoardConfig"]
        platform <- map["platform"]
        firmwaresDict <- map["firmwares"]
    }
    
}
