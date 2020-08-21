//
//  MapViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-19.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import FirebaseAuth

class MapViewController: UIViewController {
    var userLoggedIn = false
    
    
    @IBOutlet weak var mapFloatingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        //print("Back button")
        // Do any additional setup after loading the view.
        mapFloatingButton.backgroundColor = UIColor(named: "RedMain")
        mapFloatingButton.layer.cornerRadius = mapFloatingButton.frame.height / 2
    }
    
    @IBAction func floatingListClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "ListPropertiesSegue", sender: self)
    }
    
    func userDidTapOnItem(at index: Int, with model: String) {
                   print(model)
                   print(index)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userLoggedIn = isUserLoggedIn()
        if (userLoggedIn){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogin))
        }
    }
    
    @objc func goToLogin(){
        performSegue(withIdentifier: "mapToLogin", sender: self)
    }
    
    @objc func logOut(){
        do {
          try Auth.auth().signOut()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogin))
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func isUserLoggedIn()->Bool{
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
    
}
