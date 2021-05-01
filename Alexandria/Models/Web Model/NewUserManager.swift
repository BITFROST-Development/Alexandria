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
        for id in username.teamIDs ?? []{
            logedUser.teamIDs.append(ListWrapperForString(id))
        }
        
        if username.alexandria != nil {
            logedUser.alexandria! ^ username.alexandria!
            AlexandriaData.copyDefaults(lhs: logedUser.alexandria!, rhs: username.alexandria!)
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandria != nil{
                logedUser.alexandria!.localGoals = unloggedUser[0].alexandria!.localGoals
                if unloggedUser[0].alexandria!.trophies.count != 0{
                    if logedUser.alexandria!.trophies.count == 0{
                        logedUser.alexandria!.trophies = unloggedUser[0].alexandria!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandria!.trophies.count{
                            logedUser.alexandria!.trophies.append(unloggedUser[0].alexandria!.trophies[goal])
                        }
                    }
                }
                logedUser.alexandria!.localBooks = unloggedUser[0].alexandria!.localBooks
                logedUser.alexandria!.localFolders = unloggedUser[0].alexandria!.localFolders
                logedUser.alexandria!.localNotebooks = unloggedUser[0].alexandria!.localNotebooks
                logedUser.alexandria!.localTermSets = unloggedUser[0].alexandria!.localTermSets
                logedUser.alexandria!.localCollections = unloggedUser[0].alexandria!.localCollections
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
            }
        }catch {
            print(error)
        }
        if !unloggedUser[0].alexandria!.isEmpty() {
            do{
                try realm.write({
                    realm.delete(unloggedUser[0].alexandria!)
                    realm.delete(unloggedUser)
                    let alert = UIAlertController(title: "Cloud Merge", message: "Would you like to merge all your local data with your account?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Don't Merge", style: .default, handler: { _ in
                        completion()
                    }))
                    alert.addAction(UIAlertAction(title: "Merge", style: .cancel, handler: { _ in
                        do{
                            try realm.write(){
                                for book in logedUser.alexandria!.localBooks{
                                    GoogleDriveTools.uploadFileToDrive(name: book.name ?? "", fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(book.localAddress!), thumbnail: nil, mimeType: "application/alexandria", parent: logedUser.alexandria!.filesFolderID!, service: GoogleDriveTools.service, completion: {(newDriveID, success) in
                                        if success{
                                            logedUser.alexandria!.cloudBooks.append(book)
                                            book.cloudVar.value = true
                                            book.driveID = newDriveID
                                            if let firstIndex = logedUser.alexandria!.localBooks.firstIndex(of: book){
                                                logedUser.alexandria!.localBooks.remove(at: firstIndex)
                                            }
                                        }
                                    })
                                }
                                for notebook in logedUser.alexandria!.localNotebooks{
                                    logedUser.alexandria!.cloudNotebooks.append(notebook)
                                    notebook.cloudVar.value = true
                                    GoogleDriveTools.uploadFileToDrive(name: notebook.name ?? "", fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(notebook.localAddress!), thumbnail: UIImage(named: "alexandriaFileImageSmall")!, mimeType: "application/alexandria", parent: logedUser.alexandria!.filesFolderID!, service: GoogleDriveTools.service, completion: {(newDriveID, success) in
                                        if success{
                                            logedUser.alexandria!.cloudNotebooks.append(notebook)
                                            notebook.cloudVar.value = true
                                            notebook.driveID = newDriveID
                                            if let firstIndex = logedUser.alexandria!.localNotebooks.firstIndex(of: notebook){
                                                logedUser.alexandria!.localNotebooks.remove(at: firstIndex)
                                            }
                                        }
                                    })
                                }
                                logedUser.alexandria!.localNotebooks.removeAll()
                                for set in logedUser.alexandria!.localTermSets{
                                    logedUser.alexandria!.cloudTermSets.append(set)
                                    set.cloudVar.value = true
                                }
                                logedUser.alexandria!.localTermSets.removeAll()
                                for collection in logedUser.alexandria!.localCollections{
                                    logedUser.alexandria!.cloudCollections.append(collection)
                                    collection.cloudVar.value = true
                                }
                                logedUser.alexandria!.localCollections.removeAll()
                                for folder in logedUser.alexandria!.localFolders{
                                    logedUser.alexandria!.cloudFolders.append(folder)
                                    folder.cloudVar.value = true
                                }
                                logedUser.alexandria!.localFolders.removeAll()
                            }
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
                    realm.delete(unloggedUser[0].alexandria!)
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
        for id in username.teamIDs ?? []{
            logedUser.teamIDs.append(ListWrapperForString(id))
        }
        
        if username.alexandria != nil {
            logedUser.alexandria! ^ username.alexandria!
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandria != nil{
                AlexandriaData.instantiateDefaults(lhs: logedUser.alexandria!, rhs: unloggedUser[0].alexandria!)
                logedUser.alexandria!.localGoals = unloggedUser[0].alexandria!.localGoals
                if unloggedUser[0].alexandria!.trophies.count != 0{
                    if logedUser.alexandria!.trophies.count == 0{
                        logedUser.alexandria!.trophies = unloggedUser[0].alexandria!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandria!.trophies.count{
                            logedUser.alexandria!.trophies.append(unloggedUser[0].alexandria!.trophies[goal])
                        }
                    }
                }
                logedUser.alexandria!.localBooks = unloggedUser[0].alexandria!.localBooks
                logedUser.alexandria!.localFolders = unloggedUser[0].alexandria!.localFolders
                logedUser.alexandria!.localNotebooks = unloggedUser[0].alexandria!.localNotebooks
                logedUser.alexandria!.localTermSets = unloggedUser[0].alexandria!.localTermSets
                logedUser.alexandria!.localCollections = unloggedUser[0].alexandria!.localCollections
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
                if unloggedUser.count != 0{
                    realm.delete(unloggedUser[0].alexandria!)
                    realm.delete(unloggedUser)
                }
            }
            Socket.sharedInstance.updateAlexandriaCloud(username: logedUser.username, alexandriaInfo: AlexandriaDataDec(true))
        }catch {
            print(error)
        }
        if !logedUser.alexandria!.isEmpty() {
            let alert = UIAlertController(title: "Cloud Merge", message: "Would you like to merge all your local data with your account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Don't Merge", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Merge", style: .default, handler: { _ in
                do{
                    try realm.write(){
                        for book in logedUser.alexandria!.localBooks{
                            GoogleDriveTools.uploadFileToDrive(name: book.name ?? "", fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(book.localAddress!), thumbnail: nil, mimeType: "application/alexandria", parent: logedUser.alexandria!.filesFolderID!, service: GoogleDriveTools.service, completion: {(newDriveID, success) in
                                if success{
                                    logedUser.alexandria!.cloudBooks.append(book)
                                    book.cloudVar.value = true
                                    book.driveID = newDriveID
                                    if let firstIndex = logedUser.alexandria!.localBooks.firstIndex(of: book){
                                        logedUser.alexandria!.localBooks.remove(at: firstIndex)
                                    }
                                }
                            })
                        }
                        for notebook in logedUser.alexandria!.localNotebooks{
                            logedUser.alexandria!.cloudNotebooks.append(notebook)
                            notebook.cloudVar.value = true
                            GoogleDriveTools.uploadFileToDrive(name: notebook.name ?? "", fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(notebook.localAddress!), thumbnail: UIImage(named: "alexandriaFileImageSmall")!, mimeType: "application/alexandria", parent: logedUser.alexandria!.filesFolderID!, service: GoogleDriveTools.service, completion: {(newDriveID, success) in
                                if success{
                                    logedUser.alexandria!.cloudNotebooks.append(notebook)
                                    notebook.cloudVar.value = true
                                    notebook.driveID = newDriveID
                                    if let firstIndex = logedUser.alexandria!.localNotebooks.firstIndex(of: notebook){
                                        logedUser.alexandria!.localNotebooks.remove(at: firstIndex)
                                    }
                                }
                            })
                        }
                        logedUser.alexandria!.localNotebooks.removeAll()
                        for set in logedUser.alexandria!.localTermSets{
                            logedUser.alexandria!.cloudTermSets.append(set)
                            set.cloudVar.value = true
                        }
                        logedUser.alexandria!.localTermSets.removeAll()
                        for collection in logedUser.alexandria!.localCollections{
                            logedUser.alexandria!.cloudCollections.append(collection)
                            collection.cloudVar.value = true
                        }
                        logedUser.alexandria!.localCollections.removeAll()
                        for folder in logedUser.alexandria!.localFolders{
                            logedUser.alexandria!.cloudFolders.append(folder)
                            folder.cloudVar.value = true
                        }
                        logedUser.alexandria!.localFolders.removeAll()
                    }
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
    
}
