//
//  MyCell.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-19.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import SDWebImage

class MyCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
   // @IBOutlet weak var timeLabel: UILabel!
    
    func configureCell(advert: Advert) {
        if advert.image == "" {
            productImage.image = UIImage(named:"defaultImage")
        } else {
            productImage.sd_setImage(with: URL(string: advert.image), completed: nil)
        }
        
        productNameLabel.text = advert.productName
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        locationLabel.text = advert.location
        priceLabel.text = advert.price
       // timeLabel.text = advert.timestamp.calenderTimeSinceNow()
    }
}
