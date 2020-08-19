//
//  MapViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-19.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
import FloatingButtonPOP_swift

class MapViewController: UIViewController,FloaterViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func userDidTapOnItem(at index: Int, with model: String) {
                   print(model)
                   print(index)
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
