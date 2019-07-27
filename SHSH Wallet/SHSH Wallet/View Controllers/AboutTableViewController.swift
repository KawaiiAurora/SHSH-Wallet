//
//  AboutTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 17/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    @IBAction func twitterButton(){
        let twitterURL = URL(string: "https://twitter.com/KawaiiAuroraA")
        let safariView = SFSafariViewController(url: twitterURL!)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func apiButton(){
        let apiURL = URL(string: "https://ipsw.me/api/ios/docs/2.1/Firmware")
        let safariView = SFSafariViewController(url: apiURL!)
        self.present(safariView, animated: true, completion: nil)
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
}
