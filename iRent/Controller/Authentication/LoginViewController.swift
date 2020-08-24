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
    @IBOutlet weak var googleSignInImageView: UIImageView!
    @IBOutlet weak var facebookSignInImageView: UIImageView!
    
    
    var email = "";
    var password = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        googleSignInImageView.isUserInteractionEnabled = true
        let tapGoogleRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGoogleSignIn))
        googleSignInImageView.addGestureRecognizer(tapGoogleRecognizer)
        
        facebookSignInImageView.isUserInteractionEnabled = true
        let tapFacebookRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFacebookSignIn))
        facebookSignInImageView.addGestureRecognizer(tapFacebookRecognizer)
        
        let remember = UserDefaults.standard.bool(forKey: "remember")
        
        if remember{
            emailTextField.text = UserDefaults.standard.string(forKey: "email")
            passwordTextField.text = UserDefaults.standard.string(forKey: "password")
            rememberSwitch.setOn(true, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(named: "RedMain")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(named: "RedMain")
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        email = emailTextField.text!
        password = passwordTextField.text!
        
        if checkFields(){
            attemptSignIn()
        }
        
    }
    
    @IBAction func rememberChanged(_ sender: UISwitch) {
        if !sender.isOn{
            rememberUser()
        }
    }
    
    @IBAction func registerNowTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginToRegister", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func checkFields() -> Bool {
        
        if (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Login", "Email is required", "OK")
            emailTextField.becomeFirstResponder()
            return false
        }
        
        if (passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Login", "Password is required", "OK")
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
                    self!.rememberUser()
                    let alert = UIAlertController(title: "Login", message: "Login successful", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: {(alert: UIAlertAction!) in self!.navigationController?.popViewController(animated: true)}))
                    self!.present(alert, animated: true, completion: nil)
                }
            }else{
                print("Error signing in: \(error!)")
                self!.showMessage("Login", error!.localizedDescription, "OK")
            }
        }
    }
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapGoogleSignIn(){
        print("Google Sign In")
    }
    
    @objc func tapFacebookSignIn(){
        print("Facebook Sign In")
    }
    
    func rememberUser(){
        if rememberSwitch.isOn{
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.setValue(password, forKey: "password")
            UserDefaults.standard.setValue(true, forKey: "remember")
        }else{
            UserDefaults.standard.setValue(email, forKey: "")
            UserDefaults.standard.setValue(password, forKey: "")
            UserDefaults.standard.setValue(false, forKey: "remember")
        }
    }
    
    
}
