//
//  EditingFilePickerViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/25/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class EditingFilePickerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let realm = AppDelegate.realm!
    var controller: EditingViewController!
    var sourceKind: String!
    var isSearching = false
    var shouldRecoverShearch = true
    var filteredShelves: [Shelf]! = []
    var displayingShelves: [Shelf]! = []
    var currentShelf: Shelf!
    var filteredBooks: [Book]! = []
    var displayingBooks: [Book]! = []
    var filteredVaultItems: [VaultDisplayable]! = []
    var displayingVaultItems: [VaultDisplayable]! = []
    var currentVault: Vault!
    var currentVaultMap: VaultMap!{
        get{
            if currentVault != nil{
                if currentVault.cloudVar.value ?? false{
                    return realm.objects(AlexandriaData.self)[0].cloudVaultMaps[Int(currentVault.indexInArray.value!)]
                } else {
                    return realm.objects(AlexandriaData.self)[0].localVaultMaps[Int(currentVault.indexInArray.value!)]
                }
            } else {
                return nil
            }
        }
    }
    var parentVault: [Vault]! = []
    @IBOutlet weak var pickerCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerCollection.delegate = self
        pickerCollection.dataSource = self
        pickerCollection.register(UINib(nibName: "EditingFilePickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditingFilePickerCollectionViewCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(enableHideKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func enableHideKeyboard(_ notification: Notification){
        print(notification.debugDescription)
    }

}

extension EditingFilePickerViewController: UICollectionViewDelegate{
    
}

