//
//  TabViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-22.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print (item.tag)
//        switch item.tag {
//
//
//        case 3:
//
//
//        default :
//            print("Something went wrong !!")
//        }
    }
    
}
