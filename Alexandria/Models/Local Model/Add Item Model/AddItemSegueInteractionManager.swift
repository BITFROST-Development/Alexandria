//
//  AddItemSegueInteractionManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/27/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension AddItemViewController{
	
	func handleNewFileCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 2{
			handleFolderPickerTrigger()
		} else if indexPath.row == 3{
			handleCollectionPickerTrigger()
		} else if indexPath.row == 4{
			handleGoalPickerTrigger()
		} else if indexPath.row == 5{
			handleTeamPickerTrigger()
		}
	}
	
	func handleNotebookCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 2{
			pickerViewKind = "cover"
			performSegue(withIdentifier: "toNewPickerView", sender: self)
		} else if indexPath.row == 3{
			pickerViewKind = "paper"
			performSegue(withIdentifier: "toNewPickerView", sender: self)
		} else if indexPath.row == 4{
			switch displayedPaperColor {
			case "White":
				displayedPaperColor = "Yellow"
				break
			case "Yellow":
				displayedPaperColor = "Black"
				break
			case "Black":
				displayedPaperColor = "White"
				break
			default:
				print("error in paper color switcher")
			}
			displayingView.beginUpdates()
			displayingView.reloadData()
			displayingView.endUpdates()
		} else if indexPath.row == 5 {
			if displayedOrientation == "Portrait"{
				displayedOrientation = "Landscape"
			} else {
				displayedOrientation = "Portrait"
			}
			displayingView.beginUpdates()
			displayingView.reloadData()
			displayingView.endUpdates()
		} else if indexPath.row == 6{
			handleFolderPickerTrigger()
		} else if indexPath.row == 7{
			handleCollectionPickerTrigger()
		} else if indexPath.row == 8{
			handleGoalPickerTrigger()
		} else if indexPath.row == 9{
			handleTeamPickerTrigger()
		}
	}
	
	func handleSetCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 2{
			handleColorPickerTrigger()
		} else if indexPath.row == 3{
			handleFolderPickerTrigger()
		} else if indexPath.row == 4{
			handleCollectionPickerTrigger()
		} else if indexPath.row == 5{
			handleGoalPickerTrigger()
		} else if indexPath.row == 6{
			handleTeamPickerTrigger()
		}
	}
	
	func handleFolderCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 2{
			handleColorPickerTrigger()
		} else if indexPath.row == 3{
			handleFolderPickerTrigger()
		} else if indexPath.row == 4{
			handleChildrenPickerTrigger()
		} else if indexPath.row == 5{
			handleTeamPickerTrigger()
		}
	}
	
	func handleCollectionCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 1{
			handleColorPickerTrigger()
		} else if indexPath.row == 2 {
			handleChildrenPickerTrigger()
		}
	}
	
	func handleGoalCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 1{
			switch goalType {
			case "Studying Time":
				goalType = "Pages Read"
				goalObjectivePlaceholder = "Number of pages to read"
				break
			case "Pages Read":
				goalType = "Terms Reviewed"
				goalObjectivePlaceholder = "Number of terms to review"
				break
			case "Terms Reviewed":
				goalType = "Terms Learned"
				goalObjectivePlaceholder = "Number of terms to learn"
				break
			case "Terms Learned":
				goalType = "Links Created"
				goalObjectivePlaceholder = "Number of links to create"
				break
			case "Links Created":
				goalType = "Studying Time"
				goalObjectivePlaceholder = "Write in minutes"
				break
			default:
				print("Error in goal switcher")
			}
			displayingView.reloadRows(at: [indexPath], with: .fade)
		} else if indexPath.row == 2 {
			switch goalInterval {
			case "Daily":
				goalInterval = "Weekly"
				break
			case "Weekly":
				goalInterval = "Monthly"
				break
			case "Monthly":
				goalInterval = "Daily"
				break
			default:
				print("Error in goal interval switcher")
			}
			displayingView.reloadRows(at: [indexPath], with: .fade)
		} else if indexPath.row == 5{
			handleTeamPickerTrigger()
		}
	}
	
	func handleTeamCellSelected(_ indexPath: IndexPath){
		if indexPath.row == 1{
			handleMemberPickerTrigger()
		} else if indexPath.row == 3{
			handleSharedFilesPickerTrigger()
		} else if indexPath.row == 4{
			handleGoalPickerTrigger()
		}
	}
	
	
	
	
	func handleColorPickerTrigger(){
		pickerViewKind = "color"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleFolderPickerTrigger(){
		pickerViewKind = "parent"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleCollectionPickerTrigger(){
		pickerViewKind = "collections"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleChildrenPickerTrigger(){
		pickerViewKind = "children"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleGoalPickerTrigger(){
		pickerViewKind = "goals"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleTeamPickerTrigger(){
		pickerViewKind = "teams"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleMemberPickerTrigger(){
		pickerViewKind = "members"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleSharedFilesPickerTrigger(){
		pickerViewKind = "sharedFiles"
		performSegue(withIdentifier: "toNewPickerView", sender: self)
	}
	
	func handleNewSubItemTrigger(){
		UIView.animate(withDuration: 0.3, animations: {
			self.opacityFilter.alpha = 1
			self.addItemView.alpha = 1
		})
	}
}
