//
//  NewVaultSetManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension NewVaultSetViewController{
    
    func saveVaultSet () {
        let realm = AppDelegate.realm!
        if finalFileName != "" {
            if currentVault != nil {
                do{
                    if !updating {
                        try realm.write({
                            self.currentVault.birthName = finalFileName
                            self.currentVault.name = finalFileName
                            self.currentVault.color = IconColor()
                            self.currentVault.color?.red.value = Double(selectedColor.red)
                            self.currentVault.color?.green.value = Double(selectedColor.green)
                            self.currentVault.color?.blue.value = Double(selectedColor.blue)
                            self.currentVault.color?.colorName = selectedColor.colorName
                        })
                        if toDrive{
                            var parentString = ""
                            if parentVault != nil{
                                parentString = parentVault!.vaultFolderID!
                            } else {
                                parentString = "root"
                            }
                            GoogleDriveTools.createFolderForClient(parent: parentString, name: finalFileName){ folderID in
                                do {
                                    try realm.write({
                                        self.currentVault.vaultFolderID = folderID
                                        self.currentVault.cloudVar.value = true
                                    })
                                    if self.fileShouldBeMoved {
                                        var pathToFollow = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                                        var pathsForObject: [String] = []
                                        if self.parentVault != nil {
                                            for component in self.parentVault!.pathVaults{
                                                pathToFollow?.appendPathComponent(component)
                                                pathsForObject.append(component)
                                                if !FileManager.default.fileExists(atPath: pathToFollow!.path){
                                                    do{
                                                        try FileManager.default.createDirectory(at: pathToFollow!, withIntermediateDirectories: true, attributes: nil)
                                                    } catch let error {
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            }
                                        }
                                        pathToFollow?.appendPathComponent(self.currentVault.name!)
                                        pathsForObject.append(self.currentVault.name!)
                                        if !FileManager.default.fileExists(atPath: pathToFollow!.path){
                                            do{
                                                try FileManager.default.createDirectory(at: pathToFollow!, withIntermediateDirectories: true, attributes: nil)
                                                self.storeNewVault(){ successess in
                                                    if successess{
                                                        do{
                                                            try realm.write({
                                                                self.currentVault.pathVaults.append(objectsIn: pathsForObject)
                                                                self.currentVault.localAddress = pathToFollow?.path
                                                            })
                                                            Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
                                                            self.controller.itemKind = ""
                                                            self.controller.fileDisplayCollection.reloadData()
                                                            self.dismiss(animated: true, completion: nil)
                                                        } catch let error {
                                                            print(error.localizedDescription)
                                                        }
                                                    } else {
                                                        print("error in storeNewVault()")
                                                    }
                                                }
                                            } catch let error {
                                                print(error.localizedDescription)
                                            }
                                        } else {
                                            print("vault already exists")
                                        }
                                        
                                    } else {
                                        self.storeNewVault(){ successess in
                                            if successess {
                                                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
                                                self.controller.itemKind = ""
                                                self.controller.fileDisplayCollection.reloadData()
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        } else if fileShouldBeMoved{
                            var pathToFollow = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            var pathsForObject: [String] = []
                            if self.parentVault != nil {
                                for component in self.parentVault!.pathVaults{
                                    pathToFollow?.appendPathComponent(component)
                                    pathsForObject.append(component)
                                    if !FileManager.default.fileExists(atPath: pathToFollow!.path){
                                        do{
                                            try FileManager.default.createDirectory(at: pathToFollow!, withIntermediateDirectories: true, attributes: nil)
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                            pathToFollow?.appendPathComponent(self.currentVault.name!)
                            pathsForObject.append(self.currentVault.name!)
                            if !FileManager.default.fileExists(atPath: pathToFollow!.path){
                                do{
                                    try FileManager.default.createDirectory(at: pathToFollow!, withIntermediateDirectories: true, attributes: nil)
                                    self.storeNewVault(){successess in
                                        if successess {
                                            do{
                                                try realm.write({
                                                    self.currentVault.pathVaults.append(objectsIn: pathsForObject)
                                                    self.currentVault.localAddress = pathToFollow?.path
                                                    self.currentVault.vaultFolderID = ""
                                                    self.currentVault.cloudVar.value = false
                                                })
                                                self.controller.itemKind = ""
                                                self.controller.fileDisplayCollection.reloadData()
                                                self.dismiss(animated: true, completion: nil)
                                            } catch let error {
                                                print(error.localizedDescription)
                                            }
                                        } else {
                                            print("error in storeNewVault")
                                        }
                                    }
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else if currentSet != nil{
                if parentVault != nil {
                    do{
                        if !updating {
                            try realm.write({
                                self.currentSet.birthName = finalFileName
                                self.currentSet.name = finalFileName
                                self.currentSet.color = IconColor()
                                self.currentSet.color!.red.value = Double(selectedColor.red)
                                self.currentSet.color!.green.value = Double(selectedColor.green)
                                self.currentSet.color!.blue.value = Double(selectedColor.blue)
                                self.currentSet.color!.colorName = selectedColor.colorName
                                if self.toDrive{
                                    self.currentSet.cloudVar.value = true
                                    self.parentVault?.termSets.append(self.currentSet)
                                    Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
                                } else {
                                    self.currentSet.cloudVar.value = false
                                    self.parentVault?.localTermSets.append(self.currentSet)
                                }
                            })
                            self.controller.itemKind = ""
                            self.controller.fileDisplayCollection.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    let alert = UIAlertController(title: "Error Creating Set", message: "You can't create a set on your root vault! Try selecting an existing vault and creating your set inside that vault!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error Creating File", message: "You must provide a title to your file!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func storeNewVault(completion: (Bool) -> Void){
        let realm = AppDelegate.realm!
        let alexandria = realm.objects(AlexandriaData.self)[0]
        
        if toDrive{
            if self.parentVault != nil {
                let parentVaultMap = alexandria.cloudVaultMaps[Int(self.parentVault!.indexInArray.value!)]
                let end = parentVault!.pathVaults.count
                if alexandria.cloudVaultDivisionPoints.count > end{
                    if Int(alexandria.cloudVaultDivisionPoints[end]) != alexandria.cloudVaults.endIndex{
                        let newCloudVaultArray = RealmSwift.List<Vault>()
                        let newCloudVaultMapArray = RealmSwift.List<VaultMap>()
                        for index in 0...Int(alexandria.cloudVaultDivisionPoints[end]){
                            newCloudVaultArray.append(alexandria.cloudVaults[index])
                            newCloudVaultMapArray.append(alexandria.cloudVaultMaps[index])
                        }
                        do{
                            try realm.write({
                                parentVaultMap.cloudChildVaults.append(Double(alexandria.cloudVaultDivisionPoints[end]) + 1)
                                self.currentVault.indexInArray.value = Double(newCloudVaultArray.count)
                            })
                        } catch let error{
                            print(error.localizedDescription)
                            completion(false)
                        }
                        newCloudVaultArray.append(self.currentVault)
                        newCloudVaultMapArray.append(VaultMap())
                        newCloudVaultMapArray.last!.vault.value = self.currentVault.indexInArray.value
                        newCloudVaultMapArray.last!.parentVault.value = self.parentVault!.indexInArray.value!
                        newCloudVaultMapArray.last!.parentCloudVar.value = true
                        newCloudVaultMapArray.last!.indexInParent.value = Double(parentVaultMap.cloudChildVaults.count - 1)
                        do{
                            try realm.write({
                                for index in end..<alexandria.cloudVaultDivisionPoints.count{
                                    alexandria.cloudVaultDivisionPoints[index] += 1
                                }
                                for index in Int(alexandria.cloudVaultDivisionPoints[end])..<alexandria.cloudVaults.count{
                                    alexandria.cloudVaults[index].indexInArray.value! += 1
                                    let indexInParent = Int(alexandria.cloudVaultMaps[index].indexInParent.value!)
                                    let personalParentVaultMap = alexandria.cloudVaultMaps[Int(alexandria.cloudVaultMaps[index].parentVault.value!)]
                                    personalParentVaultMap.cloudChildVaults[indexInParent] += 1
                                    if Int(alexandria.cloudVaultMaps[index].parentVault.value!) >= Int(alexandria.cloudVaultDivisionPoints[end]){
                                        alexandria.cloudVaultMaps[index].parentVault.value! += 1
                                    }
                                    newCloudVaultArray.append(alexandria.cloudVaults[index])
                                    newCloudVaultMapArray.append(alexandria.cloudVaultMaps[index])
                                }
                                alexandria.cloudVaults.removeAll()
                                alexandria.cloudVaults.append(objectsIn: newCloudVaultArray)
                                alexandria.cloudVaultMaps.removeAll()
                                alexandria.cloudVaultMaps.append(objectsIn: newCloudVaultMapArray)
                            })
                            completion(true)
                        } catch let error {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    } else {
                        do{
                            try realm.write({
                                alexandria.cloudVaultDivisionPoints[end] += 1
                                parentVaultMap.cloudChildVaults.append(Double(alexandria.cloudVaultDivisionPoints[end]))
                                self.currentVault.indexInArray.value = Double(alexandria.cloudVaults.count)
                                alexandria.cloudVaults.append(self.currentVault)
                                alexandria.cloudVaultMaps.append(VaultMap())
                                alexandria.cloudVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                                alexandria.cloudVaultMaps.last!.parentVault.value = self.parentVault!.indexInArray.value!
                                alexandria.cloudVaultMaps.last!.parentCloudVar.value = true
                                alexandria.cloudVaultMaps.last!.indexInParent.value = Double(parentVaultMap.cloudChildVaults.count - 1)
                            })
                            completion(true)
                        } catch let error {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                } else {
                    do{
                        try realm.write({
                            let indexOfAddition = Double(alexandria.cloudVaults.count)
                            alexandria.cloudVaultDivisionPoints.append(indexOfAddition)
                            parentVaultMap.cloudChildVaults.append(indexOfAddition)
                            self.currentVault.indexInArray.value = indexOfAddition
                            alexandria.cloudVaults.append(self.currentVault)
                            alexandria.cloudVaultMaps.append(VaultMap())
                            alexandria.cloudVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                            alexandria.cloudVaultMaps.last!.parentVault.value = self.parentVault!.indexInArray.value!
                            alexandria.cloudVaultMaps.last!.parentCloudVar.value = true
                            alexandria.cloudVaultMaps.last!.indexInParent.value = Double(parentVaultMap.cloudChildVaults.count - 1)
                        })
                        completion(true)
                    } catch let error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            } else {
                if alexandria.cloudVaultDivisionPoints.count > 1{
                    let newCloudVaultArray = RealmSwift.List<Vault>()
                    let newCloudVaultMapArray = RealmSwift.List<VaultMap>()
                    for index in 0...Int(alexandria.cloudVaultDivisionPoints[0]){
                        newCloudVaultArray.append(alexandria.cloudVaults[index])
                        newCloudVaultMapArray.append(alexandria.cloudVaultMaps[index])
                    }
                    do{
                        try realm.write({
                            self.currentVault.indexInArray.value = Double(newCloudVaultArray.count)
                        })
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                    newCloudVaultArray.append(self.currentVault)
                    newCloudVaultMapArray.append(VaultMap())
                    newCloudVaultMapArray.last!.vault.value = self.currentVault.indexInArray.value
                    newCloudVaultMapArray.last!.parentCloudVar.value = true
                    do{
                        try realm.write({
                            for index in 0..<alexandria.cloudVaultDivisionPoints.count{
                                alexandria.cloudVaultDivisionPoints[index] += 1
                            }
                            for index in Int(alexandria.cloudVaultDivisionPoints[0])..<alexandria.cloudVaults.count{
                                alexandria.cloudVaults[index].indexInArray.value! += 1
                                let indexInParent = Int(alexandria.cloudVaultMaps[index].indexInParent.value!)
                                let personalParentVaultMap = alexandria.cloudVaultMaps[Int(alexandria.cloudVaultMaps[index].parentVault.value!)]
                                personalParentVaultMap.cloudChildVaults[indexInParent] += 1
                                if Int(alexandria.cloudVaultMaps[index].parentVault.value!) >= Int(alexandria.cloudVaultDivisionPoints[0]){
                                    alexandria.cloudVaultMaps[index].parentVault.value! += 1
                                }
                                newCloudVaultArray.append(alexandria.cloudVaults[index])
                                newCloudVaultMapArray.append(alexandria.cloudVaultMaps[index])
                            }
                            alexandria.cloudVaults.removeAll()
                            alexandria.cloudVaults.append(objectsIn: newCloudVaultArray)
                            alexandria.cloudVaultMaps.removeAll()
                            alexandria.cloudVaultMaps.append(objectsIn: newCloudVaultMapArray)
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                } else if alexandria.cloudVaultDivisionPoints.count == 1 {
                    do{
                        try realm.write({
                            alexandria.cloudVaultDivisionPoints[0] += 1
                            self.currentVault.indexInArray.value = Double(alexandria.cloudVaults.count)
                            alexandria.cloudVaults.append(self.currentVault)
                            alexandria.cloudVaultMaps.append(VaultMap())
                            alexandria.cloudVaultMaps.last!.parentCloudVar.value = true
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                } else {
                    do{
                        try realm.write({
                            let indexOfAddition = Double(alexandria.cloudVaults.count)
                            alexandria.cloudVaultDivisionPoints.append(indexOfAddition)
                            self.currentVault.indexInArray.value = indexOfAddition
                            alexandria.cloudVaults.append(self.currentVault)
                            alexandria.cloudVaultMaps.append(VaultMap())
                            alexandria.cloudVaultMaps.last!.parentCloudVar.value = true
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            }
        } else {
            if self.parentVault != nil{
                if self.parentVault!.cloudVar.value ?? false {
                    let parentVaultMap = alexandria.cloudVaultMaps[Int(self.parentVault!.indexInArray.value!)]
                    let end = parentVault!.pathVaults.count
                    if alexandria.localVaultDivisionPoints.count > end{
                        if Int(alexandria.localVaultDivisionPoints[end]) != alexandria.localVaults.count - 1{
                            let newLocalVaultArray = RealmSwift.List<Vault>()
                            let newLocalVaultMapArray = RealmSwift.List<VaultMap>()
                            for index in 0...Int(alexandria.localVaultDivisionPoints[end]){
                                newLocalVaultArray.append(alexandria.localVaults[index])
                                newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                            }
                            do{
                                try realm.write({
                                    parentVaultMap.localChildVaults.append(Double(alexandria.localVaultDivisionPoints[end]) + 1)
                                    self.currentVault.indexInArray.value = Double(newLocalVaultArray.count)
                                })
                            } catch let error {
                                print(error.localizedDescription)
                                completion(false)
                            }
                            newLocalVaultArray.append(self.currentVault)
                            newLocalVaultMapArray.append(VaultMap())
                            newLocalVaultMapArray.last!.vault.value = self.currentVault.indexInArray.value
                            newLocalVaultMapArray.last!.parentVault.value = self.parentVault!.indexInArray.value!
                            newLocalVaultMapArray.last!.parentCloudVar.value = true
                            newLocalVaultMapArray.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                            do{
                                try realm.write({
                                    for index in end..<alexandria.localVaultDivisionPoints.count{
                                        alexandria.localVaultDivisionPoints[index] += 1
                                    }
                                    for index in Int(alexandria.localVaultDivisionPoints[end])..<alexandria.localVaults.count{
                                        alexandria.localVaults[index].indexInArray.value! += 1
                                        let indexInParent = Int(alexandria.localVaultMaps[index].indexInParent.value!)
                                        let personalParentVaultMap = alexandria.cloudVaultMaps[Int(alexandria.localVaultMaps[index].parentVault.value!)]
                                        personalParentVaultMap.localChildVaults[indexInParent] += 1
                                        newLocalVaultArray.append(alexandria.localVaults[index])
                                        newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                                    }
                                    alexandria.localVaults.removeAll()
                                    alexandria.localVaults.append(objectsIn: newLocalVaultArray)
                                    alexandria.localVaultMaps.removeAll()
                                    alexandria.localVaultMaps.append(objectsIn: newLocalVaultMapArray)
                                })
                                completion(true)
                            } catch let error {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        } else {
                            do{
                                try realm.write({
                                    alexandria.localVaultDivisionPoints[end] += 1
                                    parentVaultMap.localChildVaults.append(Double(alexandria.localVaultDivisionPoints[end]))
                                    self.currentVault.indexInArray.value = Double(alexandria.localVaults.count)
                                    alexandria.localVaults.append(self.currentVault)
                                    alexandria.localVaultMaps.append(VaultMap())
                                    alexandria.localVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                                    alexandria.localVaultMaps.last!.parentVault.value = self.parentVault!.indexInArray.value!
                                    alexandria.localVaultMaps.last!.parentCloudVar.value = true
                                    alexandria.localVaultMaps.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                                    
                                })
                                completion(true)
                            } catch let error {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                    } else {
                        do{
                            try realm.write({
                                for _ in 0...end{
                                    if alexandria.localVaultDivisionPoints.count <= end{
                                        alexandria.localVaultDivisionPoints.append(Double(alexandria.localVaults.endIndex))
                                    }
                                }
                                alexandria.localVaultDivisionPoints[end] += 1
                                parentVaultMap.localChildVaults.append(Double(alexandria.localVaultDivisionPoints[end]))
                                self.currentVault.indexInArray.value = Double(alexandria.localVaults.count)
                                alexandria.localVaults.append(self.currentVault)
                                alexandria.localVaultMaps.append(VaultMap())
                                alexandria.localVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                                alexandria.localVaultMaps.last!.parentVault.value =  self.parentVault!.indexInArray.value!
                                alexandria.localVaultMaps.last!.parentCloudVar.value = true
                                alexandria.localVaultMaps.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                            })
                            completion(true)
                        } catch let error {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                } else {
                    let parentVaultMap = alexandria.localVaultMaps[Int(self.parentVault!.indexInArray.value!)]
                    let end = parentVault!.pathVaults.count
                    if alexandria.localVaultDivisionPoints.count > end{
                        if Int(alexandria.localVaultDivisionPoints[end]) != alexandria.localVaults.endIndex{
                            let newLocalVaultArray = RealmSwift.List<Vault>()
                            let newLocalVaultMapArray = RealmSwift.List<VaultMap>()
                            for index in 0...Int(alexandria.localVaultDivisionPoints[end]){
                                newLocalVaultArray.append(alexandria.localVaults[index])
                                newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                            }
                            do{
                                try realm.write({
                                    parentVaultMap.localChildVaults.append(Double(alexandria.localVaultDivisionPoints[end]) + 1)
                                    self.currentVault.indexInArray.value = Double(newLocalVaultArray.count)
                                })
                            } catch let error {
                                print(error.localizedDescription)
                                completion (false)
                            }
                            newLocalVaultArray.append(self.currentVault)
                            newLocalVaultMapArray.append(VaultMap())
                            newLocalVaultMapArray.last!.parentVault.value = self.parentVault!.indexInArray.value!
                            newLocalVaultMapArray.last!.parentCloudVar.value = false
                            newLocalVaultMapArray.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                            do{
                                try realm.write({
                                    for index in end..<alexandria.localVaultDivisionPoints.count{
                                        alexandria.localVaultDivisionPoints[index] += 1
                                    }
                                    for index in Int(alexandria.localVaultDivisionPoints[end])..<alexandria.localVaults.count{
                                        alexandria.localVaults[index].indexInArray.value! += 1
                                        let indexInParent = Int(alexandria.localVaultMaps[index].indexInParent.value!)
                                        let personalParentVaultMap = alexandria.localVaultMaps[Int(alexandria.localVaultMaps[index].parentVault.value!)]
                                        personalParentVaultMap.localChildVaults[indexInParent] += 1
                                        if Int(alexandria.localVaultMaps[index].parentVault.value!) >= Int(alexandria.localVaultDivisionPoints[end]){
                                            alexandria.localVaultMaps[index].parentVault.value! += 1
                                        }
                                        newLocalVaultArray.append(alexandria.localVaults[index])
                                        newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                                    }
                                    alexandria.localVaults.removeAll()
                                    alexandria.localVaults.append(objectsIn: newLocalVaultArray)
                                    alexandria.localVaultMaps.removeAll()
                                    alexandria.localVaultMaps.append(objectsIn: newLocalVaultMapArray)
                                })
                                completion(true)
                            } catch let error {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        } else {
                            do{
                                try realm.write({
                                    alexandria.localVaultDivisionPoints[end] += 1
                                    parentVaultMap.localChildVaults.append(Double(alexandria.localVaultDivisionPoints[end]))
                                    self.currentVault.indexInArray.value = Double(alexandria.localVaults.count)
                                    alexandria.localVaults.append(self.currentVault)
                                    alexandria.localVaultMaps.append(VaultMap())
                                    alexandria.localVaultMaps.last!.parentVault.value = self.parentVault!.indexInArray.value!
                                    alexandria.localVaultMaps.last!.parentCloudVar.value = false
                                    alexandria.localVaultMaps.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                                })
                                completion(true)
                            } catch let error {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                    } else {
                        do{
                            try realm.write({
                                let indexOfAddition = Double(alexandria.localVaults.count)
                                parentVaultMap.localChildVaults.append(Double(indexOfAddition))
                                alexandria.localVaultDivisionPoints.append(indexOfAddition)
                                self.currentVault.indexInArray.value = indexOfAddition
                                alexandria.localVaults.append(self.currentVault)
                                alexandria.localVaultMaps.append(VaultMap())
                                alexandria.localVaultMaps.last!.parentVault.value = self.parentVault!.indexInArray.value!
                                alexandria.localVaultMaps.last!.parentCloudVar.value = false
                                alexandria.localVaultMaps.last!.indexInParent.value = Double(parentVaultMap.localChildVaults.count - 1)
                            })
                            completion(true)
                        } catch let error {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                }
            } else {
                if alexandria.localVaultDivisionPoints.count > 1{
                    let newLocalVaultArray = RealmSwift.List<Vault>()
                    let newLocalVaultMapArray = RealmSwift.List<VaultMap>()
                    for index in 0...Int(alexandria.localVaultDivisionPoints[0]){
                        newLocalVaultArray.append(alexandria.localVaults[index])
                        newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                    }
                    do{
                        try realm.write({
                            self.currentVault.indexInArray.value = Double(newLocalVaultArray.count)
                        })
                    } catch let error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                    newLocalVaultArray.append(self.currentVault)
                    newLocalVaultMapArray.append(VaultMap())
                    newLocalVaultMapArray.last!.vault.value = self.currentVault.indexInArray.value
                    newLocalVaultMapArray.last!.parentCloudVar.value = false
                    do{
                        try realm.write({
                            for index in 0..<alexandria.localVaultDivisionPoints.count{
                                alexandria.localVaultDivisionPoints[index] += 1
                            }
                            for index in Int(alexandria.localVaultDivisionPoints[0])..<alexandria.localVaults.count{
                                alexandria.localVaults[index].indexInArray.value! += 1
                                let indexInParent = Int(alexandria.localVaultMaps[index].indexInParent.value!)
                                let personalParentVaultMap: VaultMap!
                                if alexandria.localVaultMaps[index].parentCloudVar.value ?? false {
                                     personalParentVaultMap = alexandria.cloudVaultMaps[Int(alexandria.localVaultMaps[index].parentVault.value!)]
                                } else {
                                    personalParentVaultMap = alexandria.localVaultMaps[Int(alexandria.localVaultMaps[index].parentVault.value!)]
                                }
                                if Int(alexandria.localVaultMaps[index].parentVault.value!) >= Int(alexandria.localVaultDivisionPoints[0]){
                                    alexandria.localVaultMaps[index].parentVault.value! += 1
                                }
                                personalParentVaultMap.localChildVaults[indexInParent] += 1
                                newLocalVaultArray.append(alexandria.localVaults[index])
                                newLocalVaultMapArray.append(alexandria.localVaultMaps[index])
                            }
                            alexandria.localVaults.removeAll()
                            alexandria.localVaults.append(objectsIn: newLocalVaultArray)
                            alexandria.localVaultMaps.removeAll()
                            alexandria.localVaultMaps.append(objectsIn: newLocalVaultMapArray)
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                } else if alexandria.localVaultDivisionPoints.count == 1{
                    do{
                        try realm.write({
                            alexandria.localVaultDivisionPoints[0] += 1
                            self.currentVault.indexInArray.value = Double(alexandria.localVaults.count)
                            alexandria.localVaults.append(self.currentVault)
                            alexandria.localVaultMaps.append(VaultMap())
                            alexandria.localVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                            alexandria.localVaultMaps.last!.parentCloudVar.value = false
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                } else {
                    do{
                        try realm.write({
                            let indexOfAddition = Double(alexandria.localVaults.count)
                            alexandria.localVaultDivisionPoints.append(indexOfAddition)
                            self.currentVault.indexInArray.value = indexOfAddition
                            alexandria.localVaults.append(self.currentVault)
                            alexandria.localVaultMaps.append(VaultMap())
                            alexandria.localVaultMaps.last!.vault.value = self.currentVault.indexInArray.value
                            alexandria.localVaultMaps.last!.parentCloudVar.value = false
                        })
                        completion(true)
                    } catch let error{
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toColorPicker" {
            let displayView = segue.destination as! ColorPickerViewController
            displayView.pickedColor = selectedColor
            displayView.controller = self
        }
    }
}
