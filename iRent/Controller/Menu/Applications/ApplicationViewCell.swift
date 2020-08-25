//
//  ApplicationViewCell.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-25.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class ApplicationViewCell: UITableViewCell {

    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var applicantNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var propertyAddressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
