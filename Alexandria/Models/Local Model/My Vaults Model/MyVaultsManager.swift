//
//  MyVaultsManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/20/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension MyVaultsViewController: UITableViewDelegate{
    
}

extension MyVaultsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemVaultCell.identifier) as! AddItemVaultCell
        cell.controller = self
        cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 254/255, green: 224/255, blue: 162/255, alpha: 1))
        if indexPath.row == 0{
            cell.itemName.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
            cell.itemName.setTitle("Add Vault", for: .normal)
        } else if indexPath.row == 1 {
            cell.itemName.imageEdgeInsets.left = 18
            cell.itemName.titleEdgeInsets.left = 30
            cell.itemName.setImage(UIImage(systemName: "doc.on.clipboard.fill"), for: .normal)
            cell.itemName.setTitle("Add Notebook", for: .normal)
        } else {
            cell.itemName.setImage(UIImage(systemName: "rectangle.fill.on.rectangle.angled.fill"), for: .normal)
            cell.itemName.setTitle("Add Card Set", for: .normal)
            cell.separatorView.alpha = 0.0
        }
        return cell
    }
    
    
}

extension MyVaultsViewController: UICollectionViewDelegate{
    
}

extension MyVaultsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cloudVaults = realm.objects(AlexandriaData.self)[0].vaults
        let localVaults = realm.objects(AlexandriaData.self)[0].localVaults
        var count = 0
        vaultsToDisplay.removeAll()
        notesToDisplay.removeAll()
        setsToDisplay.removeAll()
        for vault in cloudVaults {
            if vault.parentFolderID == parentFolderTitle || (vault.parentFolderID == nil && parentFolderTitle == ""){
                count += 1
                vaultsToDisplay.append(vault)
                for noteBook in vault.notes{
                    count += 1
                    notesToDisplay.append(noteBook)
                }
                
                for set in vault.sets {
                    count += 1
                    setsToDisplay.append(set)
                }
            }
        }
        for vault in localVaults {
            if vault.parentFolderID == parentFolderTitle || (vault.parentFolderID == nil && parentFolderTitle == ""){
                count += 1
                vaultsToDisplay.append(vault)
                for noteBook in vault.notes{
                    count += 1
                    notesToDisplay.append(noteBook)
                }
                
                for set in vault.sets {
                    count += 1
                    setsToDisplay.append(set)
                }
            }
        }
        displayableObjects.append(contentsOf: vaultsToDisplay)
        displayableObjects.append(contentsOf: notesToDisplay)
        displayableObjects.append(contentsOf: setsToDisplay)
        displayableObjects = displayableObjects.sorted(by: {$0.name! > $1.name!})
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVaultsCollectionViewCell.identifier, for: indexPath) as! MyVaultsCollectionViewCell
        cell.controller = self
        cell.vaultTitle.text = displayableObjects[indexPath.row].name
        if let vault = displayableObjects[indexPath.row] as? Vault{
            cell.kind = "vault"
            switch vault.color?.colorName {
            case "Blue":
                cell.vaultIcon.image = UIImage(named: "vaultIconBlue")
            case "Purple":
                cell.vaultIcon.image = UIImage(named: "vaultIconPurple")
            case "Pink":
                cell.vaultIcon.image = UIImage(named: "vaultIconPink")
            case "Red":
                cell.vaultIcon.image = UIImage(named: "vaultIconRed")
            case "Orange":
                cell.vaultIcon.image = UIImage(named: "vaultIconOrange")
            case "Yellow":
                cell.vaultIcon.image = UIImage(named: "vaultIconYellow")
            case "Green":
                cell.vaultIcon.image = UIImage(named: "vaultIconGreen")
            case "Turquoise":
                cell.vaultIcon.image = UIImage(named: "vaultIconTurquoise")
            case "Grey":
                cell.vaultIcon.image = UIImage(named: "vaultIconGrey")
            case "Black":
                cell.vaultIcon.image = UIImage(named: "vaultIconBlack")
            default:
                print("There was an error displaying")
            }
        } else if let note = displayableObjects[indexPath.row] as? Note{
            cell.kind = "note"
            cell.vaultIcon.image = UIImage(data: note.thumbnail!.data!)
        } else if let set = displayableObjects[indexPath.row] as? TermSet{
            cell.kind = "set"
            switch set.color?.colorName {
            case "Blue":
                cell.vaultIcon.image = UIImage(named: "vaultIconBlue")
            case "Purple":
                cell.vaultIcon.image = UIImage(named: "vaultIconPurple")
            case "Pink":
                cell.vaultIcon.image = UIImage(named: "vaultIconPink")
            case "Red":
                cell.vaultIcon.image = UIImage(named: "vaultIconRed")
            case "Orange":
                cell.vaultIcon.image = UIImage(named: "vaultIconOrange")
            case "Yellow":
                cell.vaultIcon.image = UIImage(named: "vaultIconYellow")
            case "Green":
                cell.vaultIcon.image = UIImage(named: "vaultIconGreen")
            case "Turquoise":
                cell.vaultIcon.image = UIImage(named: "vaultIconTurquoise")
            case "Grey":
                cell.vaultIcon.image = UIImage(named: "vaultIconGrey")
            case "Black":
                cell.vaultIcon.image = UIImage(named: "vaultIconBlack")
            default:
                print("There was an error displaying")
            }
        }
        
        return cell
    }
    
    
}


