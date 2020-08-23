//
//  CreateProperty1ViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-22.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateProperty1ViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        gestureTap.delegate = self
        mapView.delegate = self
        mapView.addGestureRecognizer(gestureTap)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addressEditEnded(_ sender: UITextField) {
        if let searchText = sender.text{
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
                self.addAnnotation(response.mapItems[0].placemark.coordinate)
            }
        }
    }
    
    @objc func tap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addAnnotation(coordinate)
    }
    
    func goTo(_ coordinate:CLLocationCoordinate2D){
        let loc = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let reg = MKCoordinateRegion(center:loc, span:span)
        mapView.region = reg
    }
    
    func addAnnotation(_ coordinate:CLLocationCoordinate2D) {
        annotation.coordinate = coordinate
        annotation.subtitle = ""
        AppDelegate.shared().property.location = String(coordinate.latitude) + "," +  String(coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        AppDelegate.shared().property.address = addressTextField.text!
        AppDelegate.shared().property.city = cityTextField.text!
        AppDelegate.shared().property.province = provinceTextField.text!
        AppDelegate.shared().property.country = countryTextField.text!
        AppDelegate.shared().property.postalCode = postalCodeTextField.text!
        
        performSegue(withIdentifier: "goToFeatures", sender: self)
    }

}

extension CreateProperty1ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let location = locations.first {
            goTo(location.coordinate)
            //self.addAnnotation(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension CreateProperty1ViewController:UIGestureRecognizerDelegate,MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            print("Annotations")
            
            let id = MKMapViewDefaultAnnotationViewReuseIdentifier
            
            if let v = mapView.dequeueReusableAnnotationView(
                withIdentifier: id, for: annotation) as? MKMarkerAnnotationView {
                v.canShowCallout = true
                v.image = #imageLiteral(resourceName: "logo1_small")
                //v.glyphImage = #imageLiteral(resourceName: "home_default")
                //v.markerTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                //v.glyphTintColor = UIColor.clear
                return v
            }
            return nil
        }
}
