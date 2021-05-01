//
//  AddItemSpecificCellManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/27/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension AddItemViewController{
	func setupNextFileCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTitle.identifier, for: indexPath) as! AddItemTitle
			cell.fileTitle.text = finalName
			AddItemTitle.controller = self
			cell.fileTitle.placeholder = "Title"
			return cell
		} else if indexPath.row == 2{
			return setupFolderCell(tableView, indexPath)
		} else if indexPath.row == 3{
			return setupCollectionCell(tableView, indexPath)
		} else if indexPath.row == 4{
			return setupGoalsCell(tableView, indexPath)
		} else if indexPath.row == 5{
			return setupShareCell(tableView, indexPath)
		} else if indexPath.row == 6{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 7{
			return setupLocal(tableView, indexPath)
		} else if indexPath.row == 8{
			return setupFavoriteCell(tableView, indexPath)
		} else if indexPath.row == 9{
			return setupAuthorCell(tableView, indexPath)
		} else if indexPath.row == 10{
			return setupYearCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
	
	func setupNextNotebookCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTitle.identifier, for: indexPath) as! AddItemTitle
			cell.fileTitle.text = finalName
			cell.clearButton.alpha = (finalName != "") ? 1.0 : 0.0
			AddItemTitle.controller = self
			cell.fileTitle.placeholder = "Title"
			return cell
		} else if indexPath.row == 2{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerTrigger.identifier, for: indexPath) as! AddItemPickerTrigger
			cell.fieldTitle.text = "Cover"
			cell.fieldDescription.text = displayedCoverStyle
			return cell
		} else if indexPath.row == 3{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerTrigger.identifier, for: indexPath) as! AddItemPickerTrigger
			cell.fieldTitle.text = "Paper Style"
			cell.fieldDescription.text = displayedPaperStyle
			return cell
		} else if indexPath.row == 4{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTapSwitcher.identifier, for: indexPath) as! AddItemTapSwitcher
			cell.fieldTitle.text = "Paper Color"
			cell.fieldDescription.text = displayedPaperColor
			switch displayedPaperColor {
			case "White":
				cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 252/255, green: 252/255, blue: 252/255, alpha: 1))
				break
			case "Yellow":
				cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 250/255, green: 245/255, blue: 225/255, alpha: 1))
				break
			case "Black":
				cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 39/255, green: 29/255, blue: 29/255, alpha: 1))
				break
			default:
				print("error")
			}
			return cell
		} else if indexPath.row == 5{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTapSwitcher.identifier, for: indexPath) as! AddItemTapSwitcher
			cell.fieldTitle.text = "Paper Orientation"
			cell.colorIndicator.alpha = 0
			cell.colorShadow.alpha = 0
			cell.fieldDescription.text = displayedOrientation
			return cell
		} else if indexPath.row == 6{
			return setupFolderCell(tableView, indexPath)
		} else if indexPath.row == 7{
			return setupCollectionCell(tableView, indexPath)
		} else if indexPath.row == 8{
			return setupGoalsCell(tableView, indexPath)
		} else if indexPath.row == 9{
			return setupShareCell(tableView, indexPath)
		} else if indexPath.row == 10{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 11{
			return setupLocal(tableView, indexPath)
		} else if indexPath.row == 12{
			return setupFavoriteCell(tableView, indexPath)
		} else if indexPath.row == 13{
			return setupAuthorCell(tableView, indexPath)
		} else if indexPath.row == 14{
			return setupYearCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
	
	func setupNextSetCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTitle.identifier, for: indexPath) as! AddItemTitle
			cell.fileTitle.text = finalName
			cell.clearButton.alpha = (finalName != "") ? 1.0 : 0.0
			AddItemTitle.controller = self
			cell.fileTitle.placeholder = "Title"
			return cell
		} else if indexPath.row == 2{
			return setupIconColorCell(tableView, indexPath)
		} else if indexPath.row == 3{
			return setupFolderCell(tableView, indexPath)
		} else if indexPath.row == 4{
			return setupCollectionCell(tableView, indexPath)
		} else if indexPath.row == 5{
			return setupGoalsCell(tableView, indexPath)
		} else if indexPath.row == 6{
			return setupShareCell(tableView, indexPath)
		} else if indexPath.row == 7{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 8{
			return setupLocal(tableView, indexPath)
		} else if indexPath.row == 9{
			return setupFavoriteCell(tableView, indexPath)
		} else if indexPath.row == 10{
			return setupAuthorCell(tableView, indexPath)
		} else if indexPath.row == 11{
			return setupYearCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
	
	func setupNextFolderCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTitle.identifier, for: indexPath) as! AddItemTitle
			cell.fileTitle.text = finalName
			cell.clearButton.alpha = (finalName != "") ? 1.0 : 0.0
			AddItemTitle.controller = self
			cell.fileTitle.placeholder = "Title"
			return cell
		} else if indexPath.row == 2{
			return setupIconColorCell(tableView, indexPath)
		} else if indexPath.row == 3{
			return setupFolderCell(tableView, indexPath)
		} else if indexPath.row == 4{
			return setupChildrenCell(tableView, indexPath)
		} else if indexPath.row == 5{
			return setupShareCell(tableView, indexPath)
		} else if indexPath.row == 6{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 7{
			return setupLocal(tableView, indexPath)
		} else if indexPath.row == 8{
			return setupFavoriteCell(tableView, indexPath)
		} else if indexPath.row == 9{
			return setupPinnedCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}

	}
	
	func setupNextCollectionCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			return setupIconColorCell(tableView, indexPath)
		} else if indexPath.row == 2{
			return setupChildrenCell(tableView, indexPath)
		} else if indexPath.row == 3{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 4{
			return setupLocal(tableView, indexPath)
		} else if indexPath.row == 5{
			return setupPinnedCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
	
	func setupNextGoalCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTapSwitcher.identifier, for: indexPath) as! AddItemTapSwitcher
			cell.fieldTitle.text = "Type of Goal"
			cell.fieldDescription.text = goalType
			cell.colorIndicator.alpha = 0
			cell.colorShadow.alpha = 0
			return cell
		} else if indexPath.row == 2{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemTapSwitcher.identifier, for: indexPath) as! AddItemTapSwitcher
			cell.fieldTitle.text = "Interval"
			cell.fieldDescription.text = goalInterval
			cell.colorIndicator.alpha = 0
			cell.colorShadow.alpha = 0
			return cell
		} else if indexPath.row == 3{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemMetadataComponent.identifier, for: indexPath) as! AddItemMetadataComponent
			cell.controller = self
			cell.metadataName.text = "Objective"
			cell.metadataContent.placeholder = goalObjectivePlaceholder
			cell.metadataContent.text = goalValueToHit
			cell.metadataContent.keyboardType = .numberPad
			if goalValueToHit == ""{
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
		} else if indexPath.row == 4{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemValuePickerTableViewCell.identifier, for: indexPath) as! AddItemValuePickerTableViewCell
			cell.controller = self
			cell.sectionTitle.text = "End Date"
			return cell
		} else if indexPath.row == 5{
			return setupShareCell(tableView, indexPath)
		} else if indexPath.row == 6{
			return setupToDriveCell(tableView, indexPath)
		} else if indexPath.row == 7{
			return setupLocal(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
	
	func setupNextTeamCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row == 1{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
			cell.sectionTitle.text = "Members"
			var arrayOfItems:[InlinePickerItem] = []
			for id in collections{
				let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
				let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
				let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
				arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : possibleGoalItem!))
			}
			cell.picker.pickedItems = arrayOfItems
			cell.picker.textField.placeholder = "More members"
			cell.picker.refreshPicker()
			return cell
		} else if indexPath.row == 2{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemPickerTrigger.identifier, for: indexPath) as! AddItemPickerTrigger
			cell.fieldTitle.text = "Picture"
			cell.fieldDescription.text = selectedPictureName
			return cell
		} else if indexPath.row == 3{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
			cell.sectionTitle.text = "Shared Files"
			var arrayOfItems:[InlinePickerItem] = []
			for id in sharedFiles{
				let possibleTeamItem = controller.realm.objects(Team.self).filter("personalID = '\(id)'").first
				let possibleCollectionItem = controller.realm.objects(FileCollection.self).filter("personalID = '\(id)'").first
				let possibleGoalItem = controller.realm.objects(Goal.self).filter("personalID = '\(id)'").first
				arrayOfItems.append((possibleTeamItem != nil) ? possibleTeamItem! : ((possibleCollectionItem != nil) ? possibleCollectionItem! : possibleGoalItem!))
			}
			cell.picker.pickedItems = arrayOfItems
			cell.picker.textField.placeholder = "More files"
			cell.picker.refreshPicker()
			return cell
		} else if indexPath.row == 4{
			let cell = tableView.dequeueReusableCell(withIdentifier: AddItemInlinePickerTableViewCell.identifier, for: indexPath) as! AddItemInlinePickerTableViewCell
			cell.sectionTitle.text = "Shared Goals"
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
		} else if indexPath.row == 5{
			return setupFavoriteCell(tableView, indexPath)
		} else {
			return setupDoneCell(tableView, indexPath)
		}
	}
}
