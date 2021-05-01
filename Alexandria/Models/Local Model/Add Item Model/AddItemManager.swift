//
//  AddItemManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/27/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension AddItemViewController{
    func prepareTable(){
        displayingView.delegate = self
        displayingView.dataSource = self
        displayingView.register(UINib(nibName: "AddItemDone", bundle: nil), forCellReuseIdentifier: AddItemDone.identifier)
        displayingView.register(UINib(nibName: "AddItemPickerTrigger", bundle: nil), forCellReuseIdentifier: AddItemPickerTrigger.identifier)
        displayingView.register(UINib(nibName: "AddItemTitle", bundle: nil), forCellReuseIdentifier: AddItemTitle.identifier)
        displayingView.register(UINib(nibName: "AddItemTapSwitcher", bundle: nil), forCellReuseIdentifier: AddItemTapSwitcher.identifier)
        displayingView.register(UINib(nibName: "AddNotebookThumbnail", bundle: nil), forCellReuseIdentifier: AddNotebookThumbnail.identifier)
        displayingView.register(UINib(nibName: "AddItemThumbnail", bundle: nil), forCellReuseIdentifier: AddItemThumbnail.identifier)
		displayingView.register(UINib(nibName: "AddNotebookThumbnail", bundle: nil), forCellReuseIdentifier: AddNotebookThumbnail.identifier)
		displayingView.register(UINib(nibName: "AddIconlessThumbnailTableViewCell", bundle: nil), forCellReuseIdentifier: AddIconlessThumbnailTableViewCell.identifier)
		displayingView.register(UINib(nibName: "AddItemInlinePickerTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemInlinePickerTableViewCell.identifier)
		displayingView.register(UINib(nibName: "AddItemValuePickerTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemValuePickerTableViewCell.identifier)
        displayingView.register(UINib(nibName: "AddItemCheckBoxes", bundle: nil), forCellReuseIdentifier: AddItemCheckBoxes.identifier)
        displayingView.register(UINib(nibName: "AddItemMetadataComponent", bundle: nil), forCellReuseIdentifier: AddItemMetadataComponent.identifier)
		AddIconlessThumbnailTableViewCell.controller = self
		AddItemTitle.controller = self
		AddItemDone.controller = self
		AddItemInlinePickerTableViewCell.controller = self
		if controller.addItemKindSelected == "newFolder"{
			addItemView.heightAnchor.constraint(equalToConstant: 150).isActive = true
		} else {
			addItemView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		}
		inlinePickerTable.delegate = pickerManager
		inlinePickerTable.dataSource = pickerManager
		inlinePickerTable.register(UINib(nibName: "InlinePickerFilterTableViewCell", bundle: nil), forCellReuseIdentifier: InlinePickerFilterTableViewCell.identifier)
		inlinePickerTable.register(UINib(nibName: "InlinePickerFilterNewItemTableViewCell", bundle: nil), forCellReuseIdentifier: InlinePickerFilterNewItemTableViewCell.identifier)
		inlinePickerTable.alpha = 0
		pickerManager.controller = self
		let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissPickerTable(_:)))
		dismissGesture.delegate = self
		let opacityDismiss = UIPanGestureRecognizer(target: self, action: #selector(dismissOverlayingViews(_:)))
		opacityDismiss.delegate = self
		self.opacityFilter.addGestureRecognizer(opacityDismiss)
		self.view.addGestureRecognizer(dismissGesture)
		self.displayingView.addGestureRecognizer(dismissGesture)
    }
	
	@objc func dismissOverlayingViews(_ gesture: UIGestureRecognizer){
		UIView.animate(withDuration: 0.3, animations: {
			self.opacityFilter.alpha = 0
			self.addItemView.alpha = 0
		})
	}
	
	func keysShouldNotCover(_ point: CGPoint){
		visibleSpaceNeeded = point
	}
	
	@objc func dismissPickerTable(_ gesture: UIPanGestureRecognizer){
		view.endEditing(true)
		UIView.animate(withDuration: 0.3, animations: {
			self.inlinePickerTable.alpha = 0
		})
		dismissOverlayingViews(UIGestureRecognizer())
	}
	
    func donePressed(){
		switch controller.addItemKindSelected {
		case "newFile":
			if !controller.isEditingClue{
				saveNewFile()
			}
			break
		case "newNote":
			if !controller.isEditingClue{
				saveNewNotebook()
			}
			break
		case "newSet":
			if !controller.isEditingClue{
				saveNewTermset()
			}
			break
		case "newFolder":
			if !controller.isEditingClue{
				saveNewFolder()
			}
			break
		case "newCollection":
			if !controller.isEditingClue{
				saveNewCollection()
			}
			break
		case "newGoal":
			if !controller.isEditingClue{
				saveNewGoal()
			}
			break
		case "newTeam":
			if !controller.isEditingClue{
				saveNewTeam()
			}
			break
		default:
			print("error saving file")
		}
		
    }
}

extension AddItemViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		if indexPath.row == 0{
			switch itemImage.count {
			case 2:
				return 270
			case 1:
				return UITableView.automaticDimension
			case 0:
				return 206
			default:
				print("Error")
			}
			return 5
		} else if indexPath.row == lastCellIndex{
			if view.frame.height < 723{
				
				return UITableView.automaticDimension

			} else {
				if controller.addItemKindSelected == "newFile"{
					return UITableView.automaticDimension
				} else if controller.addItemKindSelected == "newNote"{
					return UITableView.automaticDimension
				} else if controller.addItemKindSelected == "newSet"{
					return UITableView.automaticDimension
				} else if controller.addItemKindSelected == "newFolder"{
					return UITableView.automaticDimension
				} else if controller.addItemKindSelected == "newCollection"{
					return view.frame.size.height - 648
				} else if controller.addItemKindSelected == "newGoal"{
					return UITableView.automaticDimension
				} else if controller.addItemKindSelected == "newTeam"{
					return view.frame.size.height - 608
				}
				return view.frame.size.height - 700
			}
		} else if let pickerCell = tableView.cellForRow(at: indexPath) as? AddItemInlinePickerTableViewCell{
			return pickerCell.neededHeight
		}
		
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if controller.addItemKindSelected == "newFile"{
			handleNewFileCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newNote"{
			handleNotebookCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newSet"{
			handleSetCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newFolder"{
			handleFolderCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newCollection"{
			handleCollectionCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newGoal"{
			handleGoalCellSelected(indexPath)
		} else if controller.addItemKindSelected == "newTeam"{
			handleTeamCellSelected(indexPath)
		}
	}
}

