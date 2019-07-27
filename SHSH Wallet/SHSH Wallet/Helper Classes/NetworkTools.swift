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
                print("Using Local Data")
                
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
            }
        })
        
        task.resume()
    }
    
    static func getDeviceImages(devices: [Device], offlineMode: Bool, completion: @escaping ()->Void){
        if(!offlineMode){
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 120.0
            sessionConfig.timeoutIntervalForResource = 120.0
            let session = URLSession(configuration: sessionConfig)
            
            for device in devices{
                let fullImageURLString = Constants.deviceImageAPI_URL + device.modelID! + ".png"
                
                if let fullImageURL = URL(string: fullImageURLString){
                    let request = URLRequest(url: fullImageURL)
                    let task = session.dataTask(with: request, completionHandler: {
                        (data, response, error) -> Void in
                        
                        if let error = error{
                            print(error)
                            device.image = UIImage(named: "placeholder")!
                        }else{
                        
                            if let data = data{
                                if let image = UIImage(data: data){
                                    device.image = image
                                }
                            }else{
                                device.image = UIImage(named: "placeholder")!
                            }
                        }
                    })
                    
                    task.resume()
                }
                else{
                    device.image = UIImage(named: "placeholder")!
                }
            }
        }else{
            for device in devices{
                device.image = UIImage(named: "placeholder")!
            }
        }
        
        completion()
    }
    
}
