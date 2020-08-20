//
//  MapViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-19.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit


class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Nav: \(navigationController?.isNavigationBarHidden)")
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(goToLogin))
        //print("Back button")
        // Do any additional setup after loading the view.
    }
    
    func userDidTapOnItem(at index: Int, with model: String) {
                   print(model)
                   print(index)
    }
    
    @objc func goToLogin(){
        performSegue(withIdentifier: "mapToLogin", sender: self)
    }

}
