//
//  Firmware.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import Foundation
import ObjectMapper

class Firmware: Mappable{
    var version: String?
    var buildID: String?
    var size: CLong?
    var releaseDate: String?
    var uploadDate: String?
    var url: String?
    var signed: Bool?
    var filename: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        version <- map["version"]
        buildID <- map["buildid"]
        size <- map["size"]
        releaseDate <- map["releasedate"]
        uploadDate <- map["uploaddate"]
        url <- map["url"]
        signed <- map["signed"]
        filename <- map["filename"]
    }
}
