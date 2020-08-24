//
//  MyPropertiesViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos & Arthur Ataide. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyPropertiesViewController: UIViewController {
    let cellIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    var refProperty: DatabaseReference!
    var refPhoto: DatabaseReference!
    var properties = [Property]()
    var propertyPhotos = [PropertyPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refProperty = Database.database().reference()
        refPhoto = Database.database().reference()
        
        tableView.rowHeight = 164
    }
    
    override func viewWillAppear(_ animated: Bool) {
        properties.removeAll()
        propertyPhotos.removeAll()
        
        if let user = Auth.auth().currentUser{
            refProperty.child("property").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary{
                    print(value.allKeys)
                    for key in value.allKeys{
                        let p = value[key] as? NSDictionary
                        
                        let id = key as! String
                        let title = p?["title"] as? String ?? ""
                        let description = p?["description"] as? String ?? ""
                        
                        let property = Property()
                        property.title = title
                        property.description = description
                        
                        //Getting first photo
                        self.refPhoto.child("propertyPhoto").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let valuePhoto = snapshot.value as? NSDictionary{
                                for keyPhoto in valuePhoto.allKeys{
                                    let pp = valuePhoto[keyPhoto] as? NSDictionary
                                    
                                    let imageString = pp?["photo"] as? String ?? ""
                                    let propertyId = pp?["propertyId"] as? String ?? ""
                                    
                                    print("id \(id) | propertyId \(propertyId)")
                                    if id == propertyId{
                                        let propertyPhoto = PropertyPhoto()
                                        propertyPhoto.photoString = imageString
                                        self.propertyPhotos.append(propertyPhoto)
                                        self.tableView.reloadData()
                                        break
                                    }
                                }
                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                        
                        self.properties.append(property)
                    }
                }
                
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "propertiesToNew", sender: self)
    }
    
    
}

extension MyPropertiesViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PropertyTableViewCell
        print("cell: \(cell)")
        
        
        cell.photoImageView.clipsToBounds = true
        cell.photoImageView.layer.cornerRadius = 12
        cell.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if propertyPhotos.count > indexPath.row{
            cell.photoImageView.image = Common.convertBase64ToImage(propertyPhotos[indexPath.row].photoString)
        }
        
        print("Photos: \(propertyPhotos.count)")
        
        cell.titleLabel.text = properties[indexPath.row].title
        cell.descriptionTextView.text = properties[indexPath.row].description
        
        return cell
    }
    
    
}


