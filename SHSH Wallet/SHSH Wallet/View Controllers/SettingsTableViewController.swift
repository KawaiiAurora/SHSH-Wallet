//
//  SettingsTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 29/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import EasyTipView

class SettingsTableViewController: UITableViewController, EasyTipViewDelegate {
    
    @IBOutlet weak var saverSegmentedControl: UISegmentedControl!
    @IBOutlet weak var blobSaverButton: UIButton!
    var easyTipPrefs = EasyTipView.Preferences()

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
        
        //Configure Easy Tips
        
        easyTipPrefs.drawing.font = UIFont.systemFont(ofSize: 15.0)
        easyTipPrefs.drawing.foregroundColor = UIColor.black
        easyTipPrefs.drawing.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
        
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
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        //Do nothing
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
    
    @IBAction func showBlobSaverToolTip(){
        EasyTipView.show(animated: true, forView: blobSaverButton, withinSuperview: self.view, text: "1Conan's TSS Saver lets you save blobs for release versions of iOS (non-beta) on their server and has many features such as letting you download all blobs at once, save them to Dropbox/Google Drive among others. SHSH Host has a more modern feel and saves both release and beta blobs on their server but you can't download all blobs at once or save to a cloud service. Tap on this tooltip to dismiss", preferences: easyTipPrefs, delegate: self)
    }
}
