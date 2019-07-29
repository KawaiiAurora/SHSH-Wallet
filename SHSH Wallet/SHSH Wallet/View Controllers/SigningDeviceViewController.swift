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

class SigningViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var devices:[Device]! //Given by device type selector
    var searchResults=[Device]()
    var isSearching = false
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
        if(!isSearching){
            return devices.count
        }else{
            return searchResults.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SigningCollectionViewCell
        
        if(!isSearching){
            cell.nameLabel.text = devices[indexPath.item].name
            if let image = devices[indexPath.item].image{
                cell.imageView.image = image
            }
        }else{
            cell.nameLabel.text = searchResults[indexPath.item].name
            if let image = searchResults[indexPath.item].image{
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDevice", sender: indexPath.item)
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
     
     isSearching = searchText.isEmpty ? true : false
        searchResults = searchText.isEmpty ? [] : devices.filter { (item: Device) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }*/
    
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
