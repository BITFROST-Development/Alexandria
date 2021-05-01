//
//  InlinePickerFilterNewItemTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/5/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class InlinePickerFilterNewItemTableViewCell: UITableViewCell {
	
	static var identifier = "inlinePickerFilterNewItemTableViewCell"
	
	@IBOutlet weak var itemTitle: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
