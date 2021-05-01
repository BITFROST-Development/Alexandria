//
//  AddFileMetadataComponent.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemMetadataComponent: UITableViewCell {

    static var identifier = "addItemMetadataComponent"
    
    var controller: AddItemViewController!
    
    @IBOutlet weak var metadataName: UILabel!
    @IBOutlet weak var metadataContent: UITextField!
    @IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var clearIcon: UIImageView!
	@IBOutlet weak var clearIconTrailingConstraint: NSLayoutConstraint!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        metadataContent.delegate = self
		clearIconTrailingConstraint.constant = 65
		clearIconTrailingConstraint.isActive = true
		self.updateConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clearField(_ sender: Any) {
        metadataContent.text = ""
        clearButton.alpha = 0.0
		clearIcon.alpha = 0.0
		clearIconTrailingConstraint.constant = 65 - 32
		clearIconTrailingConstraint.isActive = true
		self.updateConstraints()
    }
    
}

extension AddItemMetadataComponent: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if metadataName.text == "Objective"{
			let allowedCharacters = CharacterSet.decimalDigits
			let characterSet = CharacterSet(charactersIn: string)
			let isValid = allowedCharacters.isSuperset(of: characterSet)
			if !isValid{
				return false
			}
		}
		
		if textField.text != "" && textField.text?.count == 1 && string.isEmpty{
            clearButton.alpha = 0.0
			clearIcon.alpha = 0.0
			clearIconTrailingConstraint.constant = 65 - 32
			clearIconTrailingConstraint.isActive = true
			self.updateConstraints()
            return true
        } else {
            clearButton.alpha = 1.0
			clearIcon.alpha = 1.0
			clearIconTrailingConstraint.constant = 65
			clearIconTrailingConstraint.isActive = true
			self.updateConstraints()
            return true
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if metadataName.text == "Author" {
            controller.itemAuthor = textField.text ?? ""
        } else {
            controller.itemYear = textField.text ?? ""
        }
    }
	func textFieldDidBeginEditing(_ textField: UITextField) {
		var neededVisibleSpace = controller.displayingView.convert(controller.displayingView.rectForRow(at: controller.displayingView.indexPath(for: self)!), to: controller.displayingView.superview).origin
//		neededVisibleSpace.y += 175
		controller.keysShouldNotCover(neededVisibleSpace)
	}
}
