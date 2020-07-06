//
//  ShelveListCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/5/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ShelfListCell: UITableViewCell {

    static var identifier = "shelfListCell"
    @IBOutlet weak var shelfName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
