//
//  MyDevicesTableTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import CoreData

class MyDevicesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var devices: [Device] {
        get {
            return ((self.tabBarController!.viewControllers![0] as! UINavigationController).viewControllers.first as! SigningViewController).devices
        }
    }
    var myDevices:[UserDeviceMO] = []
    var fetchResultController: NSFetchedResultsController<UserDeviceMO>!
    var selectedRow = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<UserDeviceMO> = UserDeviceMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nickname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    myDevices = fetchedObjects
                    print("My Devices: "+String(myDevices.count))
                }
            }catch{
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDevices.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105//Choose your custom row height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyDeviceTableViewCell
        
        cell.nicknameLabel.text = myDevices[indexPath.row].nickname
        cell.deviceLabel.text = myDevices[indexPath.row].name
        if let deviceImage = UIImage(data: myDevices[indexPath.row].image!){
            cell.deviceImageView.image = deviceImage
        }else{
            cell.deviceImageView.image = UIImage(named: "placeholder")
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "showUserDevice", sender: self)
    }
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type:
        NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            } default:
                tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            myDevices = fetchedObjects as! [UserDeviceMO]
        }
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Delete Button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete", comment: "Delete Cell Action"), handler: { (action, indexPath) -> Void in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                let DeviceToDelete = self.myDevices[indexPath.row]
                context.delete(DeviceToDelete)
                
                appDelegate.saveContext()
            }
        })
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addDevice"{
            let destinationController = segue.destination as! UINavigationController
            let targetController = destinationController.topViewController as! AddDeviceTableViewController
            targetController.devices = devices
        }
        if segue.identifier == "showUserDevice"{
            let destinationController = segue.destination as! UserDeviceViewController
            destinationController.userDevice = myDevices[selectedRow]
        }
    }
    
    

}
