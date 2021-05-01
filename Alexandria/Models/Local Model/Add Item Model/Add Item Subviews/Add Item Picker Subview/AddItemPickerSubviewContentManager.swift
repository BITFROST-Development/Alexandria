//
//  AddItemPickerSubviewContentManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/22/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension AddItemPickerSubviewController{
	func loadViewAsCollection(of kind: String){
		pickerCollectionView.delegate = self
		pickerCollectionView.dataSource = self
		pickerCollectionView.register(UINib(nibName: "AddItemPickerHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AddItemPickerHeaderCollectionReusableView.identifier)
		if kind == "items"{
			if pickerItem.pickerDetails == "Parent Picker" || pickerItem.pickerDetails == "Children Picker"{
				if self.currentParent != ""{
					let chosenFolder = controller.controller.realm.objects(Folder.self).filter({($0).personalID == self.currentParent}).first!
					for child in chosenFolder.childrenIDs{
						let item: FolderItem = controller.controller.realm.objects(Folder.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(Book.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(Notebook.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(TermSet.self).filter({($0).personalID == child.value}).first!
						
						fullItemsContent.append(item)
					}
				} else {
					let folders: [FolderItem] = Array(controller.controller.realm.objects(Folder.self).filter({(($0).parentID == nil) || (($0).parentID == "")}))
					let books: [FolderItem] = Array(controller.controller.realm.objects(Book.self).filter({(($0).parentID == nil) || (($0).parentID == "")}))
					let notebooks: [FolderItem] = Array(controller.controller.realm.objects(Notebook.self).filter({(($0).parentID == nil) || (($0).parentID == "")}))
					let sets: [FolderItem] = Array(controller.controller.realm.objects(TermSet.self).filter({(($0).parentID == nil) || (($0).parentID == "")}))
					fullItemsContent.append(contentsOf: folders)
					fullItemsContent.append(contentsOf: books)
					fullItemsContent.append(contentsOf: notebooks)
					fullItemsContent.append(contentsOf: sets)
				}
			}
			fullItemsContent.sort(by: {($0.name ?? "") < ($1.name ?? "")})
			displayingItems = fullItemsContent
			displayingCount = displayingItems.count
			pickerCollectionView.register(UINib(nibName: "AddItemPickerFolderItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AddItemPickerFolderItemCollectionViewCell.identifier)
		} else {
			switch currentCategory {
			case "folders":
				fullImagesContent.append(PickerStyleImageItem("folderIconBlue"))
				fullImagesContent.append(PickerStyleImageItem("folderIconTurquoise"))
				fullImagesContent.append(PickerStyleImageItem("folderIconGreen"))
				fullImagesContent.append(PickerStyleImageItem("folderIconYellow"))
				fullImagesContent.append(PickerStyleImageItem("folderIconOrange"))
				fullImagesContent.append(PickerStyleImageItem("folderIconRed"))
				fullImagesContent.append(PickerStyleImageItem("folderIconPink"))
				fullImagesContent.append(PickerStyleImageItem("folderIconPurple"))
				fullImagesContent.append(PickerStyleImageItem("folderIconGrey"))
				fullImagesContent.append(PickerStyleImageItem("folderIconBlack"))
				break
			case "flashCards":
				fullImagesContent.append(PickerStyleImageItem("cardBlue"))
				fullImagesContent.append(PickerStyleImageItem("cardTurquoise"))
				fullImagesContent.append(PickerStyleImageItem("cardGreen"))
				fullImagesContent.append(PickerStyleImageItem("cardYellow"))
				fullImagesContent.append(PickerStyleImageItem("cardOrange"))
				fullImagesContent.append(PickerStyleImageItem("cardRed"))
				fullImagesContent.append(PickerStyleImageItem("cardPink"))
				fullImagesContent.append(PickerStyleImageItem("cardPurple"))
				fullImagesContent.append(PickerStyleImageItem("cardGrey"))
				fullImagesContent.append(PickerStyleImageItem("cardBlack"))
				break
			case "colors":
				fullImagesContent.append(PickerStyleImageItem("Blue"))
				fullImagesContent.append(PickerStyleImageItem("Turquoise"))
				fullImagesContent.append(PickerStyleImageItem("Green"))
				fullImagesContent.append(PickerStyleImageItem("Yellow"))
				fullImagesContent.append(PickerStyleImageItem("Orange"))
				fullImagesContent.append(PickerStyleImageItem("Red"))
				fullImagesContent.append(PickerStyleImageItem("Pink"))
				fullImagesContent.append(PickerStyleImageItem("Purple"))
				fullImagesContent.append(PickerStyleImageItem("Grey"))
				fullImagesContent.append(PickerStyleImageItem("Black"))
				break
			case "notebookCircles":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				break
			case "notebookCubes":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				break
			case "notebookFlowers":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				break
			case "notebookPatterns":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)11"))
				break
			case "notebookPlain":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)11"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)12"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)13"))
				break
			case "notebookTech":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				break
			case "notebookTextures":
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)01"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)02"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)03"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)04"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)05"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)06"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)07"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)08"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)09"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)10"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)11"))
				fullImagesContent.append(PickerStyleImageItem("\(currentCategory)12"))
				break
			default:
				print("no fiting category to \(currentCategory)")
			}
			displayingImages = fullImagesContent
			displayingCount = displayingImages.count
			pickerCollectionView.register(UINib(nibName: "AddItemPickerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AddItemPickerImageCollectionViewCell.idetifier)
		}
	}
	
	func loadViewAsTable(of kind: String){
		pickerTableView.delegate = self
		pickerTableView.dataSource = self
		pickerTableView.register(UINib(nibName: "AddItemPickerHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemPickerHeaderTableViewCell.identifier)
		if kind == "elements"{
			if let chosenFolder = controller.controller.realm.objects(Folder.self).filter({($0).personalID == self.currentParent}).first{
				for child in chosenFolder.childrenIDs{
					let item: InlinePickerItem = controller.controller.realm.objects(Folder.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(Book.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(Notebook.self).filter({($0).personalID == child.value}).first ?? controller.controller.realm.objects(TermSet.self).filter({($0).personalID == child.value}).first!
					
					fullElementsContent.append(item)
				}
			} else if currentParent == "" && pickerItem.pickerDetails == "Children Picker"{
				let folders = Array(controller.controller.realm.objects(Folder.self).filter({($0).parentID == nil || ($0).parentID == ""}))
				let books = Array(controller.controller.realm.objects(Book.self).filter({($0).parentID == nil || ($0).parentID == ""}))
				let notebooks = Array(controller.controller.realm.objects(Notebook.self).filter({($0).parentID == nil || ($0).parentID == ""}))
				let sets = Array(controller.controller.realm.objects(TermSet.self).filter({($0).parentID == nil || ($0).parentID == ""}))
				fullElementsContent.append(contentsOf: folders)
				fullElementsContent.append(contentsOf: books)
				fullElementsContent.append(contentsOf: notebooks)
				fullElementsContent.append(contentsOf: sets)
			} else if pickerItem.pickerDetails == "Collection Picker"{
				fullElementsContent.append(contentsOf: Array(controller.controller.realm.objects(FileCollection.self)))
			} else if pickerItem.pickerDetails == "Goal Picker"{
				fullElementsContent.append(contentsOf: Array(controller.controller.realm.objects(Goal.self)))
			} else if pickerItem.pickerDetails == "Team Picker"{
				fullElementsContent.append(contentsOf: Array(controller.controller.realm.objects(Team.self)))
			} else if pickerItem.pickerDetails == "Member Picker"{
				fullElementsContent.append(contentsOf: Array(controller.controller.realm.objects(Friend.self)))
			}
			fullElementsContent.sort(by: {(($0).name ?? "") < (($1).name ?? "")})
			displayingElements = fullElementsContent
			displayingCount = displayingElements.count + 1
			pickerTableView.register(UINib(nibName: "AddItemPickerElementTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemPickerElementTableViewCell.identifier)
		} else if kind == "categories"{
			displayingCategories = fullCategoriesContent
			displayingCount = displayingCategories.count + 1
			pickerTableView.register(UINib(nibName: "AddItemPickerCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemPickerCategoryTableViewCell.identifier)
		} else {
			let blankPrefix = "notebookPaperBlank"
			var blankItems: [CarouselItem] = []
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Blank"))
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Full Blank"))
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Title Blank"))
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Basic Blank"))
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell End Blank"))
			blankItems.append(CarouselItem(itemImage: UIImage(named: "\(blankPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(blankPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Legal Blank"))
			let blankSection = CarouselSection(title: "Blank", content: blankItems)
			
			let squaredPrefix = "notebookPaperSquared"
			var squaredItems: [CarouselItem] = []
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Large Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Medium Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Small Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Full Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Title Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Basic Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell End Squared"))
			squaredItems.append(CarouselItem(itemImage: UIImage(named: "\(squaredPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(squaredPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Legal Squared"))
			let squaredSection = CarouselSection(title: "Squared", content: squaredItems)
			
			let ruledPrefix = "notebookPaperRuled"
			var ruledItems: [CarouselItem] = []
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Large Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Medium Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Small Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Full Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Title Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Basic Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell End Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Legal Ruled"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)09/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)09/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Three Columns"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)10/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)10/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Uneven Left"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)11/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)11/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Uneven Right"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)12/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)12/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Two Columns"))
			ruledItems.append(CarouselItem(itemImage: UIImage(named: "\(ruledPrefix)13/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(ruledPrefix)13/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Box"))
			let ruledSection = CarouselSection(title: "Ruled", content: ruledItems)
			
			let dotedPrefix = "notebookPaperDoted"
			var dotedItems: [CarouselItem] = []
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Large Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Medium Large Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)03/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Medium Small Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)04/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Small Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)05/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Full Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)06/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Title Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)07/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell Basic Doted"))
			dotedItems.append(CarouselItem(itemImage: UIImage(named: "\(dotedPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(dotedPrefix)08/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Cornell End Doted"))
			let dotedSection = CarouselSection(title: "Doted", content: dotedItems)
			
			let specialPrefix = "notebookPaperSpecial"
			var specialItems: [CarouselItem] = []
			specialItems.append(CarouselItem(itemImage: UIImage(named: "\(specialPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(specialPrefix)01/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Monthly Planner"))
			specialItems.append(CarouselItem(itemImage: UIImage(named: "\(specialPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)")!, itemImageName: "\(specialPrefix)02/\(controller.displayedOrientation)/\(controller.displayedPaperColor)", itemTitleImage: "Accounting"))
			let specialSection = CarouselSection(title: "Special", content: specialItems)
			
			fullCarouselsContent.append(blankSection)
			fullCarouselsContent.append(squaredSection)
			fullCarouselsContent.append(ruledSection)
			fullCarouselsContent.append(dotedSection)
			fullCarouselsContent.append(specialSection)
			
			displayingCarousels = fullCarouselsContent
			displayingCount = displayingCarousels.count + 1
			pickerTableView.register(UINib(nibName: "AddItemPickerCarouselTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemPickerCarouselTableViewCell.identifier)
		}
	}
}
