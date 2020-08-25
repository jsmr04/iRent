//
//  MenuTableViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-19.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuTableViewController: UITableViewController {
    var userLoggedIn = false
    override func viewDidLoad() {
        super.viewDidLoad()

        userLoggedIn = isUserLoggedIn()
        if (userLoggedIn){
            tableView.allowsSelection = true
        }else{
            tableView.allowsSelection = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userLoggedIn = isUserLoggedIn()
        if (userLoggedIn){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogin))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    @objc func goToLogin(){
        tableView.allowsSelection = true
        performSegue(withIdentifier: "menuToLogin", sender: self)
    }
    
    @objc func logOut(){
        do {
            try Auth.auth().signOut()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogin))
            tableView.allowsSelection = false
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
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
}
