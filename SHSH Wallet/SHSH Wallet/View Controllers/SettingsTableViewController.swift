//
//  SettingsTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 29/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var saverSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let saverPreference = UserDefaults.standard.string(forKey: "saverPreference"){
            if(saverPreference == "1Conan"){
                saverSegmentedControl.selectedSegmentIndex = 0
            }
            else if(saverPreference == "SHSH_Host"){
                saverSegmentedControl.selectedSegmentIndex = 1
            }else{
                saverSegmentedControl.selectedSegmentIndex = 0
            }
        }else{
           saverSegmentedControl.selectedSegmentIndex = 0
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch saverSegmentedControl.selectedSegmentIndex
        {
        case 0:
            //1Conan
            UserDefaults.standard.set("1Conan", forKey: "saverPreference")
        case 1:
            //SHSH.Host
            UserDefaults.standard.set("SHSH_Host", forKey: "saverPreference")
        default:
            break
        }
    }
}
