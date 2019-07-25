//
//  SaveBlobsViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 16/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import WebKit

class SaveBlobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    
    @IBOutlet var saveBlobsView: UIView!
    @IBOutlet var tableView: UITableView!
    let savingURL = URL(string: "https://tsssaver.1conan.com/")!
    //let savingURL = URL(string: "https://www.google.com/")!
    var webView: WKWebView!
    
    var userDevice:UserDeviceMO!
    var fields = ["ECID","Model ID","Board ID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        webView = WKWebView(frame: .zero)
        saveBlobsView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: saveBlobsView, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: saveBlobsView, attribute: .width, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: webView, attribute: .leftMargin, relatedBy: .equal, toItem: saveBlobsView, attribute: .leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: webView, attribute: .rightMargin, relatedBy: .equal, toItem: saveBlobsView, attribute: .rightMargin, multiplier: 1, constant: 0)
        let bottomContraint = NSLayoutConstraint(item: webView, attribute: .bottomMargin, relatedBy: .equal, toItem: saveBlobsView, attribute: .bottomMargin, multiplier: 1, constant: 0)
        saveBlobsView.addConstraints([height, width, leftConstraint, rightConstraint, bottomContraint])

        let request = URLRequest(url: savingURL)
        webView.load(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SingleDeviceTableViewCell
        
        switch indexPath.row{
        case 0:
            cell.fieldLabel.text = fields[indexPath.row]
            cell.valueLabel.text = userDevice.ecid
        case 1:
            cell.fieldLabel.text = fields[indexPath.row]
            cell.valueLabel.text = userDevice.modelID
        case 2:
            cell.fieldLabel.text = fields[indexPath.row]
            cell.valueLabel.text = userDevice.boardID
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
