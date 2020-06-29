//
//  MyProfileContentCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/23/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyProfileContentCell: UITableViewCell {
    
    @IBOutlet weak var field: UILabel!
    @IBOutlet weak var content: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
