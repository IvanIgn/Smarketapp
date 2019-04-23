//
//  HomeViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

//var pTel: String!
class ProfileVC: UIViewController {

  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
   // @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    
    var db: Firestore!
    var auth: Auth!
    var profile: Profile!
    var userStorage: StorageReference!
    
    var name = ""
    var telefon = ""
    var email = ""
   // var address = ""
    var image = UIImage(named: "profileLogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        auth = Auth.auth()
        
        let storage = Storage.storage().reference(forURL: "gs://smarket-cf0d2.appspot.com")
        userStorage = storage.child("smarketImages")
        
        photoImage.layer.cornerRadius = 10
        photoImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileData()
    }
    
    func getProfileData() {
        guard let user = auth.currentUser  else { return }
        let profileRef = db.collection("users").document(user.uid)
        let imageRef = self.userStorage.child("\(user.uid).jpg")
        
//        imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                self.image = UIImage(data: data!)
//                self.photoImage.image = self.image
//            }
//     }
        
//        imageRef.downloadURL { (url, error) in
//            guard let downloadURL = url else { return }
//            self.photoImage.sd_setImage(with: downloadURL, completed: nil)
//        }
        
        DispatchQueue.global().async {
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                DispatchQueue.main.async {
                    self.photoImage.sd_setImage(with: downloadURL, completed: nil)
                }
            }
        }
        
        
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                
                self.name = data["name"] as! String
                self.nameLabel.text = self.name
                self.telefon = data["telefon"] as! String
                self.telefonLabel.text = self.telefon
                self.email = data["email"] as! String
                self.emailLabel.text = self.email
               // pTel = self.telefon
                //self.address = data["address"] as! String
                //self.addressLabel.text = self.address
            } else {
                print("Document does not exist")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            let destinationVC = segue.destination as! EditProfileVC
            destinationVC.initData(name: name, telefon: telefon, email: email, image: image!)
        }
  }
    

}
