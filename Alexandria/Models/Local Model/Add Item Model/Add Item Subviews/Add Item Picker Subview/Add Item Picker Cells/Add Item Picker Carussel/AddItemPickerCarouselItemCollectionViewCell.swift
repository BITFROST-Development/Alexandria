//
//  AddItemPickerCarusselItemCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerCarouselItemCollectionViewCell: UICollectionViewCell {
	
	static var identifier = "addItemPickerCarouselItemCollectionViewCell"
	
	var controller: AddItemPickerSubviewController!
	var currentCell: CarouselItem!
	
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var itemBackgroundView: UIView!
	@IBOutlet weak var itemImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	@IBAction func selectItem(_ sender: Any) {
		for cell in controller.pickedCarouselCells{
			cell.itemBackgroundView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.08))
		}
		controller.pickedCarouselCells.removeAll()
		controller.pickedCarousels.removeAll()
		itemBackgroundView.backgroundColor = AlexandriaConstants.alexandriaRed
		controller.pickedCarouselCells.append(self)
		controller.pickedCarousels.append(currentCell)
	}
	
}

class CarouselItem: Equatable {
	static func == (lhs: CarouselItem, rhs: CarouselItem) -> Bool {
		return lhs.imageName == rhs.imageName && lhs.itemTitle == rhs.itemTitle
	}
	
	var image: UIImage
	var imageName: String
	var itemTitle: String
	
	init(itemImage: UIImage, itemImageName: String, itemTitleImage: String) {
		self.image = itemImage
		self.imageName = itemImageName
		self.itemTitle = itemTitleImage
	}
}
