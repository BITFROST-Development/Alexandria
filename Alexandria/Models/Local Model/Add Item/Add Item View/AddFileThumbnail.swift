//
//  AddFileThumbnail.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileThumbnail: UITableViewCell {

    static var identifier = "addFileThumbnail"
    @IBOutlet weak var fileThumbnail: FileThumbnail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print(self.layer.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
}

class FileThumbnail: UIImageView {

}
