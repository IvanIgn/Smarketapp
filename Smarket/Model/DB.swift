//
//  DB.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Advert {
    
    var image: String!
    var productName: String!
    var price: String!
    var location: String!
    var telefon: String!
    var description: String!
    var timestamp: Date!
    //var createdAt: Date
    var documentID: String!
    var detailImage: UIImage!
    
    init(image: String, productName: String, price: String, location: String, telefon: String, description: String/*, timestamp: Date*/) {
        self.image = image
        self.productName = productName
        self.price = price
        self.location = location
        self.telefon = telefon
        self.description = description
        
        // self.timestamp = timestamp
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        image = snapshot["image"] as? String ?? ""
        productName = snapshot["productName"] as? String ?? "product"
        price = snapshot["price"] as? String ?? "0"
        location = snapshot["location"] as? String ?? "default location"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        description = snapshot["description"] as? String ?? "some words about product..."
        //createdAt = snapshot["timestamp"] as? Date ?? Date()

        //let time = snapshot["timestamp"] as! Timestamp
        //timestamp = time.dateValue()
        documentID = snapshot.documentID
    }
    
    
    func toAny() -> [String: Any] {
        return ["image": image,
                "productName": productName != "" ? productName : "no product name",
                "price": price != "" ? price : "no product price",
                "location": location != "" ? location : "no location",
                "telefon": telefon != "" ? telefon : "no telefon number",
                "description": description != "" ? description : "no description",
                "timestamp":  FieldValue.serverTimestamp()]
    }
}


class Profile {

    var name: String!
    var telefon: String!
    var email: String!
    //var address: String!
    var photo: String!


    init(name: String, telefon: String, email: String, /*address: String,*/ photo: String) {
        self.name = name
        self.telefon = telefon
        self.email = email
       // self.address = address
        self.photo = photo
    }

    init(snapshot: QueryDocumentSnapshot) {
       
        name = snapshot["name"] as? String ?? "user"
        telefon = snapshot["telefon"] as? String ?? "default telefon"
        email = snapshot["email"] as? String ?? "x@x.com"
        //address = snapshot["address"] as? String ?? "some address"
        photo = snapshot["photo"] as? String ?? ""
    }


    func toAny() -> [String: Any] {
        return ["name": name != "" ? name : "add your name",
                "telefon": telefon != "" ? telefon : "add your telephone",
                "email": email != "" ? email : "add your email"/*"\(NSLocalizedString("addmail", comment: ""))"*/,
                //"address": address,
                "photo": photo]
    }
}
