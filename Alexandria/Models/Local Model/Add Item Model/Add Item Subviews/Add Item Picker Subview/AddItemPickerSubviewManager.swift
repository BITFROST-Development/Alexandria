//
//  AddItemPickerSubviewManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/10/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import SocketIO

extension AddItemPickerSubviewController {
	@IBAction func donePicking(_ sender: Any){
		if displayingType == "categories" || displayingType == "styles"{
			switch pickerItem.pickerDetails {
			case "Notebook Cover":
				controller.selectedCoverName = pickedImages[0].name
				controller.displayingView.reloadData()
				break
			case "Notebook Paper":
				controller.selectedPaperName = String(pickedCarousels[0].imageName[pickedCarousels[0].imageName.startIndex...(pickedCarousels[0].imageName.lastIndex(where: {$0.isNumber}) ?? pickedCarousels[0].imageName.endIndex)])
				break
			case "Flashcard Color":
				controller.itemImage[0] = pickedImages[0].image
				switch pickedImages[0].name {
				case "cardBlack":
					controller.iconColor = "Black"
					break
				case "cardBlue":
					controller.iconColor = "Blue"
					break
				case "cardGreen":
					controller.iconColor = "Green"
					break
				case "cardGrey":
					controller.iconColor = "Grey"
					break
				case "cardOrange":
					controller.iconColor = "Orange"
					break
				case "cardPink":
					controller.iconColor = "Pink"
					break
				case "cardPurple":
					controller.iconColor = "Purple"
					break
				case "cardRed":
					controller.iconColor = "Red"
					break
				case "cardTurquoise":
					controller.iconColor = "Turquoise"
					break
				case "cardYellow":
					controller.iconColor = "Yellow"
					break
				default:
					print("error")
				}
				break
			case "Folder Color":
				controller.itemImage[0] = pickedImages[0].image
				switch pickedImages[0].name {
				case "folderIconBlack":
					controller.iconColor = "Black"
					break
				case "folderIconBlue":
					controller.iconColor = "Blue"
					break
				case "folderIconGreen":
					controller.iconColor = "Green"
					break
				case "folderIconGrey":
					controller.iconColor = "Grey"
					break
				case "folderIconOrange":
					controller.iconColor = "Orange"
					break
				case "folderIconPink":
					controller.iconColor = "Pink"
					break
				case "folderIconPurple":
					controller.iconColor = "Purple"
					break
				case "folderIconRed":
					controller.iconColor = "Red"
					break
				case "folderIconTurquoise":
					controller.iconColor = "Turquoise"
					break
				case "folderIconYellow":
					controller.iconColor = "Yellow"
					break
				default:
					print("error")
				}
				break
			case "Item Color":
				controller.iconColor = pickedImages[0].name
				break
			default:
				controller.selectedPictureName = pickedImages[0].name
			}
		} else if displayingType == "items"{
			if pickerItem.pickerDetails == "Children Picker"{
				controller.childrenItems = []
				for item in pickedItems{
					controller.childrenItems.append(item.personalID!)
				}
			} else if pickerItem.pickerDetails == "Shared File Picker"{
				
			} else {
				controller.folder = currentParent
			}
		} else if displayingType == "elements"{
			if pickerItem.pickerDetails == "Children Picker"{
				controller.childrenItems = []
				for item in pickedElements{
					controller.childrenItems.append(item.personalID!)
				}
			} else if pickerItem.pickerDetails == "Parent Picker"{
				controller.folder = currentParent
			} else if pickerItem.pickerDetails == "Collection Picker"{
				controller.collections = []
				for item in pickedElements{
					controller.collections.append(item.personalID!)
				}
			} else if pickerItem.pickerDetails == "Goal Picker"{
				controller.goals = []
				for item in pickedElements{
					controller.goals.append(item.personalID!)
				}
			} else if pickerItem.pickerDetails == "Team Picker"{
				controller.teams = []
				for item in pickedElements{
					controller.teams.append(item.personalID!)
				}
			} else if pickerItem.pickerDetails == "Member Picker"{
				controller.members = []
				for item in pickedElements{
					controller.members.append(item.personalID!)
				}
			}
		}
		controller.displayingView.reloadData()
		pickerItem.rootPicker.dismiss(animated: true, completion: nil)
	}
	
	@objc func cancelEdit(_ sender: Any){
		pickerItem.rootPicker.dismiss(animated: true, completion: nil)
	}
	
	@objc func goBack(_ sender: Any){
		navigationController?.popViewController(animated: true)
	}
}

