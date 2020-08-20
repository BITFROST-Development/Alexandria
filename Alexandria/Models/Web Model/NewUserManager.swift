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
                if unloggedUser[0].alexandriaData!.vaults.count != 0{
                    if logedUser.alexandriaData!.vaults.count == 0{
                        logedUser.alexandriaData!.vaults = unloggedUser[0].alexandriaData!.vaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.vaults.count{
                            logedUser.alexandriaData!.vaults.append(unloggedUser[0].alexandriaData!.vaults[vault])
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
                if unloggedUser[0].alexandriaData!.vaults.count != 0{
                    if logedUser.alexandriaData!.vaults.count == 0{
                        logedUser.alexandriaData!.vaults = unloggedUser[0].alexandriaData!.vaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.vaults.count{
                            logedUser.alexandriaData!.vaults.append(unloggedUser[0].alexandriaData!.vaults[vault])
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
                        logedUser.alexandriaData!.localShelves.removeAll()
                        Socket.sharedInstance.updateAlexandriaCloud(username: logedUser.username, alexandriaInfo: AlexandriaDataDec(true))
                    }
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
    
}
