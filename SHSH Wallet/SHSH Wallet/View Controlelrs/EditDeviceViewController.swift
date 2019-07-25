//
//  EditDeviceTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import CoreData

class EditDeviceTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var deviceTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var boardIDTextField: UITextField!
    @IBOutlet var ECIDTextField: UITextField!
    @IBOutlet var deviceImageView: UIImageView!
    var devices: [Device]!
    var selectedDevice: Device!
    var deviceBeingEdited: UserDeviceMO!
    var myDevices = [UserDevice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceTextField.text = deviceBeingEdited.name! + " ("+deviceBeingEdited.modelID!+")"
        nicknameTextField.text = deviceBeingEdited.nickname
        boardIDTextField.text = deviceBeingEdited.boardID
        ECIDTextField.text = deviceBeingEdited.ecid
        if let deviceImage = UIImage(data: deviceBeingEdited.image!){
            deviceImageView.image = deviceImage
        }else{
            deviceImageView.image = UIImage(named: "placeholder")
        }
        
        
        createPickerView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return devices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let deviceName = devices[row].name, let deviceModelID = devices[row].modelID{
            return deviceName + " ("+deviceModelID+")"
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let deviceName = devices[row].name, let deviceModelID = devices[row].modelID{
            deviceTextField.text = deviceName + " ("+deviceModelID+")"
        }
        if let deviceBoardID = devices[row].boardConfig{
            boardIDTextField.text = deviceBoardID
            print(deviceBoardID)
        }
        if let deviceImage = devices[row].image{
            deviceImageView.image = deviceImage
        }
        selectedDevice = devices[row]
    }
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        deviceTextField.inputView = pickerView
        
        //Creating Toolbar + Done Button in PickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        deviceTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func doneButton(){
        let textFieldArray = [deviceTextField, nicknameTextField, boardIDTextField, nicknameTextField]
        
        var textFieldsVerified = false
        
        if isTextFieldArrayAllNotEmpty(textFieldArray: textFieldArray){
            textFieldsVerified = true
        }else{
            let alertMessage = UIAlertController(title:"Oops", message: NSLocalizedString("A required field is blank! Please fill in all fields!", comment: "A required field is blank"), preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        if textFieldsVerified{
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                deviceBeingEdited.nickname = nicknameTextField.text!
                if let deviceChanged = selectedDevice{
                    deviceBeingEdited.modelID = deviceChanged.modelID!
                }//Only run if device has been changed
                deviceBeingEdited.boardID = boardIDTextField.text!
                deviceBeingEdited.ecid = ECIDTextField.text!
                if let deviceChanged = selectedDevice{
                    deviceBeingEdited.name = deviceChanged.name!
                }
                if let deviceChanged = selectedDevice{
                    if let imageData = UIImagePNGRepresentation(deviceChanged.image!) {
                        deviceBeingEdited.image = NSData(data: imageData) as Data
                    }
                }
                print("Saving data to context ...")
                appDelegate.saveContext()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    func isTextFieldEmpty(textfield: UITextField) -> Bool{
        var result:Bool!
        
        if(textfield.text == ""){
            result = true
        }
        else{
            result = false
        }
        
        return result
    }
    
    func isTextFieldArrayAllNotEmpty(textFieldArray: [UITextField?]) -> Bool{
        var individualResult = false
        var result = true
        
        var counter = 0
        
        while (counter < textFieldArray.count) && (result == true){
            individualResult = isTextFieldEmpty(textfield: textFieldArray[counter]!)
            if(individualResult == true){
                result = false
            }
            counter += 1
        }
        
        return result
    }
    
}

