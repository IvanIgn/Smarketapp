//
//  SignUpViewController.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-07.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let alertTitle1 = NSLocalizedString("Password Incorrect", comment: "")
        let alertText1 = NSLocalizedString("Please re-type password", comment: "")
        
        if password.text != passwordConfirm.text {
            
            let alertController = UIAlertController(title: alertTitle1, message: alertText1, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else{
            let alertTitle1 = NSLocalizedString("Error", comment: "")
            let alertText1 = NSLocalizedString("The password must be at least 6 characters long or more.", comment: "")
            
            
            Auth.auth().createUser(withEmail: email.text!, password: password.text!)
            { (user, error) in
                
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: alertTitle1, message: alertText1, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        passwordConfirm.resignFirstResponder()
        return true;
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
