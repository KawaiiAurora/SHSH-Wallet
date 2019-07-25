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
    let apiURL = "https://api.ipsw.me/v2.1/firmwares.json"
    let imageapiURL = "https://ipsw.me/api/images/500x/assets/images/devices/"
    var devices = [Device]()
    var selectedIndex = 0
    var localData:[ServerDataMO] = []
    var alert = UIAlertController(title: "SHSH Wallet", message: "Application is loading. Please wait", preferredStyle: .alert)
    var offlineMode = false
    
    var fetchResultController: NSFetchedResultsController<ServerDataMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    /*for x in 1...localData.count-1{
                        print(x)
                        context.delete(localData[x])
                    }*/
                    //appDelegate.saveContext()
                    print("Local Data: "+String(self.localData.count))
                }
            }catch{
                print(error)
            }
        }
        
        getData()
        // Do any additional setup after loading the view, typically from a nib.
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

    func getData(){
        self.present(self.alert, animated: true)
        guard let firmwareURL = URL(string: apiURL) else{
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url: firmwareURL)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            
            
            
            if let error = error{
                print("ERROR: ")
                print(error)
                print("Using Local Data")
                
                if(self.localData.count > 0){
                    OperationQueue.main.addOperation{
                        self.alert.title = "Warning: No Internet Connection"
                        self.alert.message = "Local data will be used. It may be out of date! Images won't load"
                        self.offlineMode = true
                    }
                    self.parseDeviceData(data: self.localData[0].firmwareJSON!)
                }else{
                    print("TRIGGERED")
                    //self.alert = UIAlertController(title: "Error: No Internet Connection", message: "No Local Data Has Been Found. Please open the application at least once with a working internet connection to download files", preferredStyle: .alert)
                    OperationQueue.main.addOperation{
                        self.alert.title = "Error: No Internet Connection"
                        self.alert.message = "No Local Data Has Been Found. Please open the application at least once with a working internet connection to download files"
                    }
                    //self.alert.dismiss(animated: true, completion: nil)
                    //self.present(self.alert, animated: true)
                }
                
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
                
                return
            }
            
            //Parsing
            
            guard let data = data else{
                print("?")
                return
            }
            
            DispatchQueue.main.async {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    if(self.localData.count > 0){
                        let serverData = self.localData[0]
                        serverData.firmwareJSON = data
                        print("Saving firmware JSON to context...")
                        appDelegate.saveContext()
                    }
                    else{
                        let serverData = ServerDataMO(context: appDelegate.persistentContainer.viewContext)
                        serverData.firmwareJSON = data
                        print("Saving firmware JSON to context...")
                        appDelegate.saveContext()
                    }
                }
            }
            
            
            
            
            DispatchQueue.main.sync{
                self.parseDeviceData(data: data)
            }
            
            //self.alert.dismiss(animated: true, completion: nil)
            
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
            
        })
        
        task.resume()
    }
    
    func parseDeviceData(data: Data){
        print("DATA RECEIVED")
        
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

            /*for deviceName in deviceNameArray{
                guard let tempDeviceDict = devicesDict[deviceName] as? [String: Any] else{
                    print("Bad Single Device Dict")
                    return
                }
                guard let tempDevice = Mapper<Device>().map(JSON: tempDeviceDict) else{
                    print("BAD Device MAP")
                    return
                }
                tempDevice.modelID = deviceName
                //Finding image
                getDeviceImage(deviceName: deviceName, device: tempDevice)
                devices.append(tempDevice)
            }*/
            
            for x in 0...deviceNameArray.count-1{
                guard let tempDeviceDict = devicesDict[deviceNameArray[x]] as? [String: Any] else{
                    print("Bad Single Device Dict")
                    return
                }
                guard let tempDevice = Mapper<Device>().map(JSON: tempDeviceDict) else{
                    print("BAD Device MAP")
                    return
                }
                tempDevice.modelID = deviceNameArray[x]
                //Finding image
                if x != deviceNameArray.count-1{
                    getDeviceImage(deviceName: deviceNameArray[x], device: tempDevice, lastOne: false, offlineMode: self.offlineMode)
                    print("DONE")
                }else{
                    getDeviceImage(deviceName: deviceNameArray[x], device: tempDevice, lastOne: true, offlineMode: self.offlineMode)
                }
                
                devices.append(tempDevice)
                
                if x == deviceNameArray.count-1{
                    print("DONE")
                }
            }
            
            devices = devices.sorted(by: {$0.name! < $1.name!})//Sorting devices in ascending order
            
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
        }catch{
            print("Sorry, no error handling yet!")
        }
    }
    
    func getDeviceImage(deviceName: String, device: Device, lastOne: Bool, offlineMode: Bool){
        
        if(!offlineMode){
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 120.0
            sessionConfig.timeoutIntervalForResource = 120.0
            let session = URLSession(configuration: sessionConfig)
        
            let fullImageURLString = imageapiURL + deviceName + ".png"
            guard let fullImageURL = URL(string: fullImageURLString) else{
                device.image = UIImage(named: "placeholder")!
                return
            }
        
            let request = URLRequest(url: fullImageURL)
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                
                if let error = error{
                    print(error)
                    device.image = UIImage(named: "placeholder")!
                    if(lastOne){
                        self.alert.dismiss(animated: true, completion: nil)
                    }
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                    return
                }
                
                //Parsing
                
                guard let data = data else{
                    device.image = UIImage(named: "placeholder")!
                    if(lastOne){
                        self.alert.dismiss(animated: true, completion: nil)
                    }
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                    return
                }
                
                let image = UIImage(data: data)
                OperationQueue.main.addOperation {
                    device.image = image
                    self.collectionView.reloadData()
                    if(lastOne){
                        self.alert.dismiss(animated: true, completion: nil)
                    }
                }
                
            })
        
            task.resume()
        }else{
            device.image = UIImage(named: "placeholder")!
            if(lastOne){
                let offlineAlert = UIAlertController(title: "Warning: No Internet Connection", message: "Local data will be used. It may be out of date! Images won't load", preferredStyle: .alert)
                offlineAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.alert.dismiss(animated: true, completion: nil)
                self.present(offlineAlert, animated: true)
            }
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
            return
        }
        
        
        
        
    }
}

