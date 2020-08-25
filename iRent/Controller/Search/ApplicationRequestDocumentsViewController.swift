//
//  ApplicationRequestDocumentsViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-24.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class ApplicationRequestDocumentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
