//
//  AddItemViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/25/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    	
    var controller: AddItemClueDelegate!
	var pickerViewKind = ""
    var toDrive: Bool = false
    var toLocal: Bool = true
	var itemAuthor: String{
		get{
			return controller.itemAuthorClue ?? ""
		} set (newAuthor){
			controller.itemAuthorClue = newAuthor
		}
	}
	
	var itemYear: String{
		get {
			return controller.itemYearClue ?? ""
		} set (newYear){
			controller.itemYearClue = newYear
		}
	}
    var itemImage: [UIImage] {
        get{
            return controller.itemImageClue
        } set (newImage){
            controller.itemImageClue = newImage
        }
    }
	
	var displayedPaperColor: String{
		get {
			return controller.displayedPaperColor
		} set (newColor){
			controller.displayedPaperColor = newColor
			itemImage[1] = UIImage(named: "\(selectedPaperName)/\(displayedOrientation)/\(newColor)")!
		}
	}
	
	var displayedOrientation: String{
		get {
			return controller.displayedOrientation
		} set (newOrientation){
			controller.displayedOrientation = newOrientation
			itemImage[1] = UIImage(named: "\(selectedPaperName)/\(newOrientation)/\(displayedPaperColor)")!
		}
	}
	
	var selectedCoverName: String{
		get{
			return controller.selectedCoverName
		} set (newCover) {
			controller.selectedCoverName = newCover
			itemImage[0] = UIImage(named: newCover)!
		}
	}
	
	var displayedCoverStyle: String! {
		get{
			print(selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))])
			if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookPlain"{
				return "Plain"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookCircles"{
				return "Circles"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookCubes"{
				return "Cubes"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookFlowers"{
				return "Flowers"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookPatterns"{
				return "Patterns"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookTech"{
				return "Tech"
			} else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookTextures"{
				return "Textures"
			}
			
			return ""
		}
	}
	
	var displayedPaperStyle: String! {
		get{
			if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperBlank"{
				return "Blank"
			} else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperSquared"{
				return "Squared"
			} else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperRuled" {
				return "Ruled"
			} else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperDoted" {
				
			} else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperSpecial"{
				return "Special"
			}
			
			return ""
		}
	}
	var selectedPaperName: String{
		get {
			return controller.selectedPaperName
		} set (newPaper) {
			controller.selectedPaperName = newPaper
			itemImage[1] = UIImage(named: "\(newPaper)/\(displayedOrientation)/\(displayedPaperColor)")!
		}
	}
	
    var isEditingItem: Bool {
        get{
            return controller.isEditingClue
        }
    }
    var finalName: String{
        get{
            return controller.itemNameClue ?? ""
        } set (newName){
            controller.itemNameClue = newName
        }
    }
	var collections: [String]{
		get{
			return controller.collectionClues ?? []
		} set (newArray) {
			controller.collectionClues = newArray
		}
	}
	
	var neededHeight = UITableView.automaticDimension
	
	var members: [String] = []
	
	var childrenItems: [String] = []
	
	var selectedPictureName = "None"
	
	var sharedFiles: [String] = []
	
	var goalValueToHit = ""
	
	var goals: [String] = []
	
	var goalType = "Studying Time"
	
	var goalInterval = "Daily"
	
	var goalObjectivePlaceholder = "Write in minutes"
	
	var goalEndDate = Date()
	
	var teams: [String]{
		get{
			return controller.teamClues ?? []
		} set (newArray) {
			controller.teamClues = newArray
		}
	}
	
	var pickerManager = InlinePickerTableManager()
	
    var tableOriginalLoad = true
	
	var folder: String{
		get{
			return controller.folderClue ?? ""
		} set (newFolder){
			controller.folderClue = newFolder
		}
	}
	var isFavorite: Bool{
		get{
			return controller.favoriteClue ?? false
		} set (newFavorite){
			controller.favoriteClue = newFavorite
		}
	}
	
	var isPinned: Bool{
		get{
			return controller.pinClue ?? false
		} set (newFavorite){
			controller.pinClue = newFavorite
		}
	}
	var iconColor = "Blue"
	var originalURL: URL?{
		get{
			return controller.itemOriginalLocationClue
		}
	}
	var lastCellIndex = 0
	var visibleSpaceNeeded: CGPoint = .zero
	var tableManager: AddItemAddSubItemViewManager!
	var subItemClueManager: AddItemClueManager!
	
    @IBOutlet weak var displayingView: UITableView!
	@IBOutlet weak var inlinePickerTable: UITableView!
	@IBOutlet weak var importingLabel: UILabel!
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var opacityFilter: UIView!
	@IBOutlet weak var addItemView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		importingLabel.alpha = 0
		progressView.alpha = 0
		opacityFilter.alpha = 0
		addItemView.alpha = 0
		loadAddTableView()
        // Do any additional setup after loading the view.
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		if controller.loggedIn{
			toDrive = true
		}
        prepareTable()
    }

	@objc func keyboardWillShow(notification: Notification) {
//		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//			
//		}
		
//		self.view.frame.origin.y -= visibleSpaceNeeded.y - 35
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		controller.addItemKindSelected = ""
		controller.itemNameClue = nil
		controller.itemAuthorClue = nil
		controller.itemYearClue = nil
		controller.itemImageClue = []
		controller.isEditingClue = false
		controller.itemOriginalLocationClue = nil
		controller.folderClue = nil
		controller.collectionClues = nil
		controller.pinClue = nil
		controller.favoriteClue = nil
		controller.goalCategoryClue = nil
		controller.teamClues = nil
		controller.selectedCoverName = nil
		controller.selectedPaperName = nil
		controller.displayedPaperColor = nil
		controller.displayedOrientation = nil
		controller.refreshView()
	}
    
    @IBAction func dismiss(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toNewPickerView"{
			let destination = (segue.destination as! UINavigationController).viewControllers.first as! AddItemPickerSubviewController
			destination.controller = self
			if controller.addItemKindSelected == "newFile"{
				if pickerViewKind == "parent"{
					destination.currentParent = folder
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Parent Picker")
				} else if pickerViewKind == "collections"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Collection Picker")
					var collectionsForPicker: [InlinePickerItem] = []
					for id in collections{
						collectionsForPicker.append(controller.realm.objects(FileCollection.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = collectionsForPicker
				} else if pickerViewKind == "goals"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Goal Picker")
					var goalsForPicker: [InlinePickerItem] = []
					for id in goals{
						goalsForPicker.append(controller.realm.objects(Goal.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = goalsForPicker
				} else if pickerViewKind == "teams"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Team Picker")
					var teamsForPicker: [InlinePickerItem] = []
					for id in teams{
						teamsForPicker.append(controller.realm.objects(Friend.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = teamsForPicker
				}
			} else if controller.addItemKindSelected == "newNote"{
				if pickerViewKind == "parent"{
					destination.currentParent = folder
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Parent Picker")
				} else if pickerViewKind == "collections"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Collection Picker")
					var collectionsForPicker: [InlinePickerItem] = []
					for id in collections{
						collectionsForPicker.append(controller.realm.objects(FileCollection.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = collectionsForPicker
				} else if pickerViewKind == "goals"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Goal Picker")
					var goalsForPicker: [InlinePickerItem] = []
					for id in goals{
						goalsForPicker.append(controller.realm.objects(Goal.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = goalsForPicker
				} else if pickerViewKind == "teams"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Team Picker")
					var teamsForPicker: [InlinePickerItem] = []
					for id in teams{
						teamsForPicker.append(controller.realm.objects(Friend.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = teamsForPicker
				} else if pickerViewKind == "cover"{
					destination.displayingKind = "table"
					destination.displayingType = "categories"
					destination.pickerItem = PickerItem(destination, "Notebook Cover")
					destination.pickerItem.pickedImages = [PickerStyleImageItem(selectedCoverName)]
					destination.fullCategoriesContent = ["notebookPlain", "notebookCubes", "notebookCircles", "notebookFlowers", "notebookTech", "notebookPatterns", "notebookTextures"]
				} else if pickerViewKind == "paper"{
					destination.displayingKind = "table"
					destination.displayingType = "styles"
					destination.pickerItem = PickerItem(destination, "Notebook Paper")
					destination.pickerItem.pickedCarousels = [CarouselItem(itemImage: UIImage(named: "\(selectedPaperName)/\(displayedOrientation)/\(displayedPaperColor)")!, itemImageName: "\(selectedPaperName)/\(displayedOrientation)/\(displayedPaperColor)", itemTitleImage: 	"")]
				}
			} else if controller.addItemKindSelected == "newSet"{
				if pickerViewKind == "parent"{
					destination.currentParent = folder
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Parent Picker")
				} else if pickerViewKind == "collections"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Collection Picker")
					var collectionsForPicker: [InlinePickerItem] = []
					for id in collections{
						collectionsForPicker.append(controller.realm.objects(FileCollection.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = collectionsForPicker
				} else if pickerViewKind == "goals"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Goal Picker")
					var goalsForPicker: [InlinePickerItem] = []
					for id in goals{
						goalsForPicker.append(controller.realm.objects(Goal.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = goalsForPicker
				} else if pickerViewKind == "teams"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Team Picker")
					var teamsForPicker: [InlinePickerItem] = []
					for id in teams{
						teamsForPicker.append(controller.realm.objects(Friend.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = teamsForPicker
				} else if pickerViewKind == "color"{
					destination.displayingKind = "collection"
					destination.displayingType = "styles"
					destination.currentCategory = "flashCards"
					destination.pickerItem = PickerItem(destination, "Flashcard Color")
					switch iconColor {
					case "Blue":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardBlue")]
						break
					case "Black":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardBlack")]
						break
					case "Green":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardGreen")]
						break
					case "Grey":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardGrey")]
					case "Orange":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardOrange")]
						break
					case "Pink":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardPink")]
						break
					case "Purple":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardPurple")]
						break
					case "Red":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardRed")]
						break
					case "Turquoise":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardTurquoise")]
						break
					case "Yellow":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("cardYellow")]
						break
					default:
						print("error")
					}
				}
			} else if controller.addItemKindSelected == "newFolder"{
				if pickerViewKind == "parent"{
					destination.currentParent = folder
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Parent Picker")
				} else if pickerViewKind == "children"{
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Children Picker")
					var childrenForPicker: [FolderItem] = []
					for id in childrenItems{
						var currentChild: FolderItem!
							
						if let book = controller.realm.objects(Book.self).filter({$0.personalID == id}).first{
							currentChild = book
						} else if let notebook = controller.realm.objects(Notebook.self).filter({$0.personalID == id}).first {
							currentChild = notebook
						} else if let folderItem = controller.realm.objects(Folder.self).filter({$0.personalID == id}).first{
							currentChild = folderItem
						} else {
							currentChild = controller.realm.objects(TermSet.self).filter({$0.personalID == id}).first!
						}
						childrenForPicker.append(currentChild)
					}
					destination.pickerItem.pickedItems = childrenForPicker
				} else if pickerViewKind == "teams"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Team Picker")
					var teamsForPicker: [InlinePickerItem] = []
					for id in teams{
						teamsForPicker.append(controller.realm.objects(Friend.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = teamsForPicker
				} else if pickerViewKind == "color"{
					destination.displayingKind = "collection"
					destination.displayingType = "styles"
					destination.currentCategory = "folders"
					destination.pickerItem = PickerItem(destination, "Folder Color")
					switch iconColor {
					case "Blue":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconBlue")]
						break
					case "Black":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconBlack")]
						break
					case "Green":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconGreen")]
						break
					case "Grey":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconGrey")]
					case "Orange":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconOrange")]
						break
					case "Pink":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconPink")]
						break
					case "Purple":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconPurple")]
						break
					case "Red":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconRed")]
						break
					case "Turquoise":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconTurquoise")]
						break
					case "Yellow":
						destination.pickerItem.pickedImages = [PickerStyleImageItem("folderIconYellow")]
						break
					default:
						print("error")
					}
				}
			} else if controller.addItemKindSelected == "newCollection"{
				if pickerViewKind == "children"{
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Children Picker")
					var childrenForPicker: [FolderItem] = []
					for id in childrenItems{
						childrenForPicker.append(controller.realm.objects(Book.self).filter({$0.personalID == id}).first ?? controller.realm.objects(Notebook.self).filter({$0.personalID == id}).first ?? controller.realm.objects(TermSet.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedItems = childrenForPicker
				} else if pickerViewKind == "color"{
					destination.displayingKind = "collection"
					destination.displayingType = "styles"
					destination.currentCategory = "colors"
					destination.pickerItem = PickerItem(destination, "Item Color")
					destination.pickerItem.pickedImages = [PickerStyleImageItem(iconColor)]
				}
			} else if controller.addItemKindSelected == "newGoal"{
				if pickerViewKind == "teams"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Team Picker")
					var teamsForPicker: [InlinePickerItem] = []
					for id in teams{
						teamsForPicker.append(controller.realm.objects(Team.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = teamsForPicker
				}
			} else if controller.addItemKindSelected == "newTeam"{
				if pickerViewKind == "members"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Member Picker")
					var friendsForPicker: [InlinePickerItem] = []
					for id in members{
						friendsForPicker.append(controller.realm.objects(Friend.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = friendsForPicker
				} else if pickerViewKind == "sharedFiles"{
					destination.displayingKind = "collection"
					destination.displayingType = "items"
					destination.pickerItem = PickerItem(destination, "Shared File Picker")
					var childrenForPicker: [InlinePickerItem] = []
					for id in childrenItems{
						var currentChild: InlinePickerItem!
							
						if let book = controller.realm.objects(Book.self).filter({$0.personalID == id}).first{
							currentChild = book
						} else if let notebook = controller.realm.objects(Notebook.self).filter({$0.personalID == id}).first {
							currentChild = notebook
						} else if let folderItem = controller.realm.objects(Folder.self).filter({$0.personalID == id}).first{
							currentChild = folderItem
						} else {
							currentChild = controller.realm.objects(TermSet.self).filter({$0.personalID == id}).first!
						}
						childrenForPicker.append(currentChild)
					}
					destination.pickerItem.pickedElements = childrenForPicker
				} else if pickerViewKind == "goals"{
					destination.displayingKind = "table"
					destination.displayingType = "elements"
					destination.pickerItem = PickerItem(destination, "Goal Picker")
					var goalsForPicker: [InlinePickerItem] = []
					for id in goals{
						goalsForPicker.append(controller.realm.objects(Goal.self).filter({$0.personalID == id}).first!)
					}
					destination.pickerItem.pickedElements = goalsForPicker
				}
			}
		} else if segue.identifier == "toNewSubItem"{
			let destination = segue.destination as? AddItemViewController
			if tableManager.clueManager.addItemKindSelected != ""{
				destination?.controller = tableManager.clueManager
			} else {
				destination?.controller = subItemClueManager
			}
			
		}
    }

}
