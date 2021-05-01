//
//  AddItemPickerElementTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/13/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerElementTableViewCell: UITableViewCell {
	static var identifier = "addItemPickerElementTableViewCell"
	
	var controller: AddItemPickerSubviewController!
	var currentFile: InlinePickerItem!
	var isPicked = false
	var singleSelection = true
	var required = true

	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var itemKind: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
		if isPicked && selected{
			if (singleSelection && !required) || (!singleSelection && controller.pickedElements.count > 1){
				itemTitle.textColor = .black
				itemKind.textColor = AlexandriaConstants.alexandriaRed
				isPicked = false
				self.backgroundColor = .white
				controller.pickedElements.removeAll(where: {$0 == currentFile})
				controller.pickedElementCells.removeAll(where: {$0 == self})
			}
		} else if !isPicked && selected{
			if let folderItem = currentFile as? Folder{
				controller.futureParent = folderItem.personalID!
				controller.performSegue(withIdentifier: "toNewPickerView", sender: controller)
			} else {
				if singleSelection{
					for item in controller.pickedElementCells{
						item.itemTitle.textColor = .black
						item.itemKind.textColor = AlexandriaConstants.alexandriaRed
						item.isPicked = false
						item.backgroundColor = .white
					}
					controller.pickedItemCells.removeAll()
					controller.pickedItems.removeAll()
				}
				itemTitle.textColor = .white
				itemKind.textColor = .white
				isPicked = true
				self.backgroundColor = AlexandriaConstants.alexandriaBlue
				controller.pickedElements.append(currentFile)
				controller.pickedElementCells.append(self)
			}
		}
    }
    
}
