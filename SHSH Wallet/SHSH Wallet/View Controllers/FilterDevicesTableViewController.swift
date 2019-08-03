//
//  FilterDevicesTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 03/08/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

class FilterDevicesTableViewController: UITableViewController {
    
    var devices:[Device]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let devices = SelectDeviceCollectionViewController.getDevices() else{
            print("ERROR GETTING DEVICES")
            let alert = UIAlertController(title: "Error", message: "Failed to load internal device array. Reload app and try again!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.devices = devices
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = devices[indexPath.row].name!
        
        if let rawFilterArray = UserDefaults.standard.array(forKey: "filteredDevices"){
            if let filterArray = rawFilterArray as? [String]{
                cell.accessoryType = filterArray.contains(devices[indexPath.row].name!) ? .checkmark : .none
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let rawFilterArray = UserDefaults.standard.array(forKey: "filteredDevices"){
            if var filterArray = rawFilterArray as? [String]{
                print("Reading from existing array")
                if(filterArray.contains(devices[indexPath.row].name!)){
                    filterArray.removeAll { (name) -> Bool in
                        name == devices[indexPath.row].name!
                    }
                }else{
                    filterArray.append(devices[indexPath.row].name!)
                }
                //Save Changes
                UserDefaults.standard.set(filterArray, forKey: "filteredDevices")
            }
        }else{
            //Creating new filter array array
            print("New Array")
            let filterArray = [devices[indexPath.row].name!]
            UserDefaults.standard.set(filterArray, forKey: "filteredDevices")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func resetDevices(){
        //Feeding Empty Array
        let filterArray = [String]()
        UserDefaults.standard.set(filterArray, forKey: "filteredDevices")
        
        let alert = UIAlertController(title: "Reset Filtered Devices", message: "All filtered devices have been cleared", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        present(alert, animated: true)
        
        tableView.reloadData()
    }
    
    @IBAction func doneButton(){
        dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
