//
//  InlinePickerFilterTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/2/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class InlinePickerFilterTableViewCell: UITableViewCell {

	static var identifier = "inlinePickerFilterTableViewCell"
	
	@IBOutlet weak var selectedIndicator: UIImageView!
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var itemKind: UILabel!
	var isPicked = false
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		let checkedImage = UIImage(systemName: "checkmark.circle.fill")
		let uncheckedImage = UIImage(systemName: "circle")
		if isPicked && selected{
			selectedIndicator.image = uncheckedImage
			isPicked = false
		} else if !isPicked && selected{
			selectedIndicator.image = checkedImage
			isPicked = true
		}
    }
    
}
