//
//  LoginViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var forgotPassButton: UIButton!
    
    var email = "";
    var password = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        email = emailTextField.text!
        password = passwordTextField.text!
        
        if checkFields(){
            attemptSignIn()
        }
        
        print("Email:\(email) & Password:\(password)")
    }
    
    @IBAction func registerNowTapped(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func checkFields() -> Bool {
        
        if (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign In", "Email is required", "OK")
            emailTextField.becomeFirstResponder()
            return false
        }
        
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign In", "Password is required", "OK")
            passwordTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func attemptSignIn(){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error == nil{
                if let auth = authResult{
                    print("Sign in success: \(auth.user)")
                }
            }else{
                print("Error signing in: \(error!)")
                self!.showMessage("Sign In", error!.localizedDescription, "OK")
            }
        }
    }
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
