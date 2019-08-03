//
//  MoreCreditsTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 29/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import SafariServices

class MoreCreditsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    @IBAction func copiableLabelButton(){
        let apiURL = URL(string: "https://stephenradford.me/make-uilabel-copyable/")
        let safariView = SFSafariViewController(url: apiURL!)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func shshSigningButton(){
        let apiURL = URL(string: "https://tsssaver.1conan.com/")
        let safariView = SFSafariViewController(url: apiURL!)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func toolTipsButton(){
        let apiURL = URL(string: "https://github.com/teodorpatras/EasyTipView")
        let safariView = SFSafariViewController(url: apiURL!)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func filterIconButton(){
        let apiURL = URL(string: "https://www.flaticon.com/free-icon/filter_107799")
        let safariView = SFSafariViewController(url: apiURL!)
        self.present(safariView, animated: true, completion: nil)
    }
}