extension AddItemPickerSubviewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if displayingType == "categories"{
			performSegue(withIdentifier: "toNewPickerView", sender: self)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if pickerItem.pickerDetails == "Notebook Paper"{
			if indexPath.row > 0{
				if controller.displayedOrientation == "Portrait"{
					return 260
				} else {
					return 180
				}
			} else {
				return UITableView.automaticDimension
			}
		} else {
			return UITableView.automaticDimension
		}
	}
}

extension AddItemPickerSubviewController: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayingCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if displayingType == "elements"{
			if indexPath.row > 0{
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerElementTableViewCell.identifier, for: indexPath) as! AddItemPickerElementTableViewCell
				cell.controller = self
				cell.currentFile = displayingElements[indexPath.row - 1]
				cell.itemTitle.text = cell.currentFile.name
				if let _ = cell.currentFile as? Folder{
					cell.itemKind.text = "Folder"
				} else if let _ = cell.currentFile as? Book{
					cell.itemKind.text = "Imported File"
				} else if let _ = cell.currentFile as? Notebook{
					cell.itemKind.text = "Notebook"
				} else if let _ = cell.currentFile as? TermSet{
					cell.itemKind.text = "Flashcard Set"
				} else if let _ = cell.currentFile as? FileCollection{
					cell.itemKind.text = "Collection"
				}
				if pickerItem.pickerDetails == "Parent Picker"{
					cell.singleSelection = true
					cell.required = false
				} else {
					cell.singleSelection = false
					cell.required = false
				}
				cell.backgroundColor = .white
				cell.itemTitle.textColor = .black
				cell.itemKind.textColor = AlexandriaConstants.alexandriaRed
				cell.required = false
				for element in pickedElements{
					if cell.currentFile.personalID == element.personalID{
						cell.backgroundColor = AlexandriaConstants.alexandriaBlue
						cell.itemTitle.textColor = .white
						cell.itemKind.textColor = .white
						break
					}
				}
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerHeaderTableViewCell.identifier, for: indexPath) as! AddItemPickerHeaderTableViewCell
				cell.sectionTitle.text = (pickerItem.pickerDetails == "Parent Picker" || pickerItem.pickerDetails == "Children Picker") ? ((currentParent == "") ? "Pick a Folder" : "Click Done To Place Item Here") : ((pickerItem.pickerDetails == "Collection Picker") ? "Pick Some Collections" : ((pickerItem.pickerDetails == "Goal Picker") ? "Pick Some Goals" : ((pickerItem.pickerDetails == "Team Picker") ? "Pick Some Teams" : ((pickerItem.pickerDetails == "Member Picker") ? "Pick Some Members" : "Pick Some Files"))))
				if pickerItem.pickerDetails != "Parent Picker" || pickerItem.pickerDetails != "Children Picker" || pickerItem.pickerDetails != "Shared File Picker"{
					cell.folderPickerButton.alpha = 0
				} else {
					cell.folderPickerButton.alpha = 1
				}
				cell.personalID = currentParent
				return cell
			}
		} else if displayingType == "categories"{
			if indexPath.row > 0{
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerCategoryTableViewCell.identifier, for: indexPath) as! AddItemPickerCategoryTableViewCell
				cell.controller = self
				cell.currentCategory = displayingCategories[indexPath.row - 1]
				switch displayingCategories[indexPath.row - 1] {
				case "notebookCircles":
					cell.categoryTitle.text = "Circles"
					break
				case "notebookCubes":
					cell.categoryTitle.text = "Cubes"
					break
				case "notebookFlowers":
					cell.categoryTitle.text = "Flowers"
					break
				case "notebookPatterns":
					cell.categoryTitle.text = "Patterns"
					break
				case "notebookPlain":
					cell.categoryTitle.text = "Plain"
					break
				case "notebookTech":
					cell.categoryTitle.text = "Tech"
					break
				case "notebookTextures":
					cell.categoryTitle.text = "Textures"
					break
				default:
					print("no fiting category to \(currentCategory)")
				}
				if indexPath.row + 1 == displayingCount{
					cell.separator.alpha = 0
				} else {
					cell.separator.alpha = 1
				}
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerHeaderTableViewCell.identifier, for: indexPath) as! AddItemPickerHeaderTableViewCell
				cell.sectionTitle.text = "Pick a category"
				cell.searchBarContainerView.alpha = 0
				cell.folderPickerButton.alpha = 0
				cell.sectionTitle.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 15).isActive = true
				return cell
			}
		} else {
			if indexPath.row > 0{
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerCarouselTableViewCell.identifier, for: indexPath) as! AddItemPickerCarouselTableViewCell
				cell.controller = self
				cell.currentCarouselContent = displayingCarousels[indexPath.row - 1].carouselContent
				cell.sectionTitle.text = displayingCarousels[indexPath.row - 1].carouselTitle
				if indexPath.row + 1 == displayingCount{
					cell.separatorView.alpha = 0
				} else {
					cell.separatorView.alpha = 1
				}
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerHeaderTableViewCell.identifier, for: indexPath) as! AddItemPickerHeaderTableViewCell
				cell.sectionTitle.text = "Pick a style"
				cell.searchBarContainerView.alpha = 0
				cell.folderPickerButton.alpha = 0
				cell.sectionTitle.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 15).isActive = true
				return cell
			}
			
		}
		
	}
	
	
}

