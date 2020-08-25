//
//  ApplicationsViewController.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-25.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class ApplicationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var applications = [Application]()
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
}

extension ApplicationListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ApplicationViewCell
        
        return cell
    }
    
    
}
