//
//  DetailViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Foundation

class DetailVC: UIViewController {

    var advert: Advert!
    var profile: Profile!
    

    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productTel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productLbl.text = advert.productName
        productLbl.font = UIFont.boldSystemFont(ofSize: 25.0)
        priceLbl.text = advert.price
        productImage.image = advert.detailImage
        locationLabel.text = advert.location
        productDescription.text = advert.description
        productDescription.font = UIFont(name: "Times New Roman", size: 19)
        productDescription.isEditable = true
        productDescription.autocorrectionType = .yes
        productDescription.layer.cornerRadius = 10
        
        productTel.text = advert.telefon
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        tap.numberOfTapsRequired = 1
        productTel.isUserInteractionEnabled = true
        productTel.addGestureRecognizer(tap)
        
        
    }

    func initData(advert: Advert) {
        self.advert = advert
    }
    
    @objc func tapFunction(sender: AnyObject) {
       // let numberString: String = productTel.text!
        
//        if numberString == "no telefon" || numberString.isEmpty   {
//            return
//        }
//        else if numberString.contains("0123456789#") {
//            let phoneURL = URL(string: numberString)
//            UIApplication.shared.canOpenURL(phoneURL!)
//             print("Phone number clicked")
//        }
//       // UIApplication.shared.canOpenURL(phoneURL)
//        //UIApplication.shared.canOpenURL(url)
//        //print("Phone number clicked")


        
        let phoneNumber: String = productTel.text ?? "no location"
//        let called: NSURL = NSURL(string: "tel://\(phoneNumber)")
        let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false]

        if phoneNumber.isNumeric {
            let called: NSURL = NSURL(string: "tel://\(phoneNumber)")!
            
        UIApplication.shared.open(called as URL, options: options, completionHandler: { (success) in
            print("Open url : \(success)")
        })
            
         } else {

                return
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOnMap" {
            //let indexPath = smarketTableView.indexPathForSelectedRow
            //let cell = smarketTableView.cellForRow(at: indexPath!) as! MyCell
            let locationPlace = advert.location
            
            
            let destinationVC = segue.destination as! MapVC
            destinationVC.initLocData(advert: advert)
        }
    }
    
    
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "#", "+"]
        return Set(self).isSubset(of: nums)
    }
}