extension EditingFilePickerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let alexandria = realm.objects(AlexandriaData.self)[0]
        if !isSearching {
            if sourceKind == "Shelf"{
                displayingShelves.append(contentsOf: alexandria.shelves)
                displayingShelves.append(contentsOf: alexandria.localShelves)
                filteredShelves = displayingShelves
                return displayingShelves.count + 1
            } else if sourceKind == "Book"{
                if currentShelf != nil{
                    if currentShelf.cloudVar.value ?? false{
                        for index in 0..<currentShelf.books.count{
                            displayingBooks.append(alexandria.cloudBooks[index])
                        }
                        for index in 0..<currentShelf.oppositeBooks.count{
                            displayingBooks.append(alexandria.localBooks[index])
                        }
                        return displayingBooks.count
                    } else {
                        for index in 0..<currentShelf.books.count{
                            displayingBooks.append(alexandria.localBooks[index])
                        }
                        for index in 0..<currentShelf.oppositeBooks.count{
                            displayingBooks.append(alexandria.cloudBooks[index])
                        }
                        return displayingBooks.count
                    }
                } else {
                    displayingBooks.append(contentsOf: alexandria.cloudBooks)
                    displayingBooks.append(contentsOf: alexandria.localBooks)
                    filteredBooks = displayingBooks
                    return displayingBooks.count
                }
            } else if sourceKind == "Note"{
                var vaultsToDisplay:[Vault]! = []
                var notebooksToDisplay:[Note]! = []
                if currentVault == nil{
                    if realm.objects(Vault.self).count > 0{
                        if realm.objects(CloudUser.self).count > 0{
                            for index in 0...Int(alexandria.cloudVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.cloudVaults[index])
                            }
                            for index in 0...Int(alexandria.localVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.localVaults[index])
                            }
                        } else {
                            for index in 0...Int(alexandria.localVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.localVaults[index])
                            }
                        }
                    }
                } else {
                    for index in currentVaultMap.cloudChildVaults{
                        vaultsToDisplay.append(alexandria.cloudVaults[Int(index)])
                    }
                    
                    for index in currentVaultMap.localChildVaults{
                        vaultsToDisplay.append(alexandria.localVaults[Int(index)])
                    }
                    
                    notebooksToDisplay.append(contentsOf: currentVault.notes)
                    notebooksToDisplay.append(contentsOf: currentVault.localNotes)
                }
                displayingVaultItems.append(contentsOf: vaultsToDisplay)
                displayingVaultItems.append(contentsOf: notebooksToDisplay)
                displayingVaultItems = displayingVaultItems.sorted(by: {$0.name! < $1.name!})
                filteredVaultItems = displayingVaultItems
                return displayingVaultItems.count
            } else {
                var vaultsToDisplay:[Vault]! = []
                var setsToDisplay:[TermSet]! = []
                if currentVault == nil{
                    if realm.objects(Vault.self).count > 0{
                        if realm.objects(CloudUser.self).count > 0{
                            for index in 0...Int(alexandria.cloudVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.cloudVaults[index])
                            }
                            for index in 0...Int(alexandria.localVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.localVaults[index])
                            }
                        } else {
                            for index in 0...Int(alexandria.localVaultDivisionPoints[0]){
                                vaultsToDisplay.append(alexandria.localVaults[index])
                            }
                        }
                    }
                } else {
                    for index in currentVaultMap.cloudChildVaults{
                        vaultsToDisplay.append(alexandria.cloudVaults[Int(index)])
                    }
                    
                    for index in currentVaultMap.localChildVaults{
                        vaultsToDisplay.append(alexandria.localVaults[Int(index)])
                    }
                    
                    setsToDisplay.append(contentsOf: currentVault.termSets)
                    setsToDisplay.append(contentsOf: currentVault.localTermSets)
                }
                displayingVaultItems.append(contentsOf: vaultsToDisplay)
                displayingVaultItems.append(contentsOf: setsToDisplay)
                displayingVaultItems = displayingVaultItems.sorted(by: {$0.name! < $1.name!})
                filteredVaultItems = displayingVaultItems
                return displayingVaultItems.count
            }
        } else {
            if sourceKind == "Shelves"{
                return filteredShelves.count
            } else if sourceKind == "Book" {
                return filteredBooks.count
            } else {
                return filteredVaultItems.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "editingFilePickerHeader", for: indexPath) as? FilePickerSectionTitle{
            header.controller = self
            header.searchBar.delegate = self
            if sourceKind == "Shelf"{
                header.sectionTitle.text = "Pick a Shelf"
                header.backButton.alpha = 0
            } else if sourceKind == "Book"{
                if currentShelf != nil {
                    header.sectionTitle.text = currentShelf.name!
                } else {
                    header.sectionTitle.text = "All my books"
                }
                header.backButton.alpha = 1
            } else {
                if currentVault != nil{
                    header.backButton.alpha = 1
                    header.sectionTitle.text = currentVault.name!
                } else {
                    header.backButton.alpha = 0
                    header.sectionTitle.text = "Pick a Vault"
                }
            }
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditingFilePickerCollectionViewCell.identifier, for: indexPath) as! EditingFilePickerCollectionViewCell
        cell.controller = self
        cell.iconView.controller = cell
        cell.itemIndex = indexPath.row
        if !isSearching{
            if sourceKind == "Shelf"{
                cell.iconView.image = UIImage(named: "shelfIcon")
                
                cell.shadowView.alpha = 0
                if indexPath.row > 0{
                    let shelf = displayingShelves[indexPath.row - 1]
                    cell.itemTitle.text = shelf.name
                    cell.cellKind = "Shelf"
                } else {
                    cell.itemTitle.text = "All my books"
                    cell.cellKind = "Shelf"
                }
            } else if sourceKind == "Book"{
                cell.iconView.image = UIImage(data: displayingBooks[indexPath.row].thumbnail!.data!)
                cell.itemTitle.text = displayingBooks[indexPath.row].title!
                cell.cellKind = "Book"
                cell.shadowView.alpha = 1
                cell.shadowWidth.constant = 152
                cell.shadowHeight.constant = 182.9
            } else if sourceKind == "Note"{
                if let vault = displayingVaultItems[indexPath.row] as? Vault{
                    cell.cellKind = "Vault"
                    switch vault.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "vaultIconBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "vaultIconPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "vaultIconPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "vaultIconRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "vaultIconOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "vaultIconYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "vaultIconGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "vaultIconTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "vaultIconGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "vaultIconBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = vault.name!
                } else if let notebook = displayingVaultItems[indexPath.row] as? Note{
                    cell.iconView.image = UIImage(named: notebook.coverStyle!)
                    cell.cellKind = "Notebook"
                    cell.shadowView.alpha = 1
                    cell.shadowWidth.constant = 147
                    cell.shadowHeight.constant = 182.9
                    cell.itemTitle.text = notebook.name!
                }
            } else {
                if let vault = displayingVaultItems[indexPath.row] as? Vault{
                    cell.cellKind = "Vault"
                    switch vault.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "vaultIconBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "vaultIconPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "vaultIconPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "vaultIconRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "vaultIconOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "vaultIconYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "vaultIconGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "vaultIconTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "vaultIconGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "vaultIconBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = vault.name!
                } else if let set = displayingVaultItems[indexPath.row] as? TermSet{
                    switch set.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "cardBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "cardPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "cardPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "cardRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "cardOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "cardYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "cardGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "cardTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "cardGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "cardBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.cellKind = "Set"
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = set.name!
                }
            }
            return cell
        } else {
            if sourceKind == "Shelf"{
                cell.iconView.image = UIImage(named: "shelfIcon")
                cell.shadowView.alpha = 0
                let shelf = filteredShelves[indexPath.row]
                cell.itemTitle.text = shelf.name
                cell.cellKind = "Shelf"
            } else if sourceKind == "Book"{
                cell.iconView.image = UIImage(data: filteredBooks[indexPath.row].thumbnail!.data!)
                cell.itemTitle.text = filteredBooks[indexPath.row].title!
                cell.cellKind = "Book"
                cell.shadowView.alpha = 1
                cell.shadowWidth.constant = 152
                cell.shadowHeight.constant = 182.9
            } else if sourceKind == "Note"{
                if let vault = filteredVaultItems[indexPath.row] as? Vault{
                    cell.cellKind = "Vault"
                    switch vault.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "vaultIconBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "vaultIconPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "vaultIconPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "vaultIconRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "vaultIconOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "vaultIconYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "vaultIconGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "vaultIconTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "vaultIconGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "vaultIconBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = vault.name!
                } else if let notebook = filteredVaultItems[indexPath.row] as? Note{
                    cell.iconView.image = UIImage(named: notebook.coverStyle!)
                    cell.cellKind = "Notebook"
                    cell.shadowView.alpha = 1
                    cell.shadowWidth.constant = 147
                    cell.shadowHeight.constant = 182.9
                    cell.itemTitle.text = notebook.name!
                }
            } else {
                if let vault = filteredVaultItems[indexPath.row] as? Vault{
                    cell.cellKind = "Vault"
                    switch vault.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "vaultIconBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "vaultIconPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "vaultIconPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "vaultIconRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "vaultIconOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "vaultIconYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "vaultIconGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "vaultIconTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "vaultIconGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "vaultIconBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = vault.name!
                } else if let set = filteredVaultItems[indexPath.row] as? TermSet{
                    switch set.color?.colorName {
                    case "Blue":
                        cell.iconView.image = UIImage(named: "cardBlue")
                    case "Purple":
                        cell.iconView.image = UIImage(named: "cardPurple")
                    case "Pink":
                        cell.iconView.image = UIImage(named: "cardPink")
                    case "Red":
                        cell.iconView.image = UIImage(named: "cardRed")
                    case "Orange":
                        cell.iconView.image = UIImage(named: "cardOrange")
                    case "Yellow":
                        cell.iconView.image = UIImage(named: "cardYellow")
                    case "Green":
                        cell.iconView.image = UIImage(named: "cardGreen")
                    case "Turquoise":
                        cell.iconView.image = UIImage(named: "cardTurquoise")
                    case "Grey":
                        cell.iconView.image = UIImage(named: "cardGrey")
                    case "Black":
                        cell.iconView.image = UIImage(named: "cardBlack")
                    default:
                        print("There was an error displaying")
                    }
                    cell.cellKind = "Set"
                    cell.shadowView.alpha = 0
                    cell.itemTitle.text = set.name!
                }
            }
            return cell
        }
    }
}

