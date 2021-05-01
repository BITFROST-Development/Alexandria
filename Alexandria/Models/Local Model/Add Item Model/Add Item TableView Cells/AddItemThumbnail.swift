//
//  AddFileThumbnail.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemThumbnail: UITableViewCell {

    static var identifier = "addItemThumbnail"
    @IBOutlet weak var fileThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print(self.layer.frame.height)
        fileThumbnail.image = fileThumbnail.image?.withRenderingMode(.alwaysTemplate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
}
