//
//  CreateNewShelf.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class CreateNewShelf: UITableViewCell {
    
    static var identifier = "createNewShelfCell"
    
    var controller: ShelfListViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func toNewShelf(_ sender: Any) {
        controller.toCreateShelf()
    }
    
}
