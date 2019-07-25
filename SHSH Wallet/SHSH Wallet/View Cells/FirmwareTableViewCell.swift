//
//  FirmwareTableViewCell.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class FirmwareTableViewCell: UITableViewCell {
    
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var signedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