extension AddItemViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if controller.addItemKindSelected == "newFile"{
			lastCellIndex = 11
            return 12
        } else if controller.addItemKindSelected == "newNote"{
			lastCellIndex = 16
            return 16
        } else if controller.addItemKindSelected == "newSet"{
			lastCellIndex = 12
            return 13
        } else if controller.addItemKindSelected == "newFolder"{
			lastCellIndex = 10
            return 11
        } else if controller.addItemKindSelected == "newCollection"{
			lastCellIndex = 6
            return 7
        } else if controller.addItemKindSelected == "newGoal"{
			lastCellIndex = 8
            return 9
        } else if controller.addItemKindSelected == "newTeam"{
			lastCellIndex = 6
            return 7
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0{
			return setupThumbnailCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newFile"{
			return setupNextFileCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newNote"{
			return setupNextNotebookCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newSet"{
			return setupNextSetCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newFolder"{
			return setupNextFolderCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newCollection"{
			return setupNextCollectionCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newGoal"{
			return setupNextGoalCell(tableView, indexPath)
		} else if controller.addItemKindSelected == "newTeam"{
			return setupNextTeamCell(tableView, indexPath)
		}
        return UITableViewCell()
    }
    
    
}

extension AddItemViewController: UIGestureRecognizerDelegate{
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if touch.view?.isDescendant(of: self.inlinePickerTable) ?? false{
			return false
		}
		return true
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}

