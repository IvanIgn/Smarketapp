//
//  AddProductViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-17.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddProductVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var addProductImage: UIImageView!
    @IBOutlet weak var addProductName: UITextField!
    @IBOutlet weak var addProductPrice: UITextField!
    @IBOutlet weak var addProductDesc: UITextView!
    @IBOutlet weak var addProductLocation: UITextField!
    @IBOutlet weak var addProductTelefon: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var advertCollectionRef: CollectionReference!
    var userStorage: StorageReference!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        advertCollectionRef = Firestore.firestore().collection("addAdvert")
        auth = Auth.auth()
        let storage = Storage.storage().reference(forURL: "gs://smarket-cf0d2.appspot.com")
        userStorage = storage.child("userProfileImages")
        
        addProductName.delegate = self
        addProductPrice.delegate = self
        addProductDesc.delegate = self
        addProductLocation.delegate = self
        addProductTelefon.delegate = self
        
        addProductDesc.font = UIFont(name: "Times New Roman", size: 19)
        addProductDesc.isEditable = true
        addProductDesc.autocorrectionType = .yes
        addProductDesc.layer.cornerRadius = 10
        
        self.hideKeyboardWhenTappedAround()
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
       // addProductName.inputAccessoryView = toolBar
        //addProductPrice.inputAccessoryView = toolBar
        addProductDesc.inputAccessoryView = toolBar
        //addProductLocation.inputAccessoryView = toolBar
        //addProductTelefon.inputAccessoryView = toolBar

        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveClicked))
    }
    
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @objc func saveClicked() {
        print("You clicked the save button!!!")
        
        let productName = addProductName.text!
        let price = addProductPrice.text!
        let description = addProductDesc.text!
        var image = ""
        let location = addProductLocation.text!
        let telefon = addProductTelefon.text!
        //let timestamp = Date()
        
        
       
        
        let uuid = UUID().uuidString.lowercased()
        let imageRef = self.userStorage.child("\(uuid).jpg")
        
        if let image = addProductImage.image {
            if image == UIImage(named: "addPhoto") {
                addProductImage.image = UIImage(named: "defaultImage")
            }
        }
        
        let imageData = addProductImage.image!.jpegData(compressionQuality: 0.5)
        
        imageRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else { return }
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                let advert = Advert(image: downloadURL.absoluteString, productName: productName, price: price, location: location, telefon: telefon, description: description/*timestamp: Date()*/)
                self.advertCollectionRef.addDocument(data: advert.toAny()) { (error) in
                    if let error = error {
                        debugPrint("Error adding document: \(error.localizedDescription)")
                    } else {
                       // self.navigationController!.popViewController(animated: true)
                    }
                }
            }
        }
         self.navigationController!.popViewController(animated: true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addProductName.resignFirstResponder()
        addProductPrice.resignFirstResponder()
        addProductLocation.resignFirstResponder()
        addProductTelefon.resignFirstResponder()
        
        return true
    }
    
    ///// Moves TextField /////
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == addProductLocation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)
        } else if (textField == addProductTelefon) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 180), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == addProductLocation) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        } else if (textField == addProductTelefon) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
    }
    
    ///// Moves TextView /////
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == addProductDesc) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == addProductDesc) {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
    }
    
   
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if  addProductDesc.text == "" {
            addProductDesc.text = ""
            addProductDesc.textColor = UIColor.black
            addProductDesc.font = UIFont(name: "Times New Roman", size: 19)
        }
        return true
    }
    
    
    
    
    
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
        addProductImage.image = image
        
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

