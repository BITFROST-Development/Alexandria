//
//  AddItemPickerCarusselItemCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerCarouselItemCollectionViewCell: UICollectionViewCell {
	
	var controller: AddItemPickerSubviewController!
	var currentCell = ""
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var itemImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	@IBAction func selectItem(_ sender: Any) {
		for cell in controller.pickedCarussels{
			cell.backgroundView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.08))
		}
		controller.pickedCarussels.removeAll()
		backgroundView.backgroundColor = AlexandriaConstants.alexandriaRed
		controller.pickedCarussels.append(self)
	}
	
}


