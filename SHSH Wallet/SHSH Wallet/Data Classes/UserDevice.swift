//
//  UserDevice.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import Foundation
import UIKit

class UserDevice{
    var modelID = ""
    var nickname = ""
    var boardID = ""
    var ecid = ""
    var image: UIImage!
    
    init(){
        
    }
    
    init(modelID: String, nickname: String, boardID: String, ecid: String, image: UIImage){
        self.modelID = modelID
        self.nickname = nickname
        self.boardID = boardID
        self.ecid = ecid
        self.image = image
    }
}
