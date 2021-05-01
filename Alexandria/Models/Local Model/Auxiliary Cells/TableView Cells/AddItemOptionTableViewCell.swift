//
//  AddItemOptionTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/24/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemOptionTableViewCell: UITableViewCell {

    static var identifier = "addItemOptionTableViewCell"
    
    @IBOutlet weak var addItemLabel: UILabel!
    @IBOutlet weak var addItemIcon: UIImageView!
    @IBOutlet weak var separator: UIView!
	var firstLevel = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
		if firstLevel{
			if selected {
				UIView.animate(withDuration: 0.2, animations: {
					self.contentView.backgroundColor = AlexandriaConstants.alexandriaBlue
				})
			} else {
				UIView.animate(withDuration: 0.2, animations: {
					self.contentView.backgroundColor = AlexandriaConstants.alexandriaRed
				})
			}
		} else {
			if selected {
				UIView.animate(withDuration: 0.2, animations: {
					self.contentView.backgroundColor = AlexandriaConstants.alexandriaRed
				})
			} else {
				UIView.animate(withDuration: 0.2, animations: {
					self.contentView.backgroundColor = AlexandriaConstants.alexandriaBlue
				})
			}
		}
    }
    
}
