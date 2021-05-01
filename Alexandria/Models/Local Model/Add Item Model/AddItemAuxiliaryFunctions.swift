//
//  AddItemAuxiliaryFunctions.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/2/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension AddItemViewController{
	func setupDoneCell(_ tableView: UITableView, _ indexPath: IndexPath) -> AddItemDone{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemDone.identifier, for: indexPath) as! AddItemDone
		
		return cell
	}
	
	func setupYearCell(_ tableView: UITableView, _ indexPath: IndexPath) -> AddItemMetadataComponent{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemMetadataComponent.identifier, for: indexPath) as! AddItemMetadataComponent
		cell.controller = self
		cell.metadataName.text = "Year"
		cell.metadataContent.placeholder = "Year"
		cell.metadataContent.text = itemYear
		if itemYear == ""{
			cell.clearButton.alpha = 0.0
			cell.clearIcon.alpha = 0.0
			if tableOriginalLoad {
				cell.clearIconTrailingConstraint.constant = 65 - 32
				cell.clearIconTrailingConstraint.isActive = true
				cell.updateConstraints()
			}
		} else {
			cell.clearButton.alpha = 1.0
			cell.clearIcon.alpha = 1.0
			cell.clearIconTrailingConstraint.constant = 65
			cell.clearIconTrailingConstraint.isActive = true
			cell.updateConstraints()
		}
		return cell
	}
	
	func setupAuthorCell(_ tableView: UITableView, _ indexPath: IndexPath) -> AddItemMetadataComponent{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemMetadataComponent.identifier, for: indexPath) as! AddItemMetadataComponent
		cell.controller = self
		cell.metadataName.text = "Author"
		cell.metadataContent.placeholder = "Author"
		cell.metadataContent.text = itemAuthor
		if itemAuthor == ""{
			cell.clearButton.alpha = 0.0
			cell.clearIcon.alpha = 0.0
			if tableOriginalLoad {
				cell.clearIconTrailingConstraint.constant = 65 - 32
				cell.clearIconTrailingConstraint.isActive = true
				cell.updateConstraints()
			}
		} else {
			cell.clearButton.alpha = 1.0
			cell.clearIcon.alpha = 1.0
			cell.clearIconTrailingConstraint.constant = 65
			cell.clearIconTrailingConstraint.isActive = true
			cell.updateConstraints()
		}
		return cell
	}
	
	func setupPinnedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCheckBoxes.identifier, for: indexPath) as! AddItemCheckBoxes
		cell.optionName.text = "Pin to Home"
		cell.recommendedLabel.text = "(WILL APPEAR IN HOME TAB)"
		cell.controller = self
		cell.shouldCheckStatus = true
		cell.optionName.alpha = 1
		cell.recommendedLabel.alpha = 1
		cell.checkCircle.alpha = 1
		if isPinned {
			cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
			cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
			cell.isChecked = true
		} else {
			cell.isChecked = false
		}
		return cell
	}
	
	func setupFavoriteCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCheckBoxes.identifier, for: indexPath) as! AddItemCheckBoxes
		cell.optionName.text = "Favorite"
		cell.controller = self
		cell.recommendedLabel.text = "(ADD TO FAVORITES LIST)"
		cell.shouldCheckStatus = true
		cell.optionName.alpha = 1
		cell.recommendedLabel.alpha = 1
		cell.checkCircle.alpha = 1
		if isFavorite {
			cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
			cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
			cell.isChecked = true
		} else {
			cell.isChecked = false
		}
		return cell
	}
	
	func setupChildrenCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
		cell.currentIndex = indexPath.row
		cell.sectionTitle.text = "Files"
		var arrayOfItems:[InlinePickerItem] = []
		for id in childrenItems{
			let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
			let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
			let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
			let possibleBookItem = controller.realm.objects(Book.self).filter("personalID = '\(id)'").first
			let possibleNotebookItem = controller.realm.objects(Notebook.self).filter("personalID = '\(id)'").first
			let possibleSetItem = controller.realm.objects(TermSet.self).filter("personalID = '\(id)'").first
			let possibleFolderItem = controller.realm.objects(Folder.self).filter("personalID = '\(id)'").first
			arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : ((possibleGoalItem != nil) ? possibleGoalItem! : ((possibleBookItem != nil) ? possibleBookItem! : ((possibleNotebookItem != nil) ? possibleNotebookItem! : ((possibleSetItem != nil) ? possibleSetItem! : possibleFolderItem!))))))
		}
		cell.picker.pickedItems = arrayOfItems
		cell.picker.textField.placeholder = "More files"
		cell.picker.refreshPicker()
		return cell
	}
	
	func setupIconColorCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerTrigger.identifier, for: indexPath) as! AddItemPickerTrigger
		cell.fieldTitle.text = "Color"
		cell.fieldDescription.text = iconColor
		return cell
	}
	
	func setupShareCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
		cell.currentIndex = indexPath.row
		cell.sectionTitle.text = "Share With"
		var arrayOfItems:[InlinePickerItem] = []
		for id in teams{
			let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
			let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
			let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
			arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : possibleGoalItem!))
		}
		if !toDrive{
			cell.contentView.alpha = 0.4
			cell.isUserInteractionEnabled = false
		} else {
			cell.contentView.alpha = 1
			cell.isUserInteractionEnabled = true
		}
		cell.picker.pickedItems = arrayOfItems
		cell.picker.textField.placeholder = "More teams"
		cell.picker.refreshPicker()
		return cell
	}
	
	func setupGoalsCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
		cell.currentIndex = indexPath.row
		cell.sectionTitle.text = "Related Goals"
		cell.contentView.alpha = 1
		cell.isUserInteractionEnabled = true
		var arrayOfItems:[InlinePickerItem] = []
		for id in goals{
			let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
			let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
			let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
			arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : possibleGoalItem!))
		}
		cell.picker.pickedItems = arrayOfItems
		cell.picker.textField.placeholder = "More goals"
		cell.picker.refreshPicker()
		return cell
	}
	
	func setupCollectionCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
		cell.sectionTitle.text = "Collections"
		cell.currentIndex = indexPath.row
		cell.contentView.alpha = 1
		cell.isUserInteractionEnabled = true
		var arrayOfItems:[InlinePickerItem] = []
		for id in collections{
			let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
			let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
			let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
			arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : possibleGoalItem!))
		}
		cell.picker.pickedItems = arrayOfItems
		cell.picker.textField.placeholder = "More collections"
		cell.picker.refreshPicker()
		return cell
	}
	
	func setupFolderCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerTrigger.identifier, for: indexPath) as! AddItemPickerTrigger
		cell.fieldTitle.text = "Folder"
		cell.fieldDescription.text = controller.realm.objects(Folder.self).filter("personalID = '\(folder)'").first?.name ?? "None"
		return cell
	}
	
	func setupToDriveCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCheckBoxes.identifier, for: indexPath) as! AddItemCheckBoxes
		cell.optionName.text = "Store in Cloud"
		cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
		cell.controller = self
		if !controller.loggedIn || Socket.sharedInstance.socket.status != .connected {
			cell.optionName.alpha = 0.3
			cell.recommendedLabel.alpha = 0.3
			cell.checkCircle.alpha = 0.3
			cell.shouldCheckStatus = false
		} else {
			cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
			cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
			toDrive = true
			cell.isChecked = true
		}
		return cell
	}
	
	func setupLocal(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCheckBoxes.identifier, for: indexPath) as! AddItemCheckBoxes
		cell.controller = self
		cell.optionName.text = "Local Copy"
		cell.recommendedLabel.text = "(RECOMMENDED)"
		if toLocal {
			cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
			cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
			cell.isChecked = true
			if !controller.loggedIn {
				cell.optionName.alpha = 0.3
				cell.recommendedLabel.alpha = 0.3
				cell.checkCircle.alpha = 0.3
				cell.shouldCheckStatus = false
			}
		} else {
			cell.isChecked = false
		}
		return cell
	}
	
	func setupThumbnailCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if itemImage.count > 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: AddNotebookThumbnail.identifier, for: indexPath) as! AddNotebookThumbnail
			cell.fileThumbnail.image = itemImage[0]
			cell.filePaperStyle.image = itemImage[1]
			if displayedOrientation == "Portrait"{
				cell.landscapeShadowHeight.isActive = false
				cell.portraitShadowHeight.isActive = true
				cell.landscapePaperHeight.isActive = false
				cell.portraitPaperHeight.isActive = true
				cell.landscapePaperRatio.isActive = false
				cell.landscapeShadowRatio.isActive = false
				cell.portraitShadowRatio.isActive = true
				cell.portraitPaperRatio.isActive = true
			} else {
				cell.portraitShadowHeight.isActive = false
				cell.landscapeShadowHeight.isActive = true
				cell.portraitPaperHeight.isActive = false
				cell.landscapePaperHeight.isActive = true
				cell.portraitShadowRatio.isActive = false
				cell.portraitPaperRatio.isActive = false
				cell.landscapePaperRatio.isActive = true
				cell.landscapeShadowRatio.isActive = true
			}
			print(cell.filePaperStyle.layer.frame.height)
			return cell
		} else if itemImage.count > 0{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemThumbnail.identifier, for: indexPath) as! AddItemThumbnail
			cell.fileThumbnail.image = itemImage[0]
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: AddIconlessThumbnailTableViewCell.identifier, for: indexPath) as! AddIconlessThumbnailTableViewCell
			cell.fileTitle.text = finalName
			cell.clearButton.alpha = (finalName != "") ? 1.0 : 0.0
			cell.fileTitle.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
			return cell
		}
	}
	
	func refreshPicker(_ contentType: String, _ index: Int, containing: String){
		switch contentType {
		case "collections":
			let displayableCollections = Array(controller.realm.objects(FileCollection.self).filter({(collectionItem) -> Bool in
				for collection in self.collections {
					if collection == collectionItem.personalID {
						return false
					}
				}
				return true
			}).filter({(collectionItem) -> Bool in
				if let _ = collectionItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableCollections
			break
		case "goals":
			let displayableGoals = Array(controller.realm.objects(Goal.self).filter({(goalItem) -> Bool in
				for goal in self.goals {
					if goal == goalItem.personalID {
						return false
					}
				}
				return true
			}).filter({(goalItem) -> Bool in
				if let _ = goalItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableGoals
			break
		case "teams":
			let displayableTeams = Array(controller.realm.objects(Team.self).filter({(teamItem) -> Bool in
				for team in self.teams {
					if team == teamItem.personalID {
						return false
					}
				}
				return true
			}).filter({(teamItem) -> Bool in
				if let _ = teamItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableTeams
			break
		case "members":
			let displayableMembers = Array(controller.realm.objects(Friend.self).filter({(memberItem) -> Bool in
				for member in self.members {
					if member == memberItem.personalID {
						return false
					}
				}
				return true
			}).filter({(memberItem) -> Bool in
				if let _ = memberItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else if let _ = memberItem.personalID?.range(of: containing, options: .caseInsensitive){
					return true
				} else {
					return false
				}
			}))
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableMembers
			break
		case "children":
			var displayableFiles: [InlinePickerItem] = []
			
			let books = Array(controller.realm.objects(Book.self).filter({(bookItem) -> Bool in
				for item in self.childrenItems {
					if item == bookItem.personalID {
						return false
					}
				}
				return true
			}).filter({(bookItem) -> Bool in
				if let _ = bookItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let notebooks = Array(controller.realm.objects(Notebook.self).filter({(notebookItem) -> Bool in
				for item in self.childrenItems {
					if item == notebookItem.personalID {
						return false
					}
				}
				return true
			}).filter({(notebookItem) -> Bool in
				if let _ = notebookItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let sets = Array(controller.realm.objects(TermSet.self).filter({(setItem) -> Bool in
				for item in self.childrenItems {
					if item == setItem.personalID {
						return false
					}
				}
				return true
			}).filter({(setItem) -> Bool in
				if let _ = setItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let folders = Array(controller.realm.objects(Folder.self).filter({(folderItem) -> Bool in
				for item in self.childrenItems {
					if item == folderItem.personalID {
						return false
					}
				}
				return true
			}).filter({(folderItem) -> Bool in
				if let _ = folderItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			displayableFiles.append(contentsOf: books)
			displayableFiles.append(contentsOf: notebooks)
			displayableFiles.append(contentsOf: sets)
			displayableFiles.append(contentsOf: folders)
			displayableFiles.sort(by: {($0.name ?? "") < ($1.name ?? "")})
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableFiles
			break
		case "files":
			var displayableFiles: [InlinePickerItem] = []
			
			let books = Array(controller.realm.objects(Book.self).filter({(bookItem) -> Bool in
				for item in self.childrenItems {
					if item == bookItem.personalID {
						return false
					}
				}
				return true
			}).filter({(bookItem) -> Bool in
				if let _ = bookItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let notebooks = Array(controller.realm.objects(Notebook.self).filter({(notebookItem) -> Bool in
				for item in self.childrenItems {
					if item == notebookItem.personalID {
						return false
					}
				}
				return true
			}).filter({(notebookItem) -> Bool in
				if let _ = notebookItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let sets = Array(controller.realm.objects(TermSet.self).filter({(setItem) -> Bool in
				for item in self.childrenItems {
					if item == setItem.personalID {
						return false
					}
				}
				return true
			}).filter({(setItem) -> Bool in
				if let _ = setItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			let folders = Array(controller.realm.objects(Folder.self).filter({(folderItem) -> Bool in
				for item in self.childrenItems {
					if item == folderItem.personalID {
						return false
					}
				}
				return true
			}).filter({(folderItem) -> Bool in
				if let _ = folderItem.name?.range(of: containing, options: .caseInsensitive) {
					return true
				} else {
					return false
				}
			}))
			displayableFiles.append(contentsOf: books)
			displayableFiles.append(contentsOf: notebooks)
			displayableFiles.append(contentsOf: sets)
			displayableFiles.append(contentsOf: folders)
			displayableFiles.sort(by: {($0.name ?? "") < ($1.name ?? "")})
			pickerManager.contentType = contentType
			pickerManager.itemsToPoblate = displayableFiles
			break
		default:
			print("something went wrong")
		}
		pickerManager.currentContent = containing
		pickerManager.currentIndex = index
		inlinePickerTable.reloadData()
	}
}
