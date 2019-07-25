//
//  MyDeviceTableViewCell.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class MyDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var deviceLabel: UILabel!    
    @IBOutlet var deviceImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
