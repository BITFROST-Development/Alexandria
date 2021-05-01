//
//  AddItemInlinePickerTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/28/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemInlinePickerTableViewCell: UITableViewCell, InlinePickerDelegate {

	static var identifier = "addItemInlinePickerTableViewCell"
	static var controller: AddItemViewController!
	
	var realm: Realm {
		get{
			return AppDelegate.realm
		}
	}
	var pickerCase: String {
		get{
			return (sectionTitle.text == "Children") ? "children" : (sectionTitle.text == "Collections") ? "collections" : (sectionTitle.text == "Related Goals") ? "goals" : (sectionTitle.text == "Share with") ? "teams" : (sectionTitle.text == "Files" || sectionTitle.text == "Shared Files") ? "files" : (sectionTitle.text == "Shared Goals") ? "goals" : "members"
		}
	}
	var neededHeight: CGFloat = UITableView.automaticDimension
	var currentIndex: Int!
	var refreshKeyboard = false
	@IBOutlet weak var sectionTitle: UILabel!
	@IBOutlet weak var picker: InlinePicker!
	@IBOutlet weak var spaceBottom: NSLayoutConstraint!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		picker.delegate = self
		picker.typingDelegate = self
		AddItemInlinePickerTableViewCell.controller.neededHeight = neededHeight
		let thisIndexPath = AddItemInlinePickerTableViewCell.controller.displayingView.indexPath(for: self)
		if thisIndexPath != nil && AddItemInlinePickerTableViewCell.controller.displayingView.cellForRow(at: thisIndexPath!)?.frame.height != neededHeight{
			AddItemInlinePickerTableViewCell.controller.displayingView.reloadRows(at:((thisIndexPath != nil) ? [thisIndexPath!] : []), with: .automatic)
		}
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
		if self.contentView.alpha < 1{
			super.setSelected(false, animated: animated)
		}
    }
	
	func needs(_ space: CGFloat){
		spaceBottom.constant = space - 9
		self.frame.size.height = space
		AddItemInlinePickerTableViewCell.controller.displayingView.beginUpdates()
		AddItemInlinePickerTableViewCell.controller.displayingView.endUpdates()
		if refreshKeyboard{
			picker.textField.becomeFirstResponder()
		}
	}
	
	func itemsUpdated(_ items: [InlinePickerItem]){
		var newChildren: [String] = []
		for item in items{
			newChildren.append(item.personalID!)
		}
		if sectionTitle.text == "Files" || sectionTitle.text == "Shared Files"{
			AddItemInlinePickerTableViewCell.controller.childrenItems = newChildren
		} else if sectionTitle.text == "Collections"{
			AddItemInlinePickerTableViewCell.controller.collections = newChildren
		} else if sectionTitle.text == "Related Goals" || sectionTitle.text == "Shared Goals"{
			AddItemInlinePickerTableViewCell.controller.goals = newChildren
		} else if sectionTitle.text == "Share With"{
			AddItemInlinePickerTableViewCell.controller.teams = newChildren
		} else if sectionTitle.text == "Members"{
			AddItemInlinePickerTableViewCell.controller.members = newChildren
		}
		refreshKeyboard = picker.textField.isFirstResponder
		picker.refreshPicker()
	}
    
}


extension AddItemInlinePickerTableViewCell: UITextFieldDelegate{
	func textFieldDidBeginEditing(_ textField: UITextField) {
		AddItemInlinePickerTableViewCell.controller.inlinePickerTable.frame.origin = CGPoint(x: picker.frame.maxX - AddItemInlinePickerTableViewCell.controller.inlinePickerTable.frame.width, y: AddItemInlinePickerTableViewCell.controller.displayingView.convert(AddItemInlinePickerTableViewCell.controller.displayingView.rectForRow(at: AddItemInlinePickerTableViewCell.controller.displayingView.indexPath(for: self)!), to: AddItemInlinePickerTableViewCell.controller.displayingView.superview).maxY)
		let neededVisibleSpace = AddItemInlinePickerTableViewCell.controller.inlinePickerTable.frame.origin
//		neededVisibleSpace.y += AddItemInlinePickerTableViewCell.controller.inlinePickerTable.frame.height
		AddItemInlinePickerTableViewCell.controller.keysShouldNotCover(neededVisibleSpace)
		AddItemInlinePickerTableViewCell.controller.refreshPicker(pickerCase, currentIndex, containing: textField.text ?? "")
		if textField.text != "" && textField.text != nil{
			UIView.animate(withDuration: 0.3, animations: {
				AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha = 1
			})
		}
	}
	
	func textFieldDidChangeSelection(_ textField: UITextField) {
		AddItemInlinePickerTableViewCell.controller.refreshPicker(pickerCase, currentIndex, containing: textField.text ?? "")
		if AddItemInlinePickerTableViewCell.controller.pickerManager.itemsToPoblate.count > 0 && AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha == 0{
			UIView.animate(withDuration: 0.3, animations: {
				AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha = 1
			})
		} else if AddItemInlinePickerTableViewCell.controller.pickerManager.itemsToPoblate.count == 0 && AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha == 1{
			UIView.animate(withDuration: 0.3, animations: {
				AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha = 1
			})
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		AddItemInlinePickerTableViewCell.controller.view.frame.origin.y = 0
		UIView.animate(withDuration: 0.3, animations: {
			AddItemInlinePickerTableViewCell.controller.inlinePickerTable.alpha = 0
		})
	}
}
