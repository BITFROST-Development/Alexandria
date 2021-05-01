//
//  AddItemPickerCategoryTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/13/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerCategoryTableViewCell: UITableViewCell {

	static var identifier = "addItemPickerCategoryTableViewCell"
	
	var controller: AddItemPickerSubviewController!
	var currentCategory: String!
	
	@IBOutlet weak var categoryTitle: UILabel!
	@IBOutlet weak var separator: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
		controller.futureCategory = currentCategory
    }
    
}
