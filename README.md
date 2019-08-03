# SHSH-Wallet
An iOS Application that makes saving SHSH Blobs much easier!

Description: SHSH Wallet is an application that unifies most iOS signing-related needs for regular end-users. It is available for both jailbreak and non-jailbroken iOS devices since it comes in IPA form.

Main Features:
* Checking Signing Status of Release builds of iOS (no Betas, sorry) thanks to ipsw.me's API
* Add your devices to the 'My Devices' page to keep track of your devices and save SHSH blobs for them. You are to include the Board ID and ECID among other details so that you can find them later when you want to save blobs
* The ability to save blobs for saved devices through 1Conan. The screen in which you save blobs also has the required information (which is copiable) you are to enter into 1Conan so that saving blobs only takes a few seconds
* Limited Offline Functionality (Must've opened it succesfully at least once)

Things To Look At:
* Implement proper fakesigning but there's the DEB for now 
* Add ability to specify a device-specific nonce which is essential for saving blobs of A12 devices [x]
* In the 'Signing Status' Tab, sort the devices by the type so you don't have to scroll through the whole list of devices to get to your device [x]
* Implement a Search Device feature so you can easily find the device of your choice [x]
* Feature to be able to check which blobs you have saved
* Add notifications for when ipsw.me's firmware.json file is changed. This usually happens when a new firmware is released.
* Add some information about what blobs are and how to save them
* Add SHSH.Host a blob saving website [x]
* Auto-saving of blobs (no promises on this)
* Ability to filter out devices you don't care about [x]
* Beta support maybe? [x - Can be done via SHSH.Host]

Note: Just because I said I'll look at them, doesn?t mean they?ll be implemented anytime soon. I?m still a beginner!


Supported Devices: All iOS 10.0+ devices, both jailbroken and non-jailbroken. You can install the app via AppSync if on a jailbroken device or through Cydia Impactor on a non-jailbroken device. However, it's only installable via Cydia Impactor now as I have to figure out how to fakesign it. Otherwise, you can install the DEB version provided by https://www.reddit.com/user/DamienPwnz/

Download the IPA/DEB from here: https://github.com/KawaiiAurora/SHSH-Wallet/releases

![alt text](https://raw.githubusercontent.com/KawaiiAurora/SHSH-Wallet/master/Screenshots/S1.jpeg)
![alt text](https://raw.githubusercontent.com/KawaiiAurora/SHSH-Wallet/master/Screenshots/S2.jpeg)
![alt text](https://raw.githubusercontent.com/KawaiiAurora/SHSH-Wallet/master/Screenshots/S3.jpeg)
![alt text](https://raw.githubusercontent.com/KawaiiAurora/SHSH-Wallet/master/Screenshots/S4.jpeg)
