//
//  LoginViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()

            email.delegate = self
            password.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      email.resignFirstResponder()
      password.resignFirstResponder()
        return true;
    }
    
    //textfield func for the touch on BG
//    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//      email.resignFirstResponder()
//       password.resignFirstResponder()
//       self.view.endEditing(true)
//
//     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
