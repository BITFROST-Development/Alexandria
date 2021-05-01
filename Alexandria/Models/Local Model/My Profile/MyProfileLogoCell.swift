//
//  MyProfileLogoCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/23/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyProfileLogoCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    static let identifier = "logoCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