extension EditingFilePickerViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = true
        shouldRecoverShearch = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if shouldRecoverShearch {
            return false
        } else {
            return true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        shouldRecoverShearch = false
        if self.sourceKind == "Shelf"{
            displayingShelves.removeAll()
        } else if self.sourceKind == "Book"{
            displayingBooks.removeAll()
        } else {
            displayingVaultItems.removeAll()
        }
        self.isSearching = false
        pickerCollection.reloadData()
        searchBar.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            self.isSearching = false
        }
        print("its going through")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldRecoverShearch = true
        if searchText != ""{
            if self.sourceKind == "Shelf"{
                var newFilter: [Shelf] = []
                for shelf in displayingShelves{
                    if shelf.name?.localizedCaseInsensitiveContains(searchText) ?? false{
                        newFilter.append(shelf)
                    }
                }
                filteredShelves = newFilter
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            } else if self.sourceKind == "Book"{
                var newFilter: [Book] = []
                for book in displayingBooks{
                    if book.title?.localizedCaseInsensitiveContains(searchText) ?? false{
                        newFilter.append(book)
                    }
                }
                filteredBooks = newFilter
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            } else {
                var newFilter: [VaultDisplayable] = []
                for item in displayingVaultItems{
                    if item.name?.localizedCaseInsensitiveContains(searchText) ?? false{
                        newFilter.append(item)
                    }
                }
                filteredVaultItems = newFilter
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            }
        } else {
            if self.sourceKind == "Shelf"{
                filteredShelves = displayingShelves
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            } else if self.sourceKind == "Book"{
                filteredBooks = displayingBooks
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            } else {
                filteredVaultItems = displayingVaultItems
                pickerCollection.performBatchUpdates({
                    pickerCollection.reloadData()
                }, completion: nil)
                self.shouldRecoverShearch = false
            }
        }
    }
}
