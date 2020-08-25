//
//  ApplicationDetailViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-25.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class ApplicationDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aplicantNameButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var offerTextField: UITextField!
    
    var application:Application?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        application = AppDelegate.shared().application
        fillField() 
        // Do any additional setup after loading the view.
    }
    
    func fillField(){
        
        imageView.image = Common.convertBase64ToImage(application!.photo)
        titleLabel.text = application!.title
        addressLabel.text = application!.address
        commentLabel.text = application!.comment
        aplicantNameButton.setTitle(application!.applicantName, for: .normal)
        offerTextField.text = application!.offer
    }
    

}
