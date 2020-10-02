//
//  NewUserManager.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/6/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift
import GTMAppAuth
import GAppAuth

class NewUserManager{
    
    static let realm = try! Realm(configuration: AppDelegate.realmConfig)
    
    static func createNewCloudUser(username: UserData, presenterView: UIViewController, completion: @escaping() -> Void) {
        let logedUser = CloudUser()
        logedUser.name = username.name!
        logedUser.lastname = username.lastName!
        logedUser.username = username.username!
        logedUser.email = username.email!
        logedUser.subscription = username.subscription!
        logedUser.subscriptionStatus = username.subscriptionStatus!
        logedUser.daysLeftOnSubscription.value = username.daysLeftOnSubscription
        logedUser.googleAccountEmail = username.googleAccountEmail!
        for index in 0 ..< (username.teamIDs?.count ?? 0){
            logedUser.teamIDs[index] = username.teamIDs![0]
        }
        
        if username.alexandria != nil {
            logedUser.alexandriaData! ^ username.alexandria!
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandriaData != nil{
                
                if unloggedUser[0].alexandriaData!.goals.count != 0{
                    if logedUser.alexandriaData!.goals.count == 0{
                        logedUser.alexandriaData!.goals = unloggedUser[0].alexandriaData!.goals
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.goals.count{
                            logedUser.alexandriaData?.goals.append((unloggedUser[0].alexandriaData?.goals[goal])!)
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.trophies.count != 0{
                    if logedUser.alexandriaData!.trophies.count == 0{
                        logedUser.alexandriaData!.trophies = unloggedUser[0].alexandriaData!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.trophies.count{
                            logedUser.alexandriaData!.trophies.append(unloggedUser[0].alexandriaData!.trophies[goal])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.localBooks.count != 0{
                    logedUser.alexandriaData!.localBooks = unloggedUser[0].alexandriaData!.localBooks
                }
                if unloggedUser[0].alexandriaData!.localShelves.count != 0{
                    logedUser.alexandriaData!.localShelves = unloggedUser[0].alexandriaData!.localShelves
                }
                if unloggedUser[0].alexandriaData!.cloudBooks.count != 0{
                    if logedUser.alexandriaData!.cloudBooks.count == 0{
                        logedUser.alexandriaData!.cloudBooks = unloggedUser[0].alexandriaData!.cloudBooks
                    }
                }
                if unloggedUser[0].alexandriaData!.shelves.count != 0{
                    if logedUser.alexandriaData!.shelves.count == 0{
                        logedUser.alexandriaData!.shelves = unloggedUser[0].alexandriaData!.shelves
                    }
                }
                if unloggedUser[0].alexandriaData!.cloudVaults.count != 0{
                    if logedUser.alexandriaData!.cloudVaults.count == 0{
                        logedUser.alexandriaData!.cloudVaults = unloggedUser[0].alexandriaData!.cloudVaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.cloudVaults.count{
                            logedUser.alexandriaData!.cloudVaults.append(unloggedUser[0].alexandriaData!.cloudVaults[vault])
                        }
                    }
                }
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
                realm.add(BookToListMap())
            }
        }catch {
            print(error)
        }
        if !unloggedUser[0].alexandriaData!.isEmpty() {
            do{
                try realm.write({
                    realm.delete(unloggedUser[0].alexandriaData!)
                    realm.delete(unloggedUser)
                    let alert = UIAlertController(title: "Cloud Merge", message: "Would you like to merge all your local data with your account?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Don't Merge", style: .default, handler: { _ in
                        completion()
                    }))
                    alert.addAction(UIAlertAction(title: "Merge", style: .cancel, handler: { _ in
                        do{
                            try realm.write(){
                                for book in 0..<logedUser.alexandriaData!.localBooks.count{
                                    logedUser.alexandriaData!.localBooks[book].cloudVar.value = true
                                    let hashMap = realm.objects(BookToListMap.self)
                                    let shelves = hashMap[0].keys[book].values
                                    for shelf in shelves {
                                        shelf.value?.books[shelf.indexInShelf.value!] = Double(logedUser.alexandriaData!.cloudBooks.count)
                                        hashMap[1].append(key: Double(logedUser.alexandriaData!.cloudBooks.count), value: shelf.value!, isCloud: true)
                                    }
                                    logedUser.alexandriaData!.cloudBooks.append(logedUser.alexandriaData!.localBooks[book])
                                }
                                logedUser.alexandriaData!.localBooks.removeAll()
                                for shelf in logedUser.alexandriaData!.localShelves{
                                    shelf.cloudVar.value = true
                                    logedUser.alexandriaData!.shelves.append(shelf)
                                }
                                logedUser.alexandriaData!.localShelves.removeAll()
                                Socket.sharedInstance.updateAlexandriaCloud(username: logedUser.username, alexandriaInfo: AlexandriaDataDec(true))
                                completion()
                            }
                            let dispatchGroup = DispatchGroup()
                            var shouldCallFunction = true
                            var currentVault = logedUser.alexandriaData!.localVaults[0]
                            var currentVaultMap: VaultMap{
                                get{
                                    return logedUser.alexandriaData!.localVaultMaps[Int(currentVault.indexInArray.value!)]
                                }
                            }
                            var isRoot: Bool {
                                get{
                                    if logedUser.alexandriaData!.localVaultMaps[Int(currentVault.indexInArray.value!)].parentVault.value != nil{
                                        return false
                                    } else {
                                        return true
                                    }
                                }
                            }
                            var outermostIndex = 0
                            var currentVaultParents: [Double] = []
                            var vaultLastCheckedIndices: [Int] = []
                            var vaultChildrenSize = 0
                            var hasCountedChildren = false
                            var currentDivisionIndex = 0
                            var indexDivisionsChecked: [Int] = [0]
                            var newCloudVaults = RealmSwift.List<Vault>()
                            var newCloudVaultMaps = RealmSwift.List<VaultMap>()
                            var vaultRootToDriveList: [Vault] = []
                            
                            while true {
                                if shouldCallFunction{
                                    let lists = addCorrespondingVaults(for: currentDivisionIndex, with: newCloudVaults, and: newCloudVaultMaps)
                                    newCloudVaults = lists.0
                                    newCloudVaultMaps = lists.1
                                    shouldCallFunction = false
                                    indexDivisionsChecked.append(currentDivisionIndex)
                                } else if outermostIndex > Int(logedUser.alexandriaData!.localVaultDivisionPoints[0]){
                                    break
                                } else {
                                    if currentVaultMap.localChildVaults.count > 0{
                                        if !hasCountedChildren{
                                            vaultChildrenSize = currentVaultMap.localChildVaults.count
                                        }
                                        if currentVaultMap.localChildVaults.count - vaultChildrenSize != currentVaultMap.localChildVaults.count{
                                            currentVaultParents.append(currentVault.indexInArray.value!)
                                            currentVault = logedUser.alexandriaData!.localVaults[Int(currentVaultMap.localChildVaults[currentVaultMap.localChildVaults.count - vaultChildrenSize])]
                                            if indexDivisionsChecked.endIndex < currentDivisionIndex{
                                                shouldCallFunction = true
                                            }
                                            vaultChildrenSize = vaultChildrenSize - 1
                                            vaultLastCheckedIndices.append(currentVaultMap.localChildVaults.count - vaultChildrenSize)
                                            hasCountedChildren = false
                                            currentDivisionIndex += 1
                                        } else {
                                            currentVaultMap.cloudChildVaults.append(objectsIn: currentVaultMap.localChildVaults)
                                            currentVaultMap.localChildVaults.removeAll()
                                            currentVault.notes.append(objectsIn: currentVault.localNotes)
                                            currentVault.localNotes.removeAll()
                                            currentVault.termSets.append(objectsIn: currentVault.localTermSets)
                                            currentVault.localTermSets.removeAll()
                                            do{
                                                try realm.write({
                                                    currentVault.cloudVar.value = true
                                                    currentVaultMap.parentCloudVar.value = true
                                                    if logedUser.alexandriaData!.cloudVaultDivisionPoints.count > currentDivisionIndex{
                                                        for index in currentDivisionIndex..<logedUser.alexandriaData!.cloudVaultDivisionPoints.count{
                                                            logedUser.alexandriaData!.cloudVaultDivisionPoints[index] += 1
                                                        }
                                                    } else {
                                                        while logedUser.alexandriaData!.cloudVaultDivisionPoints.count <= currentDivisionIndex{
                                                            logedUser.alexandriaData!.cloudVaultDivisionPoints.append(logedUser.alexandriaData!.cloudVaultDivisionPoints.last ?? 0)
                                                        }
                                                        logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex] += 1
                                                    }
                                                    currentVault.indexInArray.value = logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]
                                                    for index in Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]) + 1..<logedUser.alexandriaData!.cloudVaults.count{
                                                        let thisVault = logedUser.alexandriaData!.cloudVaults[index]
                                                        let thisVaultMap = logedUser.alexandriaData!.cloudVaultMaps[index]
                                                        thisVault.indexInArray.value! += 1
                                                        if thisVaultMap.parentVault.value != nil{
                                                            logedUser.alexandriaData!.cloudVaultMaps[Int(thisVaultMap.parentVault.value!)].cloudChildVaults[Int(thisVaultMap.indexInParent.value!)] += 1
                                                        }
                                                    }
                                                })
                                                newCloudVaults.insert(currentVault, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                                newCloudVaultMaps.insert(currentVaultMap, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                                vaultRootToDriveList.append(currentVault)
                                                if isRoot {
                                                    vaultRootToDriveList = vaultRootToDriveList.sorted(by: { $0.indexInArray.value! < $1.indexInArray.value! })
                                                    uploadRootAndChildrenToDrive(from: vaultRootToDriveList, for: newCloudVaults, in: newCloudVaultMaps, and: dispatchGroup)
                                                    dispatchGroup.notify(queue: .main, execute: {
                                                        outermostIndex += 1
                                                        vaultRootToDriveList.removeAll()
                                                    })
                                                } else {
                                                    let lastParent = currentVaultParents.last!
                                                    vaultChildrenSize = vaultLastCheckedIndices.last!
                                                    currentVault = logedUser.alexandriaData!.localVaults[Int(lastParent)]
                                                    currentVaultParents.removeLast()
                                                    vaultLastCheckedIndices.removeLast()
                                                }
                                                hasCountedChildren = true
                                                currentDivisionIndex -= 1
                                            } catch let error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    } else {
                                        currentVault.notes.append(objectsIn: currentVault.localNotes)
                                        currentVault.localNotes.removeAll()
                                        currentVault.termSets.append(objectsIn: currentVault.localTermSets)
                                        currentVault.localTermSets.removeAll()
                                        do{
                                            try realm.write({
                                                currentVault.cloudVar.value = true
                                                currentVaultMap.parentCloudVar.value = true
                                            
                                                if logedUser.alexandriaData!.cloudVaultDivisionPoints.count > currentDivisionIndex{
                                                    for index in currentDivisionIndex..<logedUser.alexandriaData!.cloudVaultDivisionPoints.count{
                                                        logedUser.alexandriaData!.cloudVaultDivisionPoints[index] += 1
                                                    }
                                                } else {
                                                    while logedUser.alexandriaData!.cloudVaultDivisionPoints.count <= currentDivisionIndex{
                                                        logedUser.alexandriaData!.cloudVaultDivisionPoints.append(logedUser.alexandriaData!.cloudVaultDivisionPoints.last ?? 0)
                                                    }
                                                    logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex] += 1
                                                }
                                                currentVault.indexInArray.value = logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]
                                                for index in Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]) + 1..<logedUser.alexandriaData!.cloudVaults.count{
                                                    let thisVault = logedUser.alexandriaData!.cloudVaults[index]
                                                    let thisVaultMap = logedUser.alexandriaData!.cloudVaultMaps[index]
                                                    thisVault.indexInArray.value! += 1
                                                    if thisVaultMap.parentVault.value != nil{
                                                        logedUser.alexandriaData!.cloudVaultMaps[Int(thisVaultMap.parentVault.value!)].cloudChildVaults[Int(thisVaultMap.indexInParent.value!)] += 1
                                                    }
                                                }
                                            })
                                            newCloudVaults.insert(currentVault, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                            newCloudVaultMaps.insert(currentVaultMap, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                            vaultRootToDriveList.append(currentVault)
                                            if isRoot {
                                                vaultRootToDriveList = vaultRootToDriveList.sorted(by: { $0.indexInArray.value! < $1.indexInArray.value! })
                                                uploadRootAndChildrenToDrive(from: vaultRootToDriveList, for: newCloudVaults, in: newCloudVaultMaps, and: dispatchGroup)
                                                dispatchGroup.notify(queue: .main, execute: {
                                                    outermostIndex += 1
                                                    vaultRootToDriveList.removeAll()
                                                })
                                            } else {
                                                let lastParent = currentVaultParents.last!
                                                vaultChildrenSize = vaultLastCheckedIndices.last!
                                                currentVault = logedUser.alexandriaData!.localVaults[Int(lastParent)]
                                                currentVaultParents.removeLast()
                                                vaultLastCheckedIndices.removeLast()
                                            }
                                            hasCountedChildren = true
                                            currentDivisionIndex -= 1
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                            logedUser.alexandriaData!.localVaults.removeAll()
                            Socket.sharedInstance.updateAlexandriaCloud(username: logedUser.username, alexandriaInfo: AlexandriaDataDec(true))
                        } catch {
                            let alert = UIAlertController(title: "Merge Error", message: "Something went wrong, try going to settings and synchronizing your data again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                            presenterView.present(alert, animated: true)
                        }
                    }))
                    presenterView.present(alert, animated: true)
                })
            } catch {
                let alert = UIAlertController(title: "Merge Error", message: "Something went wrong, try going to settings and synchronizing your data again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                presenterView.present(alert, animated: true)
            }
            
        } else {
            do{
                try realm.write({
                    realm.delete(unloggedUser[0].alexandriaData!)
                    realm.delete(unloggedUser)
                })
            } catch{
                print("error deleting")
            }
            completion()
        }
    }
    
    static func registerNewCloudUser(username: UserData, presenterView: UIViewController) -> CloudUser{
        let logedUser = CloudUser()
        logedUser.name = username.name!
        logedUser.lastname = username.lastName!
        logedUser.username = username.username!
        logedUser.email = username.email!
        logedUser.subscription = username.subscription!
        logedUser.subscriptionStatus = username.subscriptionStatus!
        logedUser.daysLeftOnSubscription.value = username.daysLeftOnSubscription
        logedUser.googleAccountEmail = username.googleAccountEmail!
        for index in 0 ..< (username.teamIDs?.count ?? 0){
            logedUser.teamIDs[index] = username.teamIDs![0]
        }
        
        if username.alexandria != nil {
            logedUser.alexandriaData! ^ username.alexandria!
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandriaData != nil{
                
                if unloggedUser[0].alexandriaData!.goals.count != 0{
                    if logedUser.alexandriaData!.goals.count == 0{
                        logedUser.alexandriaData!.goals = unloggedUser[0].alexandriaData!.goals
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.goals.count{
                            logedUser.alexandriaData?.goals.append((unloggedUser[0].alexandriaData?.goals[goal])!)
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.trophies.count != 0{
                    if logedUser.alexandriaData!.trophies.count == 0{
                        logedUser.alexandriaData!.trophies = unloggedUser[0].alexandriaData!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.trophies.count{
                            logedUser.alexandriaData!.trophies.append(unloggedUser[0].alexandriaData!.trophies[goal])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.localBooks.count != 0{
                    logedUser.alexandriaData!.localBooks = unloggedUser[0].alexandriaData!.localBooks
                }
                if unloggedUser[0].alexandriaData!.localShelves.count != 0{
                    logedUser.alexandriaData!.localShelves = unloggedUser[0].alexandriaData!.localShelves
                }
                if unloggedUser[0].alexandriaData!.cloudBooks.count != 0{
                    if logedUser.alexandriaData!.cloudBooks.count == 0{
                        logedUser.alexandriaData!.cloudBooks = unloggedUser[0].alexandriaData!.cloudBooks
                    }
                }
                if unloggedUser[0].alexandriaData!.shelves.count != 0{
                    if logedUser.alexandriaData!.shelves.count == 0{
                        logedUser.alexandriaData!.shelves = unloggedUser[0].alexandriaData!.shelves
                    }
                }
                if unloggedUser[0].alexandriaData!.localVaults.count != 0{
                    if logedUser.alexandriaData!.localVaults.count == 0{
                        logedUser.alexandriaData!.localVaults = unloggedUser[0].alexandriaData!.localVaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.localVaults.count{
                            logedUser.alexandriaData!.localVaults.append(unloggedUser[0].alexandriaData!.cloudVaults[vault])
                        }
                    }
                }
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
                if unloggedUser.count != 0{
                    realm.delete(unloggedUser[0].alexandriaData!)
                    realm.delete(unloggedUser)
                }
                realm.add(BookToListMap())
            }
        }catch {
            print(error)
        }
        if !logedUser.alexandriaData!.isEmpty() {
            let alert = UIAlertController(title: "Cloud Merge", message: "Would you like to merge all your local data with your account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Don't Merge", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Merge", style: .default, handler: { _ in
                do{
                    try realm.write(){
                        for book in 0..<logedUser.alexandriaData!.cloudBooks.count{
                            logedUser.alexandriaData!.localBooks[book].cloudVar.value = true
                            let hashMap = realm.objects(BookToListMap.self)
                            let shelves = hashMap[0].keys[book].values
                            for shelf in shelves {
                                shelf.value?.books[shelf.indexInShelf.value!] = Double(logedUser.alexandriaData!.cloudBooks.count)
                                hashMap[1].append(key: Double(logedUser.alexandriaData!.cloudBooks.count), value: shelf.value!, isCloud: true)
                            }
                            logedUser.alexandriaData!.cloudBooks.append(logedUser.alexandriaData!.localBooks[book])
                        }
                        logedUser.alexandriaData!.localBooks.removeAll()
                        for shelf in logedUser.alexandriaData!.localShelves{
                            shelf.cloudVar.value = true
                            logedUser.alexandriaData!.shelves.append(shelf)
                        }
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    var shouldCallFunction = true
                    var currentVault = logedUser.alexandriaData!.localVaults[0]
                    var currentVaultMap: VaultMap{
                        get{
                            return logedUser.alexandriaData!.localVaultMaps[Int(currentVault.indexInArray.value!)]
                        }
                    }
                    var isRoot: Bool {
                        get{
                            if logedUser.alexandriaData!.localVaultMaps[Int(currentVault.indexInArray.value!)].parentVault.value != nil{
                                return false
                            } else {
                                return true
                            }
                        }
                    }
                    var outermostIndex = 0
                    var currentVaultParents: [Double] = []
                    var vaultLastCheckedIndices: [Int] = []
                    var vaultChildrenSize = 0
                    var hasCountedChildren = false
                    var currentDivisionIndex = 0
                    var indexDivisionsChecked: [Int] = [0]
                    var newCloudVaults = RealmSwift.List<Vault>()
                    var newCloudVaultMaps = RealmSwift.List<VaultMap>()
                    var vaultRootToDriveList: [Vault] = []
                    
                    while true {
                        if shouldCallFunction{
                            let lists = addCorrespondingVaults(for: currentDivisionIndex, with: newCloudVaults, and: newCloudVaultMaps)
                            newCloudVaults = lists.0
                            newCloudVaultMaps = lists.1
                            shouldCallFunction = false
                            indexDivisionsChecked.append(currentDivisionIndex)
                        } else if outermostIndex > Int(logedUser.alexandriaData!.localVaultDivisionPoints[0]){
                            break
                        } else {
                            if currentVaultMap.localChildVaults.count > 0{
                                if !hasCountedChildren{
                                    vaultChildrenSize = currentVaultMap.localChildVaults.count
                                }
                                if currentVaultMap.localChildVaults.count - vaultChildrenSize != currentVaultMap.localChildVaults.count{
                                    currentVaultParents.append(currentVault.indexInArray.value!)
                                    currentVault = logedUser.alexandriaData!.localVaults[Int(currentVaultMap.localChildVaults[currentVaultMap.localChildVaults.count - vaultChildrenSize])]
                                    if indexDivisionsChecked.endIndex < currentDivisionIndex{
                                        shouldCallFunction = true
                                    }
                                    vaultChildrenSize = vaultChildrenSize - 1
                                    vaultLastCheckedIndices.append(currentVaultMap.localChildVaults.count - vaultChildrenSize)
                                    hasCountedChildren = false
                                    currentDivisionIndex += 1
                                } else {
                                    currentVaultMap.cloudChildVaults.append(objectsIn: currentVaultMap.localChildVaults)
                                    currentVaultMap.localChildVaults.removeAll()
                                    currentVault.notes.append(objectsIn: currentVault.localNotes)
                                    currentVault.localNotes.removeAll()
                                    currentVault.termSets.append(objectsIn: currentVault.localTermSets)
                                    currentVault.localTermSets.removeAll()
                                    do{
                                        try realm.write({
                                            currentVault.cloudVar.value = true
                                            currentVaultMap.parentCloudVar.value = true
                                            if logedUser.alexandriaData!.cloudVaultDivisionPoints.count > currentDivisionIndex{
                                                for index in currentDivisionIndex..<logedUser.alexandriaData!.cloudVaultDivisionPoints.count{
                                                    logedUser.alexandriaData!.cloudVaultDivisionPoints[index] += 1
                                                }
                                            } else {
                                                while logedUser.alexandriaData!.cloudVaultDivisionPoints.count <= currentDivisionIndex{
                                                    logedUser.alexandriaData!.cloudVaultDivisionPoints.append(logedUser.alexandriaData!.cloudVaultDivisionPoints.last ?? 0)
                                                }
                                                logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex] += 1
                                            }
                                            currentVault.indexInArray.value = logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]
                                            for index in Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]) + 1..<logedUser.alexandriaData!.cloudVaults.count{
                                                let thisVault = logedUser.alexandriaData!.cloudVaults[index]
                                                let thisVaultMap = logedUser.alexandriaData!.cloudVaultMaps[index]
                                                thisVault.indexInArray.value! += 1
                                                if thisVaultMap.parentVault.value != nil{
                                                    logedUser.alexandriaData!.cloudVaultMaps[Int(thisVaultMap.parentVault.value!)].cloudChildVaults[Int(thisVaultMap.indexInParent.value!)] += 1
                                                }
                                            }
                                        })
                                        newCloudVaults.insert(currentVault, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                        newCloudVaultMaps.insert(currentVaultMap, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                        vaultRootToDriveList.append(currentVault)
                                        if isRoot {
                                            vaultRootToDriveList = vaultRootToDriveList.sorted(by: { $0.indexInArray.value! < $1.indexInArray.value! })
                                            uploadRootAndChildrenToDrive(from: vaultRootToDriveList, for: newCloudVaults, in: newCloudVaultMaps, and: dispatchGroup)
                                            dispatchGroup.notify(queue: .main, execute: {
                                                outermostIndex += 1
                                                vaultRootToDriveList.removeAll()
                                            })
                                        } else {
                                            let lastParent = currentVaultParents.last!
                                            vaultChildrenSize = vaultLastCheckedIndices.last!
                                            currentVault = logedUser.alexandriaData!.localVaults[Int(lastParent)]
                                            currentVaultParents.removeLast()
                                            vaultLastCheckedIndices.removeLast()
                                        }
                                        hasCountedChildren = true
                                        currentDivisionIndex -= 1
                                    } catch let error {
                                        print(error.localizedDescription)
                                    }
                                }
                            } else {
                                currentVault.notes.append(objectsIn: currentVault.localNotes)
                                currentVault.localNotes.removeAll()
                                currentVault.termSets.append(objectsIn: currentVault.localTermSets)
                                currentVault.localTermSets.removeAll()
                                do{
                                    try realm.write({
                                        currentVault.cloudVar.value = true
                                        currentVaultMap.parentCloudVar.value = true
                                    
                                        if logedUser.alexandriaData!.cloudVaultDivisionPoints.count > currentDivisionIndex{
                                            for index in currentDivisionIndex..<logedUser.alexandriaData!.cloudVaultDivisionPoints.count{
                                                logedUser.alexandriaData!.cloudVaultDivisionPoints[index] += 1
                                            }
                                        } else {
                                            while logedUser.alexandriaData!.cloudVaultDivisionPoints.count <= currentDivisionIndex{
                                                logedUser.alexandriaData!.cloudVaultDivisionPoints.append(logedUser.alexandriaData!.cloudVaultDivisionPoints.last ?? 0)
                                            }
                                            logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex] += 1
                                        }
                                        currentVault.indexInArray.value = logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]
                                        for index in Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]) + 1..<logedUser.alexandriaData!.cloudVaults.count{
                                            let thisVault = logedUser.alexandriaData!.cloudVaults[index]
                                            let thisVaultMap = logedUser.alexandriaData!.cloudVaultMaps[index]
                                            thisVault.indexInArray.value! += 1
                                            if thisVaultMap.parentVault.value != nil{
                                                logedUser.alexandriaData!.cloudVaultMaps[Int(thisVaultMap.parentVault.value!)].cloudChildVaults[Int(thisVaultMap.indexInParent.value!)] += 1
                                            }
                                        }
                                    })
                                    newCloudVaults.insert(currentVault, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                    newCloudVaultMaps.insert(currentVaultMap, at: Int(logedUser.alexandriaData!.cloudVaultDivisionPoints[currentDivisionIndex]))
                                    vaultRootToDriveList.append(currentVault)
                                    if isRoot {
                                        vaultRootToDriveList = vaultRootToDriveList.sorted(by: { $0.indexInArray.value! < $1.indexInArray.value! })
                                        uploadRootAndChildrenToDrive(from: vaultRootToDriveList, for: newCloudVaults, in: newCloudVaultMaps, and: dispatchGroup)
                                        dispatchGroup.notify(queue: .main, execute: {
                                            outermostIndex += 1
                                            vaultRootToDriveList.removeAll()
                                        })
                                    } else {
                                        let lastParent = currentVaultParents.last!
                                        vaultChildrenSize = vaultLastCheckedIndices.last!
                                        currentVault = logedUser.alexandriaData!.localVaults[Int(lastParent)]
                                        currentVaultParents.removeLast()
                                        vaultLastCheckedIndices.removeLast()
                                    }
                                    hasCountedChildren = true
                                    currentDivisionIndex -= 1
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                    logedUser.alexandriaData!.localVaults.removeAll()
                    Socket.sharedInstance.updateAlexandriaCloud(username: logedUser.username, alexandriaInfo: AlexandriaDataDec(true))
                } catch {
                    let alert = UIAlertController(title: "Merge Error", message: "Something went wrong, try going to settings and synchronizing your data again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    presenterView.present(alert, animated: true)
                }
            }))
            presenterView.present(alert, animated: true)
            
        }
        return logedUser
    }
    
    private static func addCorrespondingVaults(for currentDivisionIndex: Int, with startVaultArray: RealmSwift.List<Vault>, and startVaultMapArray: RealmSwift.List<VaultMap>) -> (RealmSwift.List<Vault>, RealmSwift.List<VaultMap>){
        let alexandria = realm.objects(AlexandriaData.self)[0]
        if currentDivisionIndex == 0{
            for index in 0...Int(alexandria.cloudVaultDivisionPoints[currentDivisionIndex]){
                startVaultArray.append(alexandria.cloudVaults[index])
                startVaultMapArray.append(alexandria.cloudVaultMaps[index])
            }
            return (startVaultArray, startVaultMapArray)
        } else {
            for index in Int(alexandria.cloudVaultDivisionPoints[currentDivisionIndex - 1]) + 1...Int(alexandria.cloudVaultDivisionPoints[currentDivisionIndex]){
                startVaultArray.append(alexandria.cloudVaults[index])
                startVaultMapArray.append(alexandria.cloudVaultMaps[index])
            }
            return (startVaultArray, startVaultMapArray)
        }
    }
    
    private static func uploadRootAndChildrenToDrive(from vaultList: [Vault], for newCloudVaultArray: RealmSwift.List<Vault>, in newCloudMapArray: RealmSwift.List<VaultMap>,and dispatchGroup: DispatchGroup){
        dispatchGroup.enter()
        let newDispatchGroup = DispatchGroup()
        var counter = 0
        for vault in vaultList{
            newDispatchGroup.notify(queue: .main, execute: {
                newDispatchGroup.enter()
                if newCloudMapArray[Int(vault.indexInArray.value!)].parentVault.value != nil {
                    GoogleDriveTools.createFolderForClient(parent: newCloudVaultArray[Int(newCloudMapArray[Int(vault.indexInArray.value!)].parentVault.value!)].vaultFolderID!, name: vault.name!){ folderID in
                        do{
                            try realm.write({
                                vault.vaultFolderID = folderID
                            })
                            if vault.notes.count > 0 {
                                for note in vault.notes{
                                    GoogleDriveTools.uploadFileToDrive(name: note.name!, fileURL: URL(fileURLWithPath: note.localAddress!), mimeType: "application/alexandria", parent: vault.vaultFolderID!, service: GoogleDriveTools.service){ (fileID, success) in
                                        if success {
                                            do{
                                                try realm.write({
                                                    note.id = fileID
                                                })
                                                newDispatchGroup.leave()
                                            } catch let error{
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            } else {
                                newDispatchGroup.leave()
                            }
                            counter += 1
                            if counter == vaultList.count{
                                dispatchGroup.leave()
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    GoogleDriveTools.createFolderForClient(parent: "root", name: vault.name!){ folderID in
                        do{
                            try realm.write({
                                vault.vaultFolderID = folderID
                            })
                            newDispatchGroup.leave()
                            counter += 1
                            if counter == vaultList.count{
                                dispatchGroup.leave()
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            })
        }
    }
    
}
