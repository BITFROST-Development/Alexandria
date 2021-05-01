//
//  AddItemPickerSubviewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/5/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerSubviewController: UIViewController {

	@IBOutlet weak var pickerTableView: UITableView!
	@IBOutlet weak var pickerCollectionView: UICollectionView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	// Current View Information
	var controller: AddItemViewController!
	var pickerItem: PickerItem!
	var displayingKind = ""
	var displayingType = ""
	var currentParent = ""
	var futureParent = ""
	var futureCategory = ""
	var currentCategory = ""
	var displayingCount = 0
	var currentButtonTitle = "Cancel"
	
	// PickerItem Selection
	var fullItemsContent: [FolderItem] = [] // auto-fills
	var displayingItems: [FolderItem] = [] // auto-fills
	var fullElementsContent: [InlinePickerItem] = [] // auto-fills
	var displayingElements: [InlinePickerItem] = [] // auto-fills
	var fullImagesContent: [PickerStyleImageItem] = [] // auto-fills
	var displayingImages: [PickerStyleImageItem] = [] // auto-fills
	var fullCarouselsContent: [CarouselSection] = [] // auto-fills
	var displayingCarousels: [CarouselSection] = [] // auto-fills
	var fullCategoriesContent: [String] = [] // need to be pre-filled
	var displayingCategories: [String] = [] // auto-fills
	var pickedItemCells: [AddItemPickerFolderItemCollectionViewCell] = []
	var pickedItems: [FolderItem] {
		get {
			return pickerItem.pickedItems
		} set (newArray){
			pickerItem.pickedItems = newArray
		}
	}
	var pickedImageCells: [AddItemPickerImageCollectionViewCell] = []
	var pickedImages: [PickerStyleImageItem]{
		get{
			return pickerItem.pickedImages
		} set (newArray){
			pickerItem.pickedImages = newArray
		}
	}
	var pickedElementCells: [AddItemPickerElementTableViewCell] = []
	var pickedElements: [InlinePickerItem]{
		get{
			return pickerItem.pickedElements
		} set (newArray){
			pickerItem.pickedElements = newArray
		}
	}
	var pickedCarouselCells: [AddItemPickerCarouselItemCollectionViewCell] = []
	var pickedCarousels: [CarouselItem] {
		get{
			return pickerItem.pickedCarousels
		} set (newArray){
			pickerItem.pickedCarousels = newArray
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.tintColor = AlexandriaConstants.alexandriaRed
		if currentButtonTitle == "Cancel"{
			navigationItem.setLeftBarButtonItems([UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEdit(_:)))], animated: false)
		} else {
			navigationItem.setLeftBarButtonItems([UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack(_:)))], animated: false)
		}
		if displayingKind == "collection"{
			pickerTableView.alpha = 0
			pickerCollectionView.alpha = 1
			loadViewAsCollection(of: displayingType)
		} else {
			pickerTableView.alpha = 1
			pickerCollectionView.alpha = 0
			loadViewAsTable(of: displayingType)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		pickedItemCells.removeAll()
		pickedImageCells.removeAll()
		pickedElementCells.removeAll()
		pickedCarouselCells.removeAll()
		if displayingKind == "collection"{
			pickerCollectionView.reloadData()
		} else {
			pickerTableView.reloadData()
		}
	}
	
	@IBAction func segueToNewView(_ sender: Any) {
		
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destination = segue.destination as! AddItemPickerSubviewController
		destination.controller = self.controller
		destination.pickerItem = pickerItem
		if displayingType == "elements"{
			destination.currentParent = futureParent
			destination.displayingType = "elements"
			destination.displayingKind = "table"
		} else if displayingType == "categories"{
			destination.displayingType = "styles"
			destination.displayingKind = "collection"
			destination.currentCategory = futureCategory
			destination.currentButtonTitle = "Back"
		} else if displayingType == "items"{
			destination.currentParent = futureParent
			destination.currentButtonTitle = "Back"
			destination.displayingType = "items"
			destination.displayingKind = "collection"
		}
    }

}

class PickerItem{
	var pickerDetails = ""
	var rootPicker: AddItemPickerSubviewController
	var pickedItems: [FolderItem] = []
	var pickedImages: [PickerStyleImageItem] = []
	var pickedElements: [InlinePickerItem] = []
	var pickedCarousels: [CarouselItem] = []
	
	init(_ root: AddItemPickerSubviewController, _ details: String) {
		self.rootPicker = root
		self.pickerDetails = details
	}
}
