//
//  SmarketTableViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SmarketVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var smarketTableView: UITableView!
    @IBOutlet weak var smSearchBar: UISearchBar!
    
    var smarketArray = [Advert]()               // main array
    var curSmarkethArray = [Advert]()          // search array
    
    var advertCollectionRef: CollectionReference!
    var advertListener: ListenerRegistration!
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smarketTableView.dataSource = self
        smarketTableView.delegate = self
        smSearchBar.delegate = self
        smSearchBar.placeholder = "Search product by name"
        advertCollectionRef = Firestore.firestore().collection("addAdvert")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAdvertData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        advertListener.remove()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

       return 1
   }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
           return curSmarkethArray.count
        } else {
            return smarketArray.count
        }
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = smarketTableView.dequeueReusableCell(withIdentifier: "MyTableCell") as? MyCell else {return UITableViewCell()}
//        let advertItem = smarketArray[indexPath.row]
//        cell.configureCell(advert: advertItem)
        
        if searching {
            let curAdvertItem = curSmarkethArray[indexPath.row]
           // cell.textLabel?.text = curSmarkethArray[indexPath.row] as? String
             cell.configureCell(advert: curAdvertItem)
        } else {
            let advertItem = smarketArray[indexPath.row]
            cell.configureCell(advert: advertItem)
        }
        
        return cell
    }
    
    func loadAdvertData() {
        advertListener = advertCollectionRef.order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else { return }
                
                self.smarketArray.removeAll()
                for document in snapshot.documents {
                    let advert = Advert(snapshot: document)
                    self.smarketArray.append(advert)
                }
                self.smarketTableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let indexPath = smarketTableView.indexPathForSelectedRow
            let cell = smarketTableView.cellForRow(at: indexPath!) as! MyCell
            let advert = smarketArray[indexPath!.row]
            advert.detailImage = cell.productImage.image
            
//            if advert.detailImage == nil {
//                cell.productImage.image = UIImage.init(named: "defaultImage")
//            }
            
            let destinationVC = segue.destination as! DetailVC
            destinationVC.initData(advert: advert)
        }
    }

}

extension SmarketVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty
            else
        {
            curSmarkethArray = smarketArray
            smarketTableView.reloadData()
            return
            
        }
//        smSearchArray = smarketArray.filter({(String($0.productName.lowercased().prefix(searchText.count))) as String ==  searchText.lowercased()})
        
        curSmarkethArray = smarketArray.filter({ smarket -> Bool in
           smarket.productName.lowercased().contains(searchText.lowercased())
        })
        searching = true
        smarketTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        smarketTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
}
