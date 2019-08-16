//
//  SavedBlobsTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 16/08/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import ObjectMapper

class SavedBlobsTableViewController: UITableViewController {
    
    var userDevice: UserDeviceMO!
    var savedBlobs = [Blob]()
    let alert = UIAlertController(title: "SHSH Wallet", message: "Saved Blob list is loading. Please wait", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        present(alert, animated: true, completion: nil)
        
        NetworkTools.getSavedBlobData(ecid: userDevice.ecid!) { (jsonData, status) in
            print(status)
            if(status == "Good Data"){
                self.parseSavedBlobData(data: jsonData!, completion: {
                    print("Saved Blobs: "+String(self.savedBlobs.count))
                    if(self.savedBlobs.count > 0){
                        self.tableView.reloadData()
                        self.alert.dismiss(animated: true, completion: nil)
                    }else{
                        self.alert.message = "You have no blobs saved. Please save some blobs then try again!"
                        self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                    }
                }
                )
            }else{
                self.alert.message = "An Error Occurred. Please try again later!"
                self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                }))
            }
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedBlobs.count
    }
    
    func parseSavedBlobData(data: Data, completion: @escaping () -> Void){
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let initialArray = json as? [Any] else{
                print("Bad Initial Array")
                return
            }
            
            for blob in initialArray{
                guard let blobDict = blob as? [String:Any] else{
                    print("Bad Blob Dict")
                    return
                }
                guard let tempBlob = Mapper<Blob>().map(JSON: blobDict) else{
                    print("Bad Blob")
                    return
                }
                
                savedBlobs.append(tempBlob)
            }
            
            completion()
            return
        }catch{
            completion()
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedBlobsTableViewCell
        
        cell.versionLabel.text = "iOS "+savedBlobs[indexPath.row].version!
        
        return cell
    }
}
