//
//  AddDeviceTableViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 13/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit
import CoreData
import EasyTipView

class AddDeviceTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, EasyTipViewDelegate{
    
    @IBOutlet var deviceTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var boardIDTextField: UITextField!
    @IBOutlet var ECIDTextField: UITextField!
    @IBOutlet var apNonceTextField: UITextField!
    @IBOutlet var deviceImageView: UIImageView!
    @IBOutlet var apnonceButton: UIButton!
    var devices: [Device]!
    var selectedDevice: Device!
    var myDevices = [UserDevice]()
    
    //Easy Tip View Prefs
    var easyTipPrefs = EasyTipView.Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let devices = SigningViewController.getDevices() else{
            print("ERROR GETTING DEVICES")
            let alert = UIAlertController(title: "Error", message: "Failed to load internal device array. Reload app and try again!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.devices = devices
        
        createPickerView()
        
        easyTipPrefs.drawing.font = UIFont.systemFont(ofSize: 15.0)
        easyTipPrefs.drawing.foregroundColor = UIColor.black
        easyTipPrefs.drawing.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
        
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        return 5
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
        }
        if let deviceImage = devices[row].image{
            deviceImageView.image = deviceImage
        }
        selectedDevice = devices[row]
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        //Do nothing
    }
    
    @IBAction func showToolTip(){
        EasyTipView.show(animated: true, forView: apnonceButton, withinSuperview: self.view, text: "An APNonce is a random string generated when you restore. You can choose whether to specify it on pre-A12 devices since blobs without an APNonce work on those. However, you MUST specify an APNonce for A12 devices if you want to get useable blobs. Tap on this tooltip to dismiss", preferences: easyTipPrefs, delegate: self)
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
        var apNonceVerified = false
        var allVerified = false
        
        if isTextFieldArrayAllNotEmpty(textFieldArray: textFieldArray){
            textFieldsVerified = true
        }else{
            let alertMessage = UIAlertController(title:"Oops", message: NSLocalizedString("A required field is blank! Please fill in all fields!", comment: "A required field is blank"), preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
        
        if(Constants.apNonceModels.contains(selectedDevice.modelID!)){
            if(isTextFieldEmpty(textfield: apNonceTextField)){
                apNonceVerified = false
                let alertMessage = UIAlertController(title:"Oops", message: NSLocalizedString("You must provide an APNonce as it's mandatory for A12+ devices!", comment: "A required field is blank"), preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
                return
            }else{
                apNonceVerified = true
            }
        }else{
            apNonceVerified = true
        }
        
        if(apNonceVerified && textFieldsVerified){
            allVerified = true
        }
        
        if allVerified{
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let userDevice = UserDeviceMO(context: appDelegate.persistentContainer.viewContext)
                userDevice.nickname = nicknameTextField.text!
                userDevice.modelID = selectedDevice.modelID!
                userDevice.boardID = boardIDTextField.text!
                userDevice.ecid = ECIDTextField.text!
                userDevice.name = selectedDevice.name!
                if(apNonceTextField.text! != ""){
                    userDevice.apnonce = apNonceTextField.text!
                }else{
                    print(apNonceTextField.text!)
                    userDevice.apnonce = apNonceTextField.text!
                }
                if let imageData = UIImagePNGRepresentation(selectedDevice.image!) {
                    userDevice.image = NSData(data: imageData) as Data
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
