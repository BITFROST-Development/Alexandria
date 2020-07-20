//
//  AddItemCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/30/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemCell: UITableViewCell {
    
    var controller: MyShelvesViewController!
    @IBOutlet weak var itemName: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func itemPressed(_ sender: Any) {
        if itemName.currentTitle == "Add new file"{
            controller.addNewFileView()
        } else {
            controller.addNewShelfView()
        }
    }
}