extension MyVaultsViewController{
    
    
    func navigateToVault(_ vault: Vault, towards direction: String){
        if direction == "right"{
            if vault.cloudVar.value ?? false {
                parentFolderTitle = vault.vaultFolderID ?? ""
                if currentVault != nil {
                    parentVaults?.append(currentVault!)
                }
                currentVault = vault
            } else {
                parentFolderTitle = vault.name ?? ""
                if currentVault != nil {
                    parentVaults?.append(currentVault!)
                }
                currentVault = vault
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.fileDisplayCollection.layer.frame.origin.x = 0 - self.view.layer.frame.width
            }){ _ in
                self.fileDisplayCollection.layer.frame.origin.x = self.view.layer.frame.width
                self.fileDisplayCollection.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.fileDisplayCollection.layer.frame.origin.x = 0
                    self.navigationItem.title = vault.name
                    if self.isRoot {
                        self.navigationItem.setLeftBarButtonItems(self.intoNavBar, animated: true)
                        self.isRoot = false
                    }
                })
            }
        } else {
            if vault.cloudVar.value ?? false {
                parentFolderTitle = vault.parentFolderID ?? ""
            } else if vault.vaultPathComponents.count > 0{
                parentFolderTitle = vault.vaultPathComponents[vault.vaultPathComponents.count - 1]
            } else {
                parentFolderTitle = ""
            }
            currentVault = parentVaults?.last
            parentVaults?.removeLast()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.fileDisplayCollection.layer.frame.origin.x = self.view.layer.frame.width
            }){ _ in
                self.fileDisplayCollection.layer.frame.origin.x = 0 - self.view.layer.frame.width
                self.fileDisplayCollection.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.fileDisplayCollection.layer.frame.origin.x = 0
                    self.navigationItem.title = vault.name
                    if self.parentFolderTitle == "" || (vault.parentFolderID == nil && self.parentFolderTitle == "") {
                        self.navigationItem.title = "My Vaults"
                        self.isRoot = true
                    }
                    if self.isRoot {
                        self.navigationItem.setLeftBarButtonItems(self.rootNavBar, animated: true)
                    }
                })
            }
        }
    }
    
    func prepareCollectionView(){
        fileDisplayCollection.delegate = self
        fileDisplayCollection.dataSource = self
        fileDisplayCollection.register(UINib(nibName: "MyVaultsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyVaultsCollectionViewCell.identifier)
    }
    
    func prepareAddItemTableView(){
        AddItemView.delegate = self
        AddItemView.dataSource = self
        AddItemView.layer.cornerRadius = 10
        AddItemView.register(UINib(nibName: "AddItemVaultCell", bundle: nil), forCellReuseIdentifier: AddItemVaultCell.identifier)
    }
    
    func goToCreateVault(){
        itemKind = "vault"
        performSegue(withIdentifier: "addNewVaultSet", sender: self)
    }
    
    func goToCreateNotebook(){
        itemKind = "note"
    }
    
    func goToCreateSet(){
        itemKind = "set"
        performSegue(withIdentifier: "addNewVaultSet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if itemKind == "vault"{
            let displayingView = segue.destination as! NewVaultSetViewController
            displayingView.currentVault = Vault()
            displayingView.loggedIn = loggedIn
            displayingView.parentFolderID = parentFolderTitle
            displayingView.parentVault =  currentVault
            displayingView.kind = itemKind
            displayingView.controller = self
        } else if itemKind == "note"{
            
        } else {
            let displayingView = segue.destination as! NewVaultSetViewController
            displayingView.currentSet = TermSet()
            displayingView.parentFolderID = parentFolderTitle
            displayingView.loggedIn = loggedIn
            displayingView.kind = itemKind
            displayingView.controller = self
        }
    }
    
}
