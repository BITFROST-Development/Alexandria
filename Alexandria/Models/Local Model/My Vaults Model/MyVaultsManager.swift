////
////  MyVaultsManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/20/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import SocketIO
//
//extension MyVaultsViewController: UITableViewDelegate{
//    
//}
//
//extension MyVaultsViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemVaultCell.identifier) as! AddItemVaultCell
//        cell.controller = self
//        cell.separatorView.alpha = 0.0
//        if indexPath.row == 0{
//            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
//            cell.itemName.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
//            cell.itemName.setTitle("Add Vault", for: .normal)
//        } else if indexPath.row == 1 {
//            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 51/255, green: 175/255, blue: 218/255, alpha: 1))
//            cell.itemName.imageEdgeInsets.left = 18
//            cell.itemName.titleEdgeInsets.left = 30
//            cell.itemName.setImage(UIImage(systemName: "doc.on.clipboard.fill"), for: .normal)
//            cell.itemName.setTitle("Add Notebook", for: .normal)
//        } else {
//            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
//            cell.itemName.setImage(UIImage(systemName: "rectangle.fill.on.rectangle.angled.fill"), for: .normal)
//            cell.itemName.setTitle("Add Card Set", for: .normal)
//            
//        }
//        return cell
//    }
//    
//    
//}
//
//extension MyVaultsViewController: UICollectionViewDelegate{
//    
//}
//
//extension MyVaultsViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let alexandria = realm.objects(AlexandriaData.self)[0]
//        var count = 0
//        vaultsToDisplay.removeAll()
//        notesToDisplay.removeAll()
//        setsToDisplay.removeAll()
//        displayableObjects.removeAll()
//        
//        if currentVault != nil{
//            
//            if currentVault?.cloudVar.value ?? false {
//                
//                for vault in alexandria.cloudVaultMaps[Int(currentVault!.indexInArray.value!)].cloudChildVaults{
//                    count += 1
//                    vaultsToDisplay.append(alexandria.cloudVaults[Int(vault)])
//                }
//                
//                for vault in alexandria.cloudVaultMaps[Int(currentVault!.indexInArray.value!)].localChildVaults{
//                    count += 1
//                    vaultsToDisplay.append(alexandria.localVaults[Int(vault)])
//                }
//                
//                for noteBook in currentVault!.notes{
//                    count += 1
//                    notesToDisplay.append(noteBook)
//                }
//                
//                for noteBook in currentVault!.localNotes{
//                    count += 1
//                    notesToDisplay.append(noteBook)
//                }
//                
//                for set in currentVault!.termSets{
//                    count += 1
//                    setsToDisplay.append(set)
//                }
//                
//                for set in currentVault!.localTermSets{
//                    count += 1
//                    setsToDisplay.append(set)
//                }
//                
//            } else {
//                
//                for vault in alexandria.localVaultMaps[Int(currentVault!.indexInArray.value!)].localChildVaults{
//                    count += 1
//                    vaultsToDisplay.append(alexandria.localVaults[Int(vault)])
//                }
//                
//                for noteBook in currentVault!.localNotes{
//                    count += 1
//                    notesToDisplay.append(noteBook)
//                }
//                
//                for set in currentVault!.localTermSets{
//                    count += 1
//                    setsToDisplay.append(set)
//                }
//                
//            }
//        } else {
//            if alexandria.cloudVaultDivisionPoints.count > 0 {
//                for index in 0...Int(alexandria.cloudVaultDivisionPoints[0]) {
//                    vaultsToDisplay.append(alexandria.cloudVaults[index])
//                    count += 1
//                }
//            }
//            if alexandria.localVaultDivisionPoints.count > 0 {
//                for index in 0...Int(alexandria.localVaultDivisionPoints[0]) {
//                    vaultsToDisplay.append(alexandria.localVaults[index])
//                    count += 1
//                }
//            }
//        }
//        
//        displayableObjects.append(contentsOf: vaultsToDisplay)
//        displayableObjects.append(contentsOf: notesToDisplay)
//        displayableObjects.append(contentsOf: setsToDisplay)
//        displayableObjects = displayableObjects.sorted(by: {$0.name! < $1.name!})
//        return count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVaultsCollectionViewCell.identifier, for: indexPath) as! MyVaultsCollectionViewCell
//        cell.controller = self
//        cell.vaultTitle.text = displayableObjects[indexPath.row].name
//        cell.indexInVault = indexPath.row
//        if let vault = displayableObjects[indexPath.row] as? Vault{
//            cell.kind = "vault"
//            cell.iconShadow.alpha = 0
//            cell.currentVault = vault
//            switch vault.color?.colorName {
//            case "Blue":
//                cell.vaultIcon.image = UIImage(named: "vaultIconBlue")
//            case "Purple":
//                cell.vaultIcon.image = UIImage(named: "vaultIconPurple")
//            case "Pink":
//                cell.vaultIcon.image = UIImage(named: "vaultIconPink")
//            case "Red":
//                cell.vaultIcon.image = UIImage(named: "vaultIconRed")
//            case "Orange":
//                cell.vaultIcon.image = UIImage(named: "vaultIconOrange")
//            case "Yellow":
//                cell.vaultIcon.image = UIImage(named: "vaultIconYellow")
//            case "Green":
//                cell.vaultIcon.image = UIImage(named: "vaultIconGreen")
//            case "Turquoise":
//                cell.vaultIcon.image = UIImage(named: "vaultIconTurquoise")
//            case "Grey":
//                cell.vaultIcon.image = UIImage(named: "vaultIconGrey")
//            case "Black":
//                cell.vaultIcon.image = UIImage(named: "vaultIconBlack")
//            default:
//                print("There was an error displaying")
//            }
//        } else if let note = displayableObjects[indexPath.row] as? Notebook{
//            cell.kind = "note"
//            cell.vaultIcon.image = UIImage(named: note.coverStyle!)
//            cell.iconShadow.alpha = 1
//        } else if let set = displayableObjects[indexPath.row] as? TermSet{
//            cell.kind = "set"
//            cell.iconShadow.alpha = 0
//            switch set.color?.colorName {
//            case "Blue":
//                cell.vaultIcon.image = UIImage(named: "cardBlue")
//            case "Purple":
//                cell.vaultIcon.image = UIImage(named: "cardPurple")
//            case "Pink":
//                cell.vaultIcon.image = UIImage(named: "cardPink")
//            case "Red":
//                cell.vaultIcon.image = UIImage(named: "cardRed")
//            case "Orange":
//                cell.vaultIcon.image = UIImage(named: "cardOrange")
//            case "Yellow":
//                cell.vaultIcon.image = UIImage(named: "cardYellow")
//            case "Green":
//                cell.vaultIcon.image = UIImage(named: "cardGreen")
//            case "Turquoise":
//                cell.vaultIcon.image = UIImage(named: "cardTurquoise")
//            case "Grey":
//                cell.vaultIcon.image = UIImage(named: "cardGrey")
//            case "Black":
//                cell.vaultIcon.image = UIImage(named: "cardBlack")
//            default:
//                print("There was an error displaying")
//            }
//        }
//        
//        return cell
//    }
//    
//    
//}
//
//
//extension MyVaultsViewController{
//    
//    @IBAction func addButton(_ sender: Any) {
//        if addItemPresent{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.opacityFilter.alpha = 0
//                self.AddItemView.alpha = 0
//            }){ _ in
//                self.addItemPresent = false
//            }
//        } else {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.opacityFilter.alpha = 1
//                self.AddItemView.alpha = 1
//            }){ _ in
//                self.addItemPresent = true
//            }
//
//        }
//    }
//    
//    @IBAction func moveBack(_ sender: Any) {
//        let alexandria = realm.objects(AlexandriaData.self)[0]
//        if currentVault!.cloudVar.value ?? false {
//            let parent = alexandria.cloudVaultMaps[Int(currentVault!.indexInArray.value!)].parentVault.value
//            if parent != nil{
//                navigateToVault(alexandria.cloudVaults[Int(parent!)], towards: "left")
//            } else {
//                navigateToVault(nil, towards: "left")
//            }
//        } else {
//            let parent = alexandria.localVaultMaps[Int(currentVault!.indexInArray.value!)].parentVault.value
//            if parent != nil{
//                navigateToVault(alexandria.localVaults[Int(parent!)], towards: "left")
//            } else {
//                navigateToVault(nil, towards: "left")
//            }
//        }
//        
//    }
//    
//    func navigateToVault(_ vault: Vault?, towards direction: String){
//        if direction == "right"{
//            currentVault = vault
//            UIView.animate(withDuration: 0.5, animations: {
//                self.fileDisplayCollection.layer.frame.origin.x = 0 - self.view.layer.frame.width
//                if self.isRoot {
//                    self.navigationItem.setLeftBarButtonItems(self.intoLeftNavBar, animated: true)
//                    self.navigationItem.setRightBarButtonItems(self.intoRightNavBar, animated: true)
//                    self.isRoot = false
//                }
//            }){ _ in
//                self.fileDisplayCollection.reloadData()
//                self.fileDisplayCollection.layer.frame.origin.x = self.view.layer.frame.width
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.fileDisplayCollection.layer.frame.origin.x = 0
//                    self.navigationItem.title = vault?.name
//                })
//            }
//        } else {
//            let alexandria = realm.objects(AlexandriaData.self)[0]
//            if vault != nil {
//                if currentVault?.cloudVar.value ?? false {
//                    let newCurrentVault = alexandria.cloudVaults[Int(alexandria.cloudVaultMaps[Int(currentVault!.indexInArray.value!)].parentVault.value!)]
//                    currentVault = newCurrentVault
//                }  else {
//                    if alexandria.localVaultMaps[Int(currentVault!.indexInArray.value!)].parentCloudVar.value ?? false {
//                        let newCurrentVault = alexandria.cloudVaults[Int(alexandria.localVaultMaps[Int(currentVault!.indexInArray.value!)].parentVault.value!)]
//                        currentVault = newCurrentVault
//                    } else {
//                        let newCurrentVault = alexandria.localVaults[Int(alexandria.localVaultMaps[Int(currentVault!.indexInArray.value!)].parentVault.value!)]
//                        currentVault = newCurrentVault
//                    }
//                }
//            } else {
//                currentVault = nil
//            }
//            var finalTitle = ""
//            UIView.animate(withDuration: 0.5, animations: {
//                self.fileDisplayCollection.layer.frame.origin.x = self.view.layer.frame.width
//                if self.currentVault == nil {
//                    finalTitle = "My Vaults"
//                    self.isRoot = true
//                } else {
//                    finalTitle = self.currentVault!.name!
//                }
//
//                if self.isRoot {
//                    self.navigationItem.setLeftBarButtonItems(self.rootLeftNavBar, animated: true)
//                    self.navigationItem.setRightBarButtonItems(self.rootRightNavBar, animated: true)
//                }
//            }){ _ in
//                self.fileDisplayCollection.reloadData()
//                self.fileDisplayCollection.layer.frame.origin.x = 0 - self.view.layer.frame.width
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.fileDisplayCollection.layer.frame.origin.x = 0
//                    self.navigationItem.title = finalTitle
//                })
//            }
//        }
//    }
//    
//    func prepareCollectionView(){
//        fileDisplayCollection.delegate = self
//        fileDisplayCollection.dataSource = self
//        fileDisplayCollection.register(UINib(nibName: "MyVaultsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyVaultsCollectionViewCell.identifier)
//    }
//    
//    func prepareAddItemTableView(){
//        AddItemView.delegate = self
//        AddItemView.dataSource = self
//        AddItemView.layer.cornerRadius = 10
//        AddItemView.register(UINib(nibName: "AddItemVaultCell", bundle: nil), forCellReuseIdentifier: AddItemVaultCell.identifier)
//    }
//    
//    func goToCreateVault(){
//        itemKind = "vault"
//        UIView.animate(withDuration: 0.3, animations: {
//            self.AddItemView.alpha = 0
//            self.opacityFilter.alpha = 0
//        }){ _ in
//            self.addItemPresent = false
//        }
//        performSegue(withIdentifier: "addNewVaultSet", sender: self)
//    }
//    
//    func goToCreateNotebook(){
//        if currentVault != nil{
//            itemKind = "note"
//            UIView.animate(withDuration: 0.3, animations: {
//                self.AddItemView.alpha = 0
//                self.opacityFilter.alpha = 0
//            }){ _ in
//                self.addItemPresent = false
//            }
//            performSegue(withIdentifier: "addNewNotebook", sender: self)
//        } else {
//            let alert = UIAlertController(title: "No Vault Selected", message: "You need to select a vault to add create a notebook.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
//    }
//    
//    func goToCreateSet(){
//        if currentVault != nil {
//            itemKind = "set"
//            UIView.animate(withDuration: 0.3, animations: {
//                self.AddItemView.alpha = 0
//                self.opacityFilter.alpha = 0
//            }){ _ in
//                self.addItemPresent = false
//            }
//            performSegue(withIdentifier: "addNewVaultSet", sender: self)
//        } else {
//            let alert = UIAlertController(title: "No Vault Selected", message: "You need to select a vault to add create a term-set.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
//    }
//    
//    func goToEditNotebook(){
//        if editingNote!.cloudVar.value ?? false {
//            if Socket.sharedInstance.socket.status == SocketIOStatus.connected{
//                performSegue(withIdentifier: "toNotebookPreferences", sender: self)
//            } else {
//                let alert = UIAlertController(title: "No internet connection", message: "We can't edit your cloud file because you don't have an internet connection", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                present(alert, animated: true, completion: nil)
//            }
//        } else {
//            performSegue(withIdentifier: "toNotebookPreferences", sender: self)
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if segue.identifier != "toRegisterLogin" && segue.identifier != "toMyProfile"{
//            if segue.identifier == "toEditingView"{
//                let displayingView = segue.destination as! EditingViewController
//                if itemKind == "note"{
//                    displayingView.currentNotebook = notebookToOpen
//                    displayingView.controller = self
//                    displayingView.initialIndex = 1
//                } else {
//                    displayingView.currentSet = setToOpen
//                    displayingView.controller = self
//                    displayingView.initialIndex = 2
//                }
//            } else if segue.identifier == "toNotebookPreferences"{
//                let displayingView = segue.destination as! NotebookPreferencesViewController
//                displayingView.currentNotebook = editingNote!
//                displayingView.selectedCoverName = editingNote!.coverStyle!
//                displayingView.displayedPaperColor = editingNote!.sheetDefaultColor!
//                displayingView.displayedOrientation = editingNote!.sheetDefaultOrientation!
//                displayingView.selectedPaperName = editingNote!.sheetDefaultStyle!
//                displayingView.loggedIn = loggedIn
//                displayingView.parentVault = currentVault
//                displayingView.controller = self
//                
//            } else if itemKind == "vault"{
//                let displayingView = segue.destination as! NewVaultSetViewController
//                displayingView.currentVault = Vault()
//                displayingView.loggedIn = loggedIn
//                displayingView.parentVault = currentVault
//                displayingView.kind = itemKind
//                displayingView.controller = self
//            } else if itemKind == "note"{
//                let displayingView = segue.destination as! NewNotebookViewController
//                displayingView.currentNotebook = Notebook()
//                displayingView.loggedIn = loggedIn
//                displayingView.parentVault = currentVault
//                displayingView.controller = self
//            } else if itemKind == "set"{
//                let displayingView = segue.destination as! NewVaultSetViewController
//                displayingView.currentSet = TermSet()
//                displayingView.parentVault = currentVault
//                displayingView.loggedIn = loggedIn
//                displayingView.kind = itemKind
//                displayingView.controller = self
//            }
//        }
//    }
//    
//}
