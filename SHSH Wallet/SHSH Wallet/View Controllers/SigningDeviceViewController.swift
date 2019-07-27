//
//  ViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 12/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper

class SigningViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var devices = [Device]()
    var selectedIndex = 0
    var localData:[ServerDataMO] = []
    var alert = UIAlertController(title: "SHSH Wallet", message: "Application is loading. Please wait", preferredStyle: .alert)
    
    var fetchResultController: NSFetchedResultsController<ServerDataMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        present(alert, animated: true, completion: nil)
        //var firmwareJSONData: Data?
        
        //Get Local Data
        loadLocalData()
        
        //Getting Network Data and then moving on to parsing the data
        NetworkTools.getFirmwareData(localData: localData, completion: { (firmwareJSONData, status) in
            if(status == "Online Data" || status == "Local Data") {
                var offlineMode = false
                
                if(status == "Local Data"){
                    self.navigationItem.prompt = "Local Data is being used. No Images will be provided"
                    offlineMode = true
                }
                
                if let firmwareJSONData = firmwareJSONData{
                    self.parseDeviceData(data: firmwareJSONData, offlineMode: offlineMode, completion: { () in
                        //Reload data before returning
                        OperationQueue.main.addOperation {
                            print("Reloading")
                            self.collectionView.reloadData()
                            self.alert.dismiss(animated: true, completion: nil)
                        }
                    })
                }else{
                    print("ERROR")
                }
            }else if(status == "No Local Data"){
                self.alert.message = "No Local Data was found. Please open the application successfully at least once!"
            }else{
                self.alert.message = "An error has occured. Please try again"
                print(status)
            }
        }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SigningCollectionViewCell
        
        cell.nameLabel.text = devices[indexPath.item].name
        if let image = devices[indexPath.item].image{
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        performSegue(withIdentifier: "showDevice", sender: collectionView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDevice"{
            let destinationController = segue.destination as! DeviceInfoViewController
            destinationController.device = devices[selectedIndex]
        }
    }
    
    //Get Local Data
    func loadLocalData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ServerDataMO> = ServerDataMO.fetchRequest()
            fetchRequest.sortDescriptors = []
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            do{
                try self.fetchResultController.performFetch()
                if let fetchedObjects = self.fetchResultController.fetchedObjects{
                    self.localData = fetchedObjects
                    print("OFFLINE DATA GET")
                    print("Local Data: "+String(self.localData.count))
                }
            }catch{
                print(error)
            }
        }
    }
    
    func parseDeviceData(data: Data, offlineMode: Bool, completion: @escaping ()->Void){
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let initialDict = json as? [String: Any] else{
                print("Bad Initial Dictionary")
                return
            }
            
            guard let devicesDict = initialDict["devices"] as? [String: Any] else{
                print("Bad Device Dictionary")
                return
            }
            
            var deviceNameArray = [String]()
            
            for deviceName in devicesDict.keys{
                deviceNameArray.append(deviceName)
            }//Getting name of all devices in dictionary keys
            
            //Adding all devices to main device array from JSON
            for deviceName in deviceNameArray{
                guard let tempDeviceDict = devicesDict[deviceName] as? [String: Any] else{
                    print("Bad Single Device Dict")
                    return
                }
                guard let tempDevice = Mapper<Device>().map(JSON: tempDeviceDict) else{
                    print("BAD Device MAP")
                    return
                }
                //Adding Model ID to device object
                tempDevice.modelID = deviceName
                
                devices.append(tempDevice)
            }
            
            //Getting Images of parsed devices
            let imageGroup = DispatchGroup()
            imageGroup.enter()
                
            NetworkTools.getDeviceImages(devices: devices, offlineMode: offlineMode, completion: { () in
                    print("Images are Done")
                    imageGroup.leave()
                })
            
            
            
            //Sort device array
            devices = devices.sorted(by: {$0.name! < $1.name!})
            
            //Appending firmwares per device
            for device in devices{
                for firmware in device.firmwaresDict!{
                    guard let tempFirmware = Mapper<Firmware>().map(JSON: firmware) else{
                        print("BAD FIRMWARE MAP")
                        return
                    }
                    device.firmwares.append(tempFirmware)
                }
            }
            
            completion()
        }catch{
            print("Sorry, no error handling yet!")
        }
    }
    
}
