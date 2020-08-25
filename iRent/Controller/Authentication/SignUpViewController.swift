//
//  SignUpViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextFIeld: UITextField!
    
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            print("User:\(user.displayName)")
            print("Email:\(user.email)")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(named: "RedMain")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(named: "RedMain")
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        signUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func signUp(){
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        phoneNumber = phoneNumberTextField.text!
        email = emailTextField.text!
        password = passwordTextField.text!
        confirmPassword = confirmPasswordTextFIeld.text!
        
        if checkFields(){
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil{
                    let changeRequest = authResult?.user.createProfileChangeRequest()

                    if changeRequest != nil{
                        changeRequest?.displayName = self.firstName + " " + self.lastName
                        
                        changeRequest?.commitChanges { (error) in
                            if let e = error{
                                self.showMessage("Sign Up", e.localizedDescription, "OK")
                            }else{
                                let alert = UIAlertController(title: "Sign Up", message: "Sign up success", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    self.showMessage("Sign Up", error!.localizedDescription, "OK")
                }
            }
        }
    }
    
    func checkFields() -> Bool{
        if (firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "First Name is required", "OK")
            firstNameTextField.becomeFirstResponder()
            return false
        }
        
        if (lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "Last Name is required", "OK")
            lastNameTextField.becomeFirstResponder()
            return false
        }
        
        if (phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "Phone Number is required", "OK")
            phoneNumberTextField.becomeFirstResponder()
            return false
        }
        
        if (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "Email is required", "OK")
            emailTextField.becomeFirstResponder()
            return false
        }
        
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "Password is required", "OK")
            passwordTextField.becomeFirstResponder()
            return false
        }
        
        if (confirmPasswordTextFIeld.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Sign Up", "Confirm Password is required", "OK")
            confirmPasswordTextFIeld.becomeFirstResponder()
            return false
        }
        
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextFIeld.text!.trimmingCharacters(in: .whitespacesAndNewlines)){
            showMessage("Sign Up", "Passwords do not match", "OK")
            return false
        }
        
        if (!emailTextField.text!.contains("@") || !emailTextField.text!.contains(".")){
            showMessage("Sign Up", "Please enter a valid Email address. For example jhon@email.com.", "OK")
            return false
        }
        
        return true
    }
    
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
