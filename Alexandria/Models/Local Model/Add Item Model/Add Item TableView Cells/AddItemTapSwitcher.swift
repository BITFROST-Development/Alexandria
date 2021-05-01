//
//  AddFileShelfPickerTrigger.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/14/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemTapSwitcher: UITableViewCell {

    static var identifier = "addItemTapSwitcher"
    
    @IBOutlet weak var fieldDescription: UILabel!
    @IBOutlet weak var fieldTitle: UILabel!
    @IBOutlet weak var colorIndicator: UIImageView!
    @IBOutlet weak var colorShadow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView?.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
