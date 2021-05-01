//
//  AddItemClueManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/25/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import MobileCoreServices
import PDFKit

extension AddItemViewController{
	func loadAddTableView(){
		addItemView.register(UINib(nibName: "AddItemOptionTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemOptionTableViewCell.identifier)
		tableManager = AddItemAddSubItemViewManager()
		tableManager.controller = self
		tableManager.clueManager = AddItemClueManager()
		tableManager.clueManager.controller = self
		tableManager.clueManager.realm = controller.realm
		addItemView.delegate = tableManager
		addItemView.dataSource = tableManager
		addItemView.alpha = 0
		addItemView.layer.cornerRadius = 10
	}
	
//	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//		let pickedFile = urls[0]
//		if pickedFile.lastPathComponent.split(separator: ".").last == "pdf" {
//			tableManager.clueManager.itemNameClue = pickedFile.deletingPathExtension().lastPathComponent
//			let pdfDoc = PDFDocument(url: pickedFile)
//			tableManager.clueManager.itemAuthorClue = pdfDoc?.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String
//			tableManager.clueManager.itemYearClue = pdfDoc?.documentAttributes?[PDFDocumentAttribute.creationDateAttribute] as? String
//			let page = pdfDoc?.page(at: 0)
//			let pageSize = page?.bounds(for: .mediaBox)
//			let pdfScale = 180 / pageSize!.width
//			let scale = UIScreen.main.scale * pdfScale
//			let screenSize = CGSize(width: pageSize!.width * scale, height: pageSize!.height * scale)
//			tableManager.clueManager.itemImageClue = [page!.thumbnail(of: screenSize, for: .mediaBox)]
//			tableManager.clueManager.itemOriginalLocationClue = pickedFile
//			self.performSegue(withIdentifier: "toNewSubItem", sender: controller)
//		} else {
//
//		}
//	}
}

class AddItemClueManager: AddItemClueDelegate{
	var controller: AddItemViewController!
	var realm = try! Realm(configuration: AppDelegate.realmConfig)
	var loggedIn = false
	var addItemKindSelected: String! = ""
	var itemNameClue: String?
	var itemAuthorClue: String?
	var itemYearClue: String?
	var itemImageClue: [UIImage] = []
	var isEditingClue: Bool = false
	var itemOriginalLocationClue: URL?
	var folderClue: String?
	var collectionClues: [String]?
	var pinClue: Bool?
	var favoriteClue: Bool?
	var goalCategoryClue: String?
	var teamClues: [String]?
	var selectedCoverName: String!
	var selectedPaperName: String!
	var displayedPaperColor: String!
	var displayedOrientation: String!
	
	func refreshView(){
//		switch controller.pickerManager.contentType {
//		case "collections":
//			controller.collections.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		case "goals":
//			controller.goals.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		case "teams":
//			controller.teams.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		case "members":
//			controller.members.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		case "files":
//			controller.childrenItems.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		case "children":
//			controller.childrenItems.append(itemsToPoblate[indexPath.row].personalID ?? "")
//			break
//		default:
//			print("something went wrong")
//		}
		AddIconlessThumbnailTableViewCell.controller = controller
		AddItemTitle.controller = controller
		AddItemDone.controller = controller
		AddItemInlinePickerTableViewCell.controller = controller
		controller.displayingView.reloadData()
//		let cell = (controller.displayingView.cellForRow(at: IndexPath(row: controller.pickerManager.currentIndex, section: 0)) as! AddItemInlinePickerTableViewCell)
//		cell.refreshKeyboard = false
//		cell.picker.refreshPicker()
//		CATransaction.begin()
//		CATransaction.setCompletionBlock({
//			cell = (self.controller.displayingView.cellForRow(at: IndexPath(row: self.controller.pickerManager.currentIndex, section: 0)) as! AddItemInlinePickerTableViewCell)
//			cell.picker.textField.becomeFirstResponder()
//		})
//
//		CATransaction.commit()
	}
}

class AddItemAddSubItemViewManager: UIView, UITableViewDelegate, UITableViewDataSource{
	var controller: AddItemViewController!
	var clueManager: AddItemClueManager!
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		controller.dismissOverlayingViews(UIGestureRecognizer())
		controller.resignFirstResponder()
		clueManager.isEditingClue = false
		clueManager.itemNameClue = controller.pickerManager.currentContent
		if indexPath.row == 0{
			clueManager.addItemKindSelected = "newNote"
			clueManager.itemYearClue = String(Calendar.current.component(.year, from: Date()))
			clueManager.selectedCoverName = clueManager.realm.objects(AlexandriaData.self)[0].defaultCoverStyle
			clueManager.selectedPaperName = clueManager.realm.objects(AlexandriaData.self)[0].defaultPaperStyle
			clueManager.displayedPaperColor = clueManager.realm.objects(AlexandriaData.self)[0].defaultPaperColor
			clueManager.displayedOrientation = clueManager.realm.objects(AlexandriaData.self)[0].defaultPaperOrientation
			clueManager.itemImageClue = [UIImage(named:  clueManager.selectedCoverName)!, UIImage(named: "\(clueManager.selectedPaperName ?? "")/\(clueManager.displayedOrientation ?? "")/\(clueManager.displayedPaperColor ?? "")")!]
			controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
		} else if indexPath.row == 1{
			clueManager.addItemKindSelected = "newSet"
			clueManager.itemYearClue = String(Calendar.current.component(.year, from: Date()))
			clueManager.itemImageClue = [UIImage(named: "cardBlue")!]
			controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
		} else if indexPath.row == 2{
			clueManager.addItemKindSelected = "newFolder"
			clueManager.itemImageClue = [UIImage(named: "folderIconBlue")!]
			controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
		}
		UIView.animate(withDuration: 0.3, animations: {
			tableView.deselectRow(at: indexPath, animated: true)
		})  
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if controller.controller.addItemKindSelected == "newFolder"{
			return 3
		} else {
			return 4
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemOptionTableViewCell.identifier, for: indexPath) as! AddItemOptionTableViewCell
		cell.contentView.backgroundColor = AlexandriaConstants.alexandriaBlue
		cell.firstLevel = false
		cell.backgroundColor = AlexandriaConstants.alexandriaBlue
		tableView.backgroundColor = AlexandriaConstants.alexandriaBlue
		if indexPath.row == 0{
			cell.addItemLabel.text = "New notebook"
			cell.addItemIcon.image = UIImage(systemName: "doc.fill")
			cell.separator.alpha = 1
		} else if indexPath.row == 1{
			cell.addItemLabel.text = "New flashcard set"
			cell.addItemIcon.image = UIImage(systemName: "rectangle.stack.fill")
			cell.separator.alpha = 1
		} else if indexPath.row == 2{
			cell.addItemLabel.text = "New folder"
			cell.addItemIcon.image = UIImage(systemName: "folder.fill")
			cell.separator.alpha = 0
		}
		return cell
	}
	
}
