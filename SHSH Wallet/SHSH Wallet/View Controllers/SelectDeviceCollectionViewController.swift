//
//  SelectDeviceCollectionViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 29/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData

private let reuseIdentifier = "Cell"

class SelectDeviceCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    static private var devices = [Device]()
    var deviceTypeImages = [UIImage]()
    var loaded = false
    let alert = UIAlertController(title: "SHSH Wallet", message: "Application is loading. Please wait", preferredStyle: .alert)
    
    var fetchResultController: NSFetchedResultsController<ServerDataMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        present(alert, animated: true, completion: nil)
        
        let localData = loadLocalData()
        
        //Getting Network Data and then moving on to parsing the data
        NetworkTools.getFirmwareData(localData: localData!, completion: { (firmwareJSONData, status) in
            if(status == "Online Data" || status == "Local Data") {
                var offlineMode = false
                
                if(status == "Local Data"){
                    self.navigationItem.prompt = "Local Data is being used. No Images will be provided"
                    offlineMode = true
                }
                
                if let firmwareJSONData = firmwareJSONData{
                    self.parseDeviceData(data: firmwareJSONData, offlineMode: offlineMode, completion: { () in
                        //Reload data before returning
                        print("OK")
                        self.fillDeviceTypeImageArray(devicesModelID: Constants.deviceTypesImageModels, devicesArray: SelectDeviceCollectionViewController.devices)
                        OperationQueue.main.addOperation {
                            print("Reloading")
                            self.loaded = true
                            self.collectionView!.reloadData()
                            self.alert.dismiss(animated: true, completion: nil)

                        }
                    })
                }else{
                    self.alert.message = "An error has occured. Please try again"
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(!loaded){
            return 0
        }else{
            return Constants.deviceTypes.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectDeviceCollectionViewCell
        
        cell.deviceTypeLabel.text = Constants.deviceTypes[indexPath.row]
        cell.deviceTypeImageView.image = deviceTypeImages[indexPath.row]
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSigningStatus", sender: indexPath.row)
    }
    
    func loadLocalData() -> [ServerDataMO]!{
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ServerDataMO> = ServerDataMO.fetchRequest()
            fetchRequest.sortDescriptors = []
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            do{
                try self.fetchResultController.performFetch()
                if let fetchedObjects = self.fetchResultController.fetchedObjects{
                    print("OFFLINE DATA GET")
                    print("Local Data: "+String(fetchedObjects.count))
                    return fetchedObjects
                }
            }catch{
                print(error)
            }
        }
        return []
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
                
                SelectDeviceCollectionViewController.devices.append(tempDevice)
            }
            
            //Sort device array
            SelectDeviceCollectionViewController.devices = SelectDeviceCollectionViewController.devices.sorted(by: {$0.name! < $1.name!})
            
            //Appending firmwares per device
            for device in SelectDeviceCollectionViewController.devices{
                for firmware in device.firmwaresDict!{
                    guard let tempFirmware = Mapper<Firmware>().map(JSON: firmware) else{
                        print("BAD FIRMWARE MAP")
                        return
                    }
                    device.firmwares.append(tempFirmware)
                }
            }
            
            //Getting Images of parsed devices
            NetworkTools.getDeviceImages(devices: SelectDeviceCollectionViewController.devices, offlineMode: offlineMode, completion: { () in
                print("Images are Done")
                completion()
                return
            })
        }catch{
            print("Sorry, no error handling yet!")
        }
    }
    
    func findDeviceImageIndex(deviceModel: String, in: [Device]) -> Int?{
        var findIndex = 0
        
        for device in SelectDeviceCollectionViewController.devices{
            if(device.modelID == deviceModel){
                return findIndex
            }
            findIndex+=1
        }
        print("Loop Over, Device Type Image Not Found")
        return nil
    }
    
    func fillDeviceTypeImageArray(devicesModelID: [String], devicesArray: [Device]){
        for deviceModelID in devicesModelID{
            if let indexFoundAt = findDeviceImageIndex(deviceModel: deviceModelID, in: devicesArray){
                if let image = devicesArray[indexFoundAt].image{
                    deviceTypeImages.append(image)
                }
            }
        }
    }
    
    func getStreamlinedDeviceArray(deviceType: String) -> [Device]!{
        var deviceArray = [Device]()
        for device in SelectDeviceCollectionViewController.devices{
            if((device.modelID?.contains(deviceType))!){
                if let rawFilterArray = UserDefaults.standard.array(forKey: "filteredDevices"){
                    if let filterArray = rawFilterArray as? [String]{
                        if(!filterArray.contains(device.name!)){
                            deviceArray.append(device)
                        }//else skip device
                    }else{
                       deviceArray.append(device)
                    }
                }else{
                    deviceArray.append(device)
                }
            }
        }
        print("Loop Over, Device Type Image Not Found")
        
        
        return deviceArray
    }
    
    static func getDevices() -> [Device]?{
        return devices
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSigningStatus"{
            let destinationController = segue.destination as! SigningViewController
            if let index = sender as? Int{
                destinationController.devices = getStreamlinedDeviceArray(deviceType: Constants.deviceTypesModels[index])
            }else{
                destinationController.devices = SelectDeviceCollectionViewController.devices
            }
        }
    }
}

extension SelectDeviceCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2.1, height: 150.0)
    }
}
