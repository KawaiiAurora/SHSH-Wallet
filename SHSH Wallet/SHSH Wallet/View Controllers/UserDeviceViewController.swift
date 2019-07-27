//
//  SingleDeviceViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 14/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class UserDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var deviceImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var userDevice: UserDeviceMO!
    var devices: [Device] {
        get {
            return ((self.tabBarController!.viewControllers![0] as! UINavigationController).viewControllers.first as! SigningViewController).devices
        }
    }
    
    var fields = ["ECID","Model ID","Board ID","APNonce"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let deviceImage = UIImage(data: userDevice.image!){
            deviceImageView.image = deviceImage
        }else{
            deviceImageView.image = UIImage(named: "placeholder")
        }
        
        nicknameLabel.text = userDevice.nickname
        typeLabel.text = userDevice.name
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(isViewLoaded){
            tableView.reloadData()
            
            if let deviceImage = UIImage(data: userDevice.image!){
                deviceImageView.image = deviceImage
            }else{
                deviceImageView.image = UIImage(named: "placeholder")
            }
            
            nicknameLabel.text = userDevice.nickname
            typeLabel.text = userDevice.name
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userDevice.apnonce != nil && userDevice.apnonce != ""){
            return fields.count
        }else{
            return fields.count-1
        }
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
            case 3:
            cell.fieldLabel.text = fields[indexPath.row]
            cell.valueLabel.text = userDevice.apnonce
            default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSaveBlobs"{
            let destination = segue.destination as! SaveBlobsViewController
            destination.userDevice = userDevice
        }
        else if segue.identifier == "showEditDevice"{
            let destinationController = segue.destination as! UINavigationController
            let targetController = destinationController.topViewController as! EditDeviceTableViewController
            targetController.deviceBeingEdited = userDevice
            targetController.devices = devices
        }
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
