//
//  Network.swift
//  SHSH Wallet
//
//  Created by Aurora on 27/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class NetworkTools{
    
    static func getFirmwareData(localData: [ServerDataMO], completion: @escaping (Data?,String)->Void){
        var localDataAvailable = false
        
        guard let firmwareURL = URL(string: Constants.firmwareAPI_URL) else{
            completion(nil,"Bad URL")
            return
        }
        
        if(localData.count > 0){
            localDataAvailable = true
        }
        
        //Creating session with 2 minute timeout
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url: firmwareURL)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let error = error{
                print("ERROR: \(error)")
                
                if(localDataAvailable){
                    if let firmwareData = localData[0].firmwareJSON{
                        print("Returning Local Firmware Data...")
                        completion(firmwareData,"Local Data")
                    }else{
                        print("Local Firmware Data Is Bad...")
                        completion(nil,"Bad Local Data")
                    }
                }else{
                    print("No Local Firmware Data Was Found...")
                    completion(nil,"No Local Data")
                }
                return
            }
            
            if let data = data{
                //Updating Local Firmware JSON File
                DispatchQueue.main.async {
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        if(localData.count > 0){
                            let serverData = localData[0]
                            serverData.firmwareJSON = data
                            print("Updating local firmware JSON file...")
                            appDelegate.saveContext()
                        }
                        else{
                            let serverData = ServerDataMO(context: appDelegate.persistentContainer.viewContext)
                            serverData.firmwareJSON = data
                            print("Saving firmware JSON to context for first time...")
                            appDelegate.saveContext()
                        }
                    }
                    
                    //If it got till here, the data is fine and the firmware JSON file can be returned
                    completion(data,"Online Data")
                    return
                }
            }
            else{
                print("Bad Downloaded Data")
                if(localDataAvailable){
                    if let firmwareData = localData[0].firmwareJSON{
                        print("Returning Local Firmware Data...")
                        completion(firmwareData,"Local Data")
                    }else{
                        print("Local Firmware Data Is Bad...")
                        completion(nil,"Bad Local Data")
                    }
                }else{
                    print("No Local Firmware Data Was Found...")
                    completion(nil,"No Local Data")
                }
                return
            }
        })
        
        task.resume()
    }
    
    static func getDeviceImages(devices: [Device], offlineMode: Bool, completion: @escaping ()->Void){
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        let session = URLSession(configuration: sessionConfig)
            
        let imageGroup = DispatchGroup()
            
        for device in devices{
            imageGroup.enter()
            getDeviceImage(device: device, offlineMode: offlineMode, session: session, completion: {
                () in
                imageGroup.leave()
            })
        }
        
        imageGroup.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            completion()
        })
    }
    
    static func getDeviceImage(device: Device, offlineMode: Bool, session: URLSession, completion: @escaping ()->Void){
        if(!offlineMode){
            let fullImageURLString = Constants.deviceImageAPI_URL + device.modelID! + ".png"
            
            if let fullImageURL = URL(string: fullImageURLString){
                let request = URLRequest(url: fullImageURL)
                let task = session.dataTask(with: request, completionHandler: {
                    (data, response, error) -> Void in
                    
                    if let error = error{
                        print(error)
                        device.image = UIImage(named: "placeholder")!
                        completion()
                    }else{
                        
                        if let data = data{
                            if let image = UIImage(data: data){
                                device.image = image
                                completion()
                            }
                        }else{
                            device.image = UIImage(named: "placeholder")!
                            completion()
                        }
                    }
                })
                
                task.resume()
            }
            else{
                device.image = UIImage(named: "placeholder")!
                completion()
            }
        }else{
            device.image = UIImage(named: "placeholder")!
            completion()
        }
    }
}
