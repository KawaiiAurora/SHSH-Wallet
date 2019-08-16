//
//  SavedBlob.swift
//  SHSH Wallet
//
//  Created by Aurora on 16/08/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import Foundation
import ObjectMapper

class Blob: Mappable{
    var version: String?
    var time: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        version <- map["name"]
        time <- map["mtime"]
    }
}
