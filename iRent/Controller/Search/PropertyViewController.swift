//
//  PropertyViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-24.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class PropertyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var location2Label: UILabel!
    @IBOutlet weak var landlordNameLabel: UIButton!
    @IBOutlet weak var bathroomNumberLabel: UILabel!
    @IBOutlet weak var bedroomNumberLabel: UILabel!
    @IBOutlet weak var ParkingNumberLabel: UILabel!
    @IBOutlet weak var airConditioningImageView: UIImageView!
    @IBOutlet weak var fireplaceImageView: UIImageView!
    @IBOutlet weak var heatingImageView: UIImageView!
    @IBOutlet weak var laundryImageView: UIImageView!
    @IBOutlet weak var locationMapView: MKMapView!
    let annotation = MKPointAnnotation()
    
    var refProperty: DatabaseReference!
    var refPhoto: DatabaseReference!
    var property:Property?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMapView.delegate = self
        
        refProperty = Database.database().reference()
        refPhoto = Database.database().reference()
        
        property = AppDelegate.shared().property
        //print("Property: \(property)")
        fillFields()
        
        // Do any additional setup after loading the view.
//        descriptionLabel.text = "63 MEDFORD AVE !!! Prime Loacation. Beautiful, Bright, Well Kept South Facing Unit. (With Access From Warden Ave And Danforth Rd). Large Private Yard, Perfect for Entertaining. Minutes A Way, From Warden And Victoria Park Subway Station. Easy Access To Downtown, Beaches And Go Station."
    }
    
    func fillFields(){
        if let p = property{
            titleLabel.text = p.title
            descriptionLabel.text = p.description
            landlordNameLabel.setTitle(p.landlordName, for: .normal)
            bathroomNumberLabel.text = p.bathrooms
            bedroomNumberLabel.text = p.rooms
            ParkingNumberLabel.text = p.parkingSpots
            locationLabel.text = "\(p.address.trimmingCharacters(in: .whitespaces)), \(p.city.trimmingCharacters(in: .whitespaces))"
            location2Label.text = "\(p.province.trimmingCharacters(in: .whitespaces)), \(p.postalCode)"
            
            if let price = Double(p.price){
                //C$ 2,500.00/mo
                let formattedPrice =  String(format: "C$ %.02f/mo", price)
                priceButton.setTitle(formattedPrice, for: .normal)
            }
            
            if p.fireplace == "1"{
                fireplaceImageView.image = UIImage(systemName: "checkmark.circle.fill")
            }else{
                fireplaceImageView.image = UIImage(systemName: "xmark.circle.fill")
            }
            
            if p.airConditioning == "1"{
                airConditioningImageView.image = UIImage(systemName: "checkmark.circle.fill")
            }else{
                airConditioningImageView.image = UIImage(systemName: "xmark.circle.fill")
            }
            
            if p.heating == "1"{
                heatingImageView.image = UIImage(systemName: "checkmark.circle.fill")
            }else{
                heatingImageView.image = UIImage(systemName: "xmark.circle.fill")
            }
            
            if p.laundry == "1"{
                laundryImageView.image = UIImage(systemName: "checkmark.circle.fill")
            }else{
                laundryImageView.image = UIImage(systemName: "xmark.circle.fill")
            }
            
            if p.location.contains(","){
                let lat = p.location.split(separator: ",")[0]
                let long = p.location.split(separator: ",")[1]
                
                if let dLat = Double(lat), let dLong = Double(long) {
                    let loc = CLLocationCoordinate2D(latitude: dLat, longitude: dLong)
                    goTo(loc)
                    addAnnotation(loc)
                }

            }
            
        }
    
    }
    
    func goTo(_ coordinate:CLLocationCoordinate2D){
        let loc = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let reg = MKCoordinateRegion(center:loc, span:span)
        locationMapView.region = reg
    }
    
    func addAnnotation(_ coordinate:CLLocationCoordinate2D) {
        annotation.coordinate = coordinate
        annotation.subtitle = ""
        locationMapView.addAnnotation(annotation)
    }
    
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "ApplySegue", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func backAction(_ sender: UIButton) {
       let _ = self.navigationController?.popViewController(animated: true)
    }
    

}
// MARK: - CollectionViewController

extension PropertyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.shared().selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageProperty", for: indexPath) as! PropertyCollectionViewCell
        cell.imageProperty.image = AppDelegate.shared().selectedPhotos[indexPath.row].photo
        
        return cell
    }
    
    
}

extension PropertyViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Annotations")
        
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
