//
//  AddItemPickerImageCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/13/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerImageCollectionViewCell: UICollectionViewCell {
	
	static var idetifier = "addItemPickerImageCollectionViewCell"
	
	var controller: AddItemPickerSubviewController!
	var selectedImage: PickerStyleImageItem!
	var currentImage: PickerStyleImageItem!{
		get{
			return selectedImage
		} set (newImage){
			selectedImage = newImage
			itemImage.image = newImage.image
		}
	}
	
	var picked = false
	var singleSelection = true
	var required = true
	
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var selectedIndicator: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectedIndicator.layer.cornerRadius = 10
		selectedIndicator.alpha = 0
    }
	
	@IBAction func selectImage(_ sender: Any) {
		if picked {
			if (singleSelection && !required) || (!singleSelection && controller.pickedImages.count > 1){
				selectedIndicator.alpha = 0
				picked = false
				controller.pickedImageCells.removeAll(where: {$0 == self})
				controller.pickedImages.removeAll(where: {$0 == self.selectedImage})
			}
		} else {
			selectedIndicator.alpha = 1
			picked = true
			if singleSelection{
				for cell in controller.pickedImageCells{
					cell.selectedIndicator.alpha = 0
					cell.picked = false
				}
				controller.pickedImageCells.removeAll()
				controller.pickedImages.removeAll()
			}
			controller.pickedImageCells.append(self)
			controller.pickedImages.append(self.selectedImage)
		}
	}
	
}

class PickerStyleImageItem: Equatable {
	var name = ""
	var image: UIImage {
		get{
			var returningImage = UIImage(named: name)
			if returningImage == nil || name == "Black"{
				let undelyingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 120, height: 120)))
				undelyingView.layer.cornerRadius = 15
				switch name {
				case "Blue":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 137/255, green: 179/255, blue: 231/255, alpha: 1))
					break
				case "Black":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1))
					break
				case "Green":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 148/255, green: 231/255, blue: 137/255, alpha: 1))
					break
				case "Grey":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1))
					break
				case "Orange":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 185/255, blue: 137/255, alpha: 1))
					break
				case "Pink":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 137/255, blue: 221/255, alpha: 1))
					break
				case "Purple":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 161/255, green: 137/255, blue: 231/255, alpha: 1))
					break
				case "Red":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 137/255, blue: 137/255, alpha: 1))
					break
				case "Turquoise":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 137/255, green: 231/255, blue: 207/255, alpha: 1))
					break
				case "Yellow":
					undelyingView.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 225/255, blue: 137/255, alpha: 1))
					break
				default:
					print("error")
				}
				let renderer = UIGraphicsImageRenderer(bounds: undelyingView.bounds)
				returningImage = renderer.image { rendererContext in
					undelyingView.layer.render(in: rendererContext.cgContext)
				}
			}
			return  returningImage!
		}
	}
	
	init(_ assetName: String) {
		self.name = assetName
	}
	
	static func == (_ lhs: PickerStyleImageItem, _ rhs: PickerStyleImageItem) -> Bool{
		return lhs.name == rhs.name
	}
}
