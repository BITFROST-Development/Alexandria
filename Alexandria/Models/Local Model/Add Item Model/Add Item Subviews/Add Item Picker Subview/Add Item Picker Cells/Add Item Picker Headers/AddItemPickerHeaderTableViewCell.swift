//
//  AddItemPickerHeaderTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/19/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerHeaderTableViewCell: UITableViewCell {
	
	static var identifier = "addItemPickerHeaderTableViewCell"
	
	var controller: AddItemPickerSubviewController!
	var personalID = ""
	
	@IBOutlet weak var sectionTitle: UILabel!
	@IBOutlet weak var searchBarContainerView: UIView!
	@IBOutlet weak var searchField: UITextField!
	@IBOutlet weak var searchIcon: UIImageView!
	@IBOutlet weak var folderPickerButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		searchField.delegate = controller
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func searchButtonPressed(_ sender: Any) {
		searchField.endEditing(true)
	}
	
	@IBAction func changeFolderState(_ sender: Any) {
		let alert = UIAlertController(title: "Choosing Folder", message: "You're currently picking a folder. Do you want to move all subfolders or just the files on the current folder to your new folder?", preferredStyle: .alert)
		if folderPickerButton.currentTitle == "Pick Folder"{
			if controller.pickerItem.pickerDetails == "Shared File Picker"{
				alert.message = "You're currently picking a folder to share. Do you want to share all subfolders or just the files in the current folder?"
				alert.addAction(UIAlertAction(title: "Share Files", style: .default, handler: { _ in
					self.pickFiles()
				}))
				alert.addAction(UIAlertAction(title: "Share Files & Subfolders", style: .cancel, handler: {_ in
					self.pickSubfolders()
				}))
			} else {
				alert.addAction(UIAlertAction(title: "Move Files", style: .default, handler: { _ in
					self.pickFiles()
				}))
				alert.addAction(UIAlertAction(title: "Move Files & Subfolders", style: .cancel, handler: {_ in
					self.pickSubfolders()
				}))
			}
		} else {
			if controller.pickerItem.pickerDetails == "Shared File Picker"{
				alert.message = "You're currently deselecting a folder to share. Do you want to deselect all folder content or just its subfolders?"
			} else {
				alert.message = "You're currently deselecting a folder. Do you want to deselect all folder content or just its subfolders?"
			}
			alert.addAction(UIAlertAction(title: "Deselect Subfolders", style: .default, handler: {_ in
				self.unpickSubfolders()
			}))
			alert.addAction(UIAlertAction(title: "Deselect All Content", style: .cancel, handler: {_ in
				self.unpickAll()
			}))
		}
		controller.present(alert,animated: true)
	}
	
	func pickSubfolders(){
		let currentFolder: Folder = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID == self.personalID}).first!
		controller.pickedItems.append(controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID == self.personalID}).first!)
		for child in currentFolder.childrenIDs{
			controller.pickedItems.removeAll(where: {$0.personalID! == child.value})
		}
		folderPickerButton.setTitle("Unpick Folder", for: .normal)
	}
	
	func unpickSubfolders(){
		let currentFolder: Folder = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID == self.personalID}).first!
		controller.pickedItems.removeAll(where: {$0.personalID == personalID})
		for child in currentFolder.childrenIDs{
			if let _ = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID! == child.value}).first{
				continue
			} else if !controller.pickedItems.contains(where: {$0.personalID! == child.value}){
				if let book = controller.controller.controller.realm.objects(Book.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(book)
				} else if let notebook = controller.controller.controller.realm.objects(Notebook.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(notebook)
				} else if let set = controller.controller.controller.realm.objects(TermSet.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(set)
				}
			}
		}
		folderPickerButton.setTitle("Pick Folder", for: .normal)
	}
	
	func pickFiles(){
		let currentFoler: Folder = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID == self.personalID}).first!
		for child in currentFoler.childrenIDs{
			if let _ = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID! == child.value}).first{
				continue
			} else if !controller.pickedItems.contains(where: {$0.personalID == child.value}){
				if let book = controller.controller.controller.realm.objects(Book.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(book)
				} else if let notebook = controller.controller.controller.realm.objects(Notebook.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(notebook)
				} else if let set = controller.controller.controller.realm.objects(TermSet.self).filter({$0.personalID! == child.value}).first{
					controller.pickedItems.append(set)
				}
			}
		}
		controller.pickerCollectionView.performBatchUpdates({controller.pickerCollectionView.reloadData()}, completion: nil)
	}
	
	func unpickAll(){
		let currentFoler: Folder = controller.controller.controller.realm.objects(Folder.self).filter({$0.personalID == self.personalID}).first!
		controller.pickedItems.removeAll(where: {$0.personalID == personalID})
		for child in currentFoler.childrenIDs{
			controller.pickedItems.removeAll(where: {$0.personalID! == child.value})
		}
		folderPickerButton.setTitle("Pick Folder", for: .normal)
	}
	
}
