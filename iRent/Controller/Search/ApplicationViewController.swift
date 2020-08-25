//
//  ApplicationViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-24.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ApplicationViewController: UIViewController {
    
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerTextField: UITextField!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var applyButton: UIButton!
    var refApplication: DatabaseReference!
    
    var property:Property?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        
        refApplication = Database.database().reference()
        
        // Do any additional setup after loading the view.
        applyButton.setImage(nil, for: .normal)
        applyButton.setTitle("Continue", for: .normal)
        
        property = AppDelegate.shared().property
        fillFields()
    }
    
    func fillFields(){
        if let p = property{
            titleLabel.text = p.title
            offerTextField.text = p.price
            
            if AppDelegate.shared().selectedPhotos.count > 0{
                propertyImageView.image = AppDelegate.shared().selectedPhotos[0].photo
            }
            
            if let price = Double(p.price){
                let formattedPrice =  String(format: "C$ %.02f/mo", price)
                priceButton.setTitle(formattedPrice, for: .normal)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("User On?: \(isUserLoggedIn())")
        if !isUserLoggedIn(){
            performSegue(withIdentifier: "applicationToLogin", sender: self)
        }
    }
    
    func isUserLoggedIn()->Bool{
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print(applyButton.titleLabel?.text)
        if(applyButton.titleLabel?.text == "Continue"){
            //performSegue(withIdentifier: "DocumentsRequestSegue", sender: nil)
            submitApplication()
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func submitApplication(){
        if let user = Auth.auth().currentUser{
            let application = ["propertyId":AppDelegate.shared().property.id,
                               "created":Common.getDateTime("DATE") + " " + Common.getDateTime("TIME"),
                               "offer": String(offerTextField.text!),
                               "comment": String(commentTextView.text),
                               "applicantName": user.displayName,
                ]
            
            guard let key = refApplication.child("application").child(user.uid).childByAutoId().key else { return }
            refApplication.child("application").child(user.uid).child(key).setValue(application){
                (error:Error?, ref:DatabaseReference) in
                
                if (error == nil){
                    self.navigationController?.popToRootViewController(animated: true)
                    self.showToast(message: "The application has been submitted.", font: .systemFont(ofSize: 12.0))
                }else{
                    self.showMessage("Application", error!.localizedDescription, "OK")
                }
            }
        }
    }
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-300, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 8.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: - UITextView

extension ApplicationViewController: UITextViewDelegate {
    func setUpTextView(){
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        commentTextView.text = "Leave a comment to the owner..."
        commentTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor.lightGray.withAlphaComponent(0.6) {
            commentTextView.layer.borderColor = UIColor(named: "RedMain")?.withAlphaComponent(0.6).cgColor
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.text = "Leave a comment to the owner..."
            commentTextView.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        }
    }
}
