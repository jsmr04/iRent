//
//  PropertyTableViewCell.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-23.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
