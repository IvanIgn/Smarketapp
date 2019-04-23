//
//  EditProfileViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
//import FirebaseStorage

class EditProfileVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addEmail: UITextField!
    // @IBOutlet weak var addAddress: UITextField!
    @IBOutlet weak var addTelefon: UITextField!
    @IBOutlet weak var addPhoto: UIImageView!
    
    var db: Firestore!
    var userStorage: StorageReference!
    var auth: Auth!

    var name = ""
    var telefon = ""
    var email = ""
    //var address = ""
    var image = UIImage(named: "addPhoto")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        auth = Auth.auth()
        
        let storage = Storage.storage().reference(forURL: "gs://smarket-cf0d2.appspot.com")
        userStorage = storage.child("smarketImages")
        
        addName.delegate = self
        addEmail.delegate = self
        //addAddress.delegate = self
        addTelefon.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
//        addPhoto.layer.cornerRadius = 40
//        addPhoto.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveClicked))
        
        addName.text = name
        addTelefon.text = telefon
        addEmail.text = email
        //addAddress.text = address
        addPhoto.image = image
    }
    
    
    func initData(name: String, telefon: String, email: String, /*address: String,*/ image: UIImage) {
        self.name = name
        self.telefon = telefon
        self.email = email
       // self.address = address
        self.image = image
    }
    
    
    @objc func saveClicked(_sender: UIBarButtonItem) {
        let name = addName.text!
        let telefon = addTelefon.text!
        let email = addEmail.text!
        //let address = addAddress.text!
        var photo = ""
    
        guard let user = auth.currentUser  else { return }
        
        let imageRef = self.userStorage.child("\(user.uid).jpg")
        let imageData = addPhoto.image!.jpegData(compressionQuality: 0.5)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
   
        imageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            
            if let metadata = metaData {
                imageRef.downloadURL(completion: { (url, error) in
                    guard let url = url else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        return
                    }
                    
                    photo = url.absoluteString
                })
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        let item = Profile(name: name, telefon: telefon, email: email, photo: photo)
        let profileRef = self.db.collection("users").document(user.uid)
        
        profileRef.setData(item.toAny()) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(profileRef.documentID)")
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addName.resignFirstResponder()
        addEmail.resignFirstResponder()
        //addAddress.resignFirstResponder()
        addTelefon.resignFirstResponder()
        
        return true;
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if textField == addTelefon {
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//        else
//        {
//            let allowedCharacters = CharacterSet.letters
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//     
//        
//    }
    
    
    
    @IBAction func addPhotoClicked(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        addPhoto.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