extension AddItemPickerSubviewController: UICollectionViewDelegate{
	
}

extension AddItemPickerSubviewController: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return displayingCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if displayingType == "items"{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemPickerFolderItemCollectionViewCell.identifier, for: indexPath) as! AddItemPickerFolderItemCollectionViewCell
			cell.controller = self
			cell.currentFile = displayingItems[indexPath.row]
			if pickerItem.pickerDetails == "Parent Picker"{
				cell.singleSelection = true
				cell.required = true
			} else if pickerItem.pickerDetails == "Children Picker"{
				cell.singleSelection = false
				cell.required = false
			}
			if pickedItems.contains(where: {$0.personalID == cell.currentFile.personalID}){
				cell.selectedView.alpha = 1
				cell.isPicked = true
				cell.itemTitle.textColor = .white
				if !pickedItemCells.contains(cell){
					pickedItemCells.append(cell)
				}
			} else {
				cell.selectedView.alpha = 0
				cell.isPicked = false
				cell.itemTitle.textColor = AlexandriaConstants.alexandriaBlue
			}
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemPickerImageCollectionViewCell.idetifier, for: indexPath) as! AddItemPickerImageCollectionViewCell
			cell.controller = self
			cell.currentImage = displayingImages[indexPath.row]
			if pickedImages.contains(where: {$0.name == cell.currentImage.name}){
				cell.selectedIndicator.alpha = 1
				cell.picked = true
				if !pickedImageCells.contains(cell){
					pickedImageCells.append(cell)
				}
			} else {
				cell.selectedIndicator.alpha = 0
				cell.picked = false
			}
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader{
			let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AddItemPickerHeaderCollectionReusableView.identifier, for: indexPath) as! AddItemPickerHeaderCollectionReusableView
			if displayingType == "items"{
				view.sectionTitle.text = pickerItem.pickerDetails == "Parent Picker" ? ((currentParent == "") ? "Pick a Folder" : "Click Done To Place Item Here") : (pickerItem.pickerDetails == "Children Picker" ? ((currentParent == "") ? "Pick Files" : "Click Done To Finish Picking"): ((currentParent == "") ? "Pick Files To Share" : "Pick Files/Folders To Share"))
				view.folderPickerButton.alpha = pickerItem.pickerDetails == "Parent Picker" ? ((currentParent == "") ? 0 : 0) : (pickerItem.pickerDetails == "Children Picker" ? ((currentParent == "") ? 0 : 1): ((currentParent == "") ? 0 : 1))
			} else {
				view.sectionTitle.text = "Pick a style"
				view.folderPickerButton.alpha = 0
				view.searchBarContainerView.alpha = 0
				view.sectionTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15).isActive = true
			}
			view.controller = self
			return view
		}
		
		assert(false, "Unexpected element kind")
	}
}

extension AddItemPickerSubviewController: UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
	}
	
	func textFieldDidChangeSelection(_ textField: UITextField) {
		if displayingType == "items"{
			if textField.text != nil && textField.text != ""{
				displayingItems = fullItemsContent.filter({$0.name?.contains(textField.text!) ?? false})
			} else {
				displayingItems = fullItemsContent
			}
			displayingCount = displayingItems.count
			pickedItemCells.removeAll()
			pickerCollectionView.performBatchUpdates(pickerCollectionView.reloadData, completion: nil)
		} else if displayingType == "elements"{
			if textField.text != nil && textField.text != ""{
				displayingElements = fullElementsContent.filter({$0.name?.contains(textField.text!) ?? false})
				if pickerItem.pickerDetails == "Member Picker"{
					Socket.sharedInstance.requestUsersWithUsername(textField.text!, completion: {users in
						self.displayingElements.append(contentsOf: users)
						self.displayingCount = self.displayingElements.count + 1
						self.pickedElementCells.removeAll()
						self.pickerTableView.performBatchUpdates(self.pickerTableView.reloadData, completion: nil)
					})
				}
			} else {
				displayingElements = fullElementsContent
			}
			displayingCount = displayingElements.count + 1
			pickedElementCells.removeAll()
			pickerTableView.performBatchUpdates(pickerTableView.reloadData, completion: nil)
		}
	}
	
}
