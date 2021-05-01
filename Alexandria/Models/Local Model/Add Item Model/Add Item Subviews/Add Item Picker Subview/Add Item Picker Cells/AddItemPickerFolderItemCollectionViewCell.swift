//
//  AddItemPickerFolderItemCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/13/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerFolderItemCollectionViewCell: UICollectionViewCell {

	static var identifier = "addItemPickerFolderItemCollectionViewCell"
	
	var controller: AddItemPickerSubviewController!
	var storedFile: FolderItem!
	var currentFile: FolderItem!{
		get{
			return storedFile
		} set (newItem){
			storedFile = newItem
			itemTitle.text = newItem.name
			if let book = newItem as? Book{
				itemImage.image = UIImage(data: book.thumbnail!.data!)
			} else if let notebook = newItem as? Notebook{
				itemImage.image = UIImage(named: notebook.coverStyle!)
			} else if let set = newItem as? TermSet{
				switch set.color?.colorName {
				case "Blue":
					itemImage.image = UIImage(named: "cardBlue")
					break
				case "Purple":
					itemImage.image = UIImage(named: "cardPurple")
					break
				case "Pink":
					itemImage.image = UIImage(named: "cardPink")
					break
				case "Red":
					itemImage.image = UIImage(named: "cardRed")
					break
				case "Orange":
					itemImage.image = UIImage(named: "cardOrange")
					break
				case "Yellow":
					itemImage.image = UIImage(named: "cardYellow")
					break
				case "Green":
					itemImage.image = UIImage(named: "cardGreen")
					break
				case "Turquoise":
					itemImage.image = UIImage(named: "cardTurquoise")
					break
				case "Grey":
					itemImage.image = UIImage(named: "cardGrey")
					break
				case "Black":
					itemImage.image = UIImage(named: "cardBlack")
					break
				default:
					print("There was an error displaying")
				}
			} else if let folder = newItem as? Folder{
				switch folder.color?.colorName {
				case "Blue":
					itemImage.image = UIImage(named: "folderIconBlue")
					break
				case "Purple":
					itemImage.image = UIImage(named: "folderIconPurple")
					break
				case "Pink":
					itemImage.image = UIImage(named: "folderIconPink")
					break
				case "Red":
					itemImage.image = UIImage(named: "folderIconRed")
					break
				case "Orange":
					itemImage.image = UIImage(named: "folderIconOrange")
					break
				case "Yellow":
					itemImage.image = UIImage(named: "folderIconYellow")
					break
				case "Green":
					itemImage.image = UIImage(named: "folderIconGreen")
					break
				case "Turquoise":
					itemImage.image = UIImage(named: "folderIconTurquoise")
					break
				case "Grey":
					itemImage.image = UIImage(named: "folderIconGrey")
					break
				case "Black":
					itemImage.image = UIImage(named: "folderIconBlack")
					break
				default:
					print("There was an error displaying")
				}
			}
		}
	}
	var isPicked = false
	var singleSelection = true
	var required = true
	
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var selectedView: UIView!
	@IBOutlet weak var plusBadge: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectedView.alpha = 0
		selectedView.layer.cornerRadius = 10
		plusBadge.alpha = 0
    }
	
	@IBAction func selectItem(_ sender: Any) {
		if isPicked{
			if (singleSelection && !required) || (!singleSelection && controller.pickedItems.count > 0){
				itemTitle.textColor = AlexandriaConstants.alexandriaBlue
				isPicked = false
				controller.pickedItemCells.removeAll(where: {($0) == self})
				controller.pickedItems.removeAll(where: {($0).personalID == self.currentFile.personalID})
				UIView.animate(withDuration: 0.3, animations: {
					self.selectedView.alpha = 0
				})
			}
		} else {
			if let pickingFolder = currentFile as? Folder{
				controller.futureParent = pickingFolder.personalID ?? ""
				controller.performSegue(withIdentifier: "toNewPickerView", sender: controller)
			} else if !(controller.pickerItem.pickerDetails == "Parent Picker"){
				itemTitle.textColor = .white
				isPicked = true
				
				if singleSelection{
					for item in controller.pickedItemCells{
						item.itemTitle.textColor = AlexandriaConstants.alexandriaBlue
						item.isPicked = false
						item.selectedView.alpha = 0
					}
					controller.pickedItemCells.removeAll()
					controller.pickedItems.removeAll()
				}
				controller.pickedItemCells.append(self)
				controller.pickedItems.append(self.currentFile)
				UIView.animate(withDuration: 0.3, animations: {
					self.selectedView.alpha = 1
				})
			}
		
		}
	}
	
}
