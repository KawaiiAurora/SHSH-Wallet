//
//  DeviceInfoViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var deviceImageView: UIImageView!
    @IBOutlet var deviceNameLabel: UILabel!
    var device: Device!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceNameLabel.text = device.name!
        deviceImageView.image = device.image!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return device.firmwares.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FirmwareTableViewCell
        
        if indexPath.row == 0{
            cell.versionLabel.text = "Version"
            cell.dateLabel.text = "Release Date"
            cell.signedLabel.text = "Signed?"
        }else{
            let index = indexPath.row - 1
            let firmware = device.firmwares[index]
            //Configure the cell...
            if let version = firmware.version, let buildID = firmware.buildID{
                cell.versionLabel.text = "iOS "+version+" ("+buildID+")"
            }
            if let releaseDate = firmware.releaseDate{
                //Nuking the T in the date string
                if let tIndex = releaseDate.index(of: "T"){
                    var date = String(releaseDate.prefix(upTo: tIndex))
                    date = date.replacingOccurrences(of: "-", with: "/")
                    cell.dateLabel.text = date
                }
            }
            else if let uploadDate = firmware.uploadDate{
                if let tIndex = uploadDate.index(of: "T"){
                    var date = String(uploadDate.prefix(upTo: tIndex))
                    date = date.replacingOccurrences(of: "-", with: "/")
                    cell.dateLabel.text = date + "*"
                }
            }
            else{
                cell.dateLabel.text = "N/A"
            }
            if let signed = firmware.signed{
                cell.signedLabel.text = (signed) ? "YES ✅" : "NO ❌"
            }
        }
        
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    

}
