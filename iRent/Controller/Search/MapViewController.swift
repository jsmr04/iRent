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
import FirebaseDatabase

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
        
        //print("Back button")
        // Do any additional setup after loading the view.
        mapFloatingButton.backgroundColor = UIColor(named: "RedMain")
        mapFloatingButton.layer.cornerRadius = mapFloatingButton.frame.height / 2
        
        mapView.delegate = self
        
        searchBar.delegate = self
        
        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchBar.layer.cornerRadius = 10
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        refProperty = Database.database().reference()
        refPhoto = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func floatingListClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "ListPropertiesSegue", sender: self)
        //performSegue(withIdentifier: "PropertySegue", sender: self)
    }
    
    func userDidTapOnItem(at index: Int, with model: String) {
        print(model)
        print(index)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationItem.hidesBackButton = false
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
    
    func addAnnotation(_ coordinate:CLLocationCoordinate2D, _ title:String, _ id:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = id
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
        
        AppDelegate.shared().propertyList.removeAll()
        AppDelegate.shared().propertyPhotos.removeAll()
        AppDelegate.shared().property = Property()
        
        refProperty.child("property").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                print(value.allKeys)
                for keyUser in value.allKeys{
                    if let propertyJson = value[keyUser] as? NSDictionary{
                        
                        for propertyKey in propertyJson.allKeys{
                            
                            let p = propertyJson[propertyKey] as? NSDictionary
                            let location = p?["location"] as? String ?? ""
                            
                            if location.contains(","){
                                let lat = location.split(separator: ",")[0]
                                let long = location.split(separator: ",")[1]
                                
                                let dLat = Double(lat)
                                let dLong = Double(long)
                                let propertyLocation = CLLocation(latitude: dLat!, longitude: dLong!)
                                
                                let propertyDistance = propertyLocation.distance(from: c1)
                                if propertyDistance <= distance{
                                    
                                    let property = Property()
                                    property.id = propertyKey as! String
                                    property.title = p?["title"] as? String ?? ""
                                    property.description = p?["description"] as? String ?? ""
                                    property.type = p?["type"] as? String ?? ""
                                    property.price = p?["price"] as? String ?? ""
                                    property.address = p?["address"] as? String ?? ""
                                    property.country = p?["country"] as? String ?? ""
                                    property.province = p?["province"] as? String ?? ""
                                    property.city = p?["city"] as? String ?? ""
                                    property.postalCode = p?["postalCode"] as? String ?? ""
                                    property.location = p?["location"] as? String ?? ""
                                    property.rooms = p?["rooms"] as? String ?? ""
                                    property.bathrooms = p?["bathrooms"] as? String ?? ""
                                    property.parkingSpots = p?["parkingSpots"] as? String ?? ""
                                    property.heating = p?["heating"] as? String ?? ""
                                    property.balcony = p?["balcony"] as? String ?? ""
                                    property.fireplace = p?["fireplace"] as? String ?? ""
                                    property.airConditioning = p?["airConditioning"] as? String ?? ""
                                    property.laundry = p?["laundry"] as? String ?? ""
                                    property.created = p?["created"] as? String ?? ""
                                    property.landlordName = p?["landlordName"] as? String ?? ""
                                    
                                    AppDelegate.shared().propertyList.append(property)
                                    self.addAnnotation(propertyLocation.coordinate, property.title, property.id)
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        refPhoto.child("propertyPhoto").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                print(value.allKeys)
                for keyUser in value.allKeys{
                    if let photoJson = value[keyUser] as? NSDictionary{
                        
                        for photoKey in photoJson.allKeys{
                            let p = photoJson[photoKey] as? NSDictionary

                            let propertyPhoto = PropertyPhoto()
                            propertyPhoto.id = photoKey as! String
                            propertyPhoto.propertyId = p?["propertyId"] as? String ?? ""
                            propertyPhoto.photoString = p?["photo"] as? String ?? ""
                            propertyPhoto.created = p?["created"] as? String ?? ""

                            AppDelegate.shared().propertyPhotos.append(propertyPhoto)
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}

extension MapViewController:UIGestureRecognizerDelegate,MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.subtitle)
        
        for p in AppDelegate.shared().propertyList{
            if view.annotation?.subtitle == p.id{
                AppDelegate.shared().property = p
                break
            }
        }
        
        AppDelegate.shared().selectedPhotos.removeAll()
        for ph in AppDelegate.shared().propertyPhotos{
            if ph.propertyId == AppDelegate.shared().property.id{
                ph.photo = Common.convertBase64ToImage(ph.photoString)
                AppDelegate.shared().selectedPhotos.append(ph)
            }
        }
        performSegue(withIdentifier: "PropertySegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        getAreaCoordinates()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        
        if let v = mapView.dequeueReusableAnnotationView(
            withIdentifier: id, for: annotation) as? MKMarkerAnnotationView {
            v.canShowCallout = true
            v.image = #imageLiteral(resourceName: "logo1_small")
            v.markerTintColor = UIColor.clear
            v.glyphTintColor = UIColor.clear
            return v
        }
        return nil
    }
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Search: \(searchBar.text!)")
        
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
