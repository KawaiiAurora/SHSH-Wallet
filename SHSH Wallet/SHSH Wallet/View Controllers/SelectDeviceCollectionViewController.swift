//
//  SelectDeviceCollectionViewController.swift
//  SHSH Wallet
//
//  Created by Aurora on 29/07/2019.
//  Copyright © 2019 Aurora. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectDeviceCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("eek?")

        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Constants.deviceTypes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectDeviceCollectionViewCell
        
        cell.deviceTypeLabel.text = Constants.deviceTypes[indexPath.row]
    
        // Configure the cell
    
        return cell
    }

}

/*extension SelectDeviceCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/10, height: self.view.frame.height/10)
    }
}*/
