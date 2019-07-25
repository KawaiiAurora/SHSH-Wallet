//
//  SingleDeviceTableViewCell.swift
//  SHSH Wallet
//
//  Created by Aurora on 14/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class SingleDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueLabel: SRCopyableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
