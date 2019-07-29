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
    var devices:[Device]! //Given by device type selector
    let alert = UIAlertController(title: "SHSH Wallet", message: "Application is loading. Please wait", preferredStyle: .alert)
    
    var fetchResultController: NSFetchedResultsController<ServerDataMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        performSegue(withIdentifier: "showDevice", sender: indexPath.item)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDevice"{
            guard let selectedRow = sender as? Int else{
                return
            }
            let destinationController = segue.destination as! DeviceInfoViewController
            destinationController.device = devices[selectedRow]
        }
    }
}
