//
//  AddFileShelfPickerTrigger.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/14/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileShelfPickerTrigger: UITableViewCell {

    static var idetifier = "addFileShelfName"
    @IBOutlet weak var shelfName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(self.layer.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
