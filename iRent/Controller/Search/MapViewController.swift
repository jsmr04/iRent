//
//  MapViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-19.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    var userLoggedIn = false
    var isSearch = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapFloatingButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var refProperty: DatabaseReference!
    var refPhoto: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        //print("Back button")
        // Do any additional setup after loading the view.
        mapFloatingButton.backgroundColor = UIColor(named: "RedMain")
        mapFloatingButton.layer.cornerRadius = mapFloatingButton.frame.height / 2
        
        searchBar.delegate = self
        
        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchBar.layer.cornerRadius = 10
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        refProperty = Database.database().reference()
        refPhoto = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    func goTo(_ coordinate:CLLocationCoordinate2D){
        let loc = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let reg = MKCoordinateRegion(center:loc, span:span)
        mapView.region = reg
    }
    
    func addAnnotation(_ coordinate:CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.subtitle = ""
        mapView.addAnnotation(annotation)
    }
    
    func getAreaCoordinates(){
        let rect = mapView.visibleMapRect
        let neMapPoint = MKMapPoint(x: rect.maxX, y: rect.origin.y)
//        let swMapPoint = MKMapPoint(x: rect.origin.x, y: rect.maxY)
        let midMapPoint = MKMapPoint(x: rect.midX, y: rect.midY)
        
        let neCoord = neMapPoint.coordinate
//        let swCoord = swMapPoint.coordinate
        let midCoord = midMapPoint.coordinate
        
        let c1 = CLLocation(latitude: midCoord.latitude, longitude: midCoord.longitude)
        let c2 = CLLocation(latitude: neCoord.latitude, longitude: neCoord.longitude)
         
        let distance = c1.distance(from: c2)
        
            refProperty.child("property").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary{
                    print(value.allKeys)
                    for key in value.allKeys{
                        let p = value[key] as? NSDictionary
                        
                        let id = key as! String
                        let title = p?["title"] as? String ?? ""
                        let description = p?["description"] as? String ?? ""
                        let location = p?["location"] as? String ?? ""
                        
                        if location.contains(","){
                            let lat = location.split(separator: ",")[0]
                            let long = location.split(separator: ",")[1]
                            
                            let dLat = Double(lat)
                            let dLong = Double(long)
                            let propertyLocation = CLLocation(latitude: dLat!, longitude: dLong!)
                            
                            AppDelegate.shared().propertyList.removeAll()
                            
                            let propertyDistance = propertyLocation.distance(from: c1)
                            if propertyDistance <= distance{
                                let propertyList = PropertyList()
                                propertyList.id = id
                                propertyList.title = title
                                propertyList.description = description
                                propertyList.location = location
                                
                                AppDelegate.shared().propertyList.append(propertyList)
                            }
                        }
                        
//                        //Getting first photo
//                        self.refPhoto.child("propertyPhoto").observeSingleEvent(of: .value, with: { (snapshot) in
//                            if let valuePhoto = snapshot.value as? NSDictionary{
//                                for keyPhoto in valuePhoto.allKeys{
//                                    let pp = valuePhoto[keyPhoto] as? NSDictionary
//
//                                    let imageString = pp?["photo"] as? String ?? ""
//                                    let propertyId = pp?["propertyId"] as? String ?? ""
//
//                                    print("id \(id) | propertyId \(propertyId)")
//                                    if id == propertyId{
//                                        let propertyPhoto = PropertyPhoto()
//                                        propertyPhoto.photoString = imageString
//                                        self.propertyPhotos.append(propertyPhoto)
//                                        self.tableView.reloadData()
//                                        break
//                                    }
//                                }
//                            }
//                        }) { (error) in
//                            print(error.localizedDescription)
//                        }
                        
//                        self.properties.append(property)
                    }
                }
                
                //self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
        
        
        
//        print("Coor: \(neCoord)")
//        print("Coor: \(swCoord)")
        
//        addAnnotation(neCoord)
////        addAnnotation(swCoord)
//        addAnnotation(midCoord)
    }
    
    func getMidPoint(){
        
    }
}



extension MapViewController:UIGestureRecognizerDelegate,MKMapViewDelegate {
    
}

extension MapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let location = locations.first {
            goTo(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension MapViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Search: \(searchBar.text!)")
        getAreaCoordinates()
        
        if let searchText = searchBar.text{
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                print(response.mapItems[0].placemark.coordinate)
                self.goTo(response.mapItems[0].placemark.coordinate)
            }
        }
    }
    
}
