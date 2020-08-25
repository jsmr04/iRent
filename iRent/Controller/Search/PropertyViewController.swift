//
//  PropertyViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-24.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import MapKit

class PropertyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var landlordNameLabel: UIButton!
    @IBOutlet weak var bathroomNumberLabel: UILabel!
    @IBOutlet weak var bedroomNumberLabel: UILabel!
    @IBOutlet weak var ParkingNumberLabel: UILabel!
    @IBOutlet weak var airConditioningImageView: UIImageView!
    @IBOutlet weak var fireplaceImageView: UIImageView!
    @IBOutlet weak var heatingImageView: UIImageView!
    @IBOutlet weak var laundryImageView: UIImageView!
    @IBOutlet weak var locationMapView: MKMapView!
    let images = [#imageLiteral(resourceName: "house_default"), #imageLiteral(resourceName: "house_default2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        DescriptionLabel.text = "63 MEDFORD AVE !!! Prime Loacation. Beautiful, Bright, Well Kept South Facing Unit. (With Access From Warden Ave And Danforth Rd). Large Private Yard, Perfect for Entertaining. Minutes A Way, From Warden And Victoria Park Subway Station. Easy Access To Downtown, Beaches And Go Station."
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - CollectionViewController

extension PropertyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageProperty", for: indexPath) as! PropertyCollectionViewCell
        if indexPath.row == 1{
            cell.imageProperty.image = images[0]
        }else {
            cell.imageProperty.image = images[1]
        }
        
        return cell
    }
    
    
}
