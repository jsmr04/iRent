//
//  ApplicationsViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-25.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ApplicationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var applications = [Application]()
    let cellIdentifier = "cell"
    var refApplications: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refApplications = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getApplications()
    }
    
    func getApplications(){
        applications.removeAll()
        if let user = Auth.auth().currentUser{
            refApplications.child("application").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                if let value = snapshot.value as? NSDictionary{
                    for keyUser in value.allKeys{
                        if let applicationJson = value[keyUser] as? NSDictionary{
                            print(value.allKeys)
                            for key in applicationJson.allKeys{
                                let p = applicationJson[key] as? NSDictionary
                                
                                let id = key as! String
                                
                                let application = Application()
                                application.id = p?["id"] as? String ?? ""
                                application.title = p?["title"] as? String ?? ""
                                application.propertyId = p?["propertyId"] as? String ?? ""
                                application.comment = p?["comment"] as? String ?? ""
                                application.created = p?["created"] as? String ?? ""
                                application.offer = p?["offer"] as? String ?? ""
                                application.ownerId = p?["ownerId"] as? String ?? ""
                                application.applicantName = p?["applicantName"] as? String ?? ""
                                application.address = p?["address"] as? String ?? ""
                                application.status = p?["status"] as? String ?? ""
                                application.photo = p?["photo"] as? String ?? ""
                                
                                self.applications.append(application)
                            }
                        }
                    }
                }
                
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ApplicationListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count \(applications.count)")
        return self.applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ApplicationViewCell
        
        cell.propertyImageView.clipsToBounds = true
        cell.propertyImageView.layer.cornerRadius = 12
        cell.propertyImageView.image = Common.convertBase64ToImage(applications[indexPath.row].photo)
        cell.applicantNameLabel.text = applications[indexPath.row].applicantName
        cell.propertyAddressLabel.text = applications[indexPath.row].address
        cell.dateLabel.text = applications[indexPath.row].created
        
        if applications[indexPath.row].status == "1"{
            cell.statusLabel.text = "Requested"
        } else if (applications[indexPath.row].status == "2"){
            cell.statusLabel.text = "Approved"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().application = applications[indexPath.row]
        performSegue(withIdentifier: "goToApplicationDetail", sender: self)
    }
    
    
}
