////
////  BookPreferencesManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/31/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//extension BookPreferences{
//    func updateArray(_ newArray: [Shelf]){
//        shelvesToAddress.removeAll()
//        shelvesToAddress = newArray
//    }
//    
//    func updateFile(){
//        let realm = try! Realm(configuration: AppDelegate.realmConfig)
//        let hashMaps = realm.objects(BookToListMap.self)
//        self.updateLocalFile(realm: realm, hashTables: hashMaps){ success in
//            if success{
//                self.updateCloudFile(realm: realm){ successes in
//                    if successes {
//                        self.updateShelves(realm: realm, hashTables: hashMaps){ allSet in
//                            if allSet {
//                                let dispatchGroup = DispatchGroup()
//                                dispatchGroup.enter()
//                                if self.currentBook.name != self.finalFileName{
//                                    if self.currentBook.cloudVar.value ?? false {
//                                        if self.currentBook.localAddress != nil {
//                                            GoogleDriveTools.updateBook(name: self.finalFileName, bookTitle: self.currentBook.name!, id: self.currentBook.driveID!, fileURL: URL(fileURLWithPath: (self.currentBook.localAddress!)), mimeType: "application/alexandria", parent: realm.objects(CloudUser.self)[0].alexandria!.filesFolderID!, service: GoogleDriveTools.service){ successeses in
//                                                if successeses {
//                                                    do {
//                                                        try FileManager.default.moveItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentBook.localAddress!), to: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Books").appendingPathComponent(self.finalFileName!))
//                                                            do {
//                                                                try realm.write({
//                                                                    self.currentBook.localAddress = "Books/\(self.finalFileName!)"
//                                                                    self.currentBook.name = self.finalFileName!
//                                                                    if self.loggedIn {
//                                                                        Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                                                    }
//                                                                })
//                                                                dispatchGroup.leave()
//                                                            } catch let error {
//                                                                print(error.localizedDescription)
//                                                            }
//                                                    } catch let error {
//                                                        print(error.localizedDescription)
//                                                    }
//                                                } else {
//                                                    fatalError()
//                                                }
//                                            }
//                                        } else {
//                                            GoogleDriveTools.updateBook(name: self.finalFileName, bookTitle: self.currentBook.name!, id: self.currentBook.driveID!, fileURL: nil, mimeType: "application/alexandria", parent: realm.objects(CloudUser.self)[0].alexandria!.filesFolderID!, service: GoogleDriveTools.service){ successeses in
//                                                if successes{
//                                                    do {
//                                                        try realm.write({
//                                                            self.currentBook.name = self.finalFileName!
//                                                            if self.loggedIn {
//                                                                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                                            }
//                                                            dispatchGroup.leave()
//                                                        })
//                                                    } catch let error {
//                                                        print(error.localizedDescription)
//                                                    }
//                                                } else {
//                                                    fatalError()
//                                                }
//                                            }
//                                        }
//                                    } else {
//                                        do {
//                                            let booksAddress = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Books")
//                                            let currentBookAddress = booksAddress.appendingPathComponent(self.currentBook.localAddress!.components(separatedBy: "/").last!)
//                                            let newBookAddress = booksAddress.appendingPathComponent(self.finalFileName!)
//                                            try FileManager.default.moveItem(at: currentBookAddress, to: newBookAddress)
//                                                do {
//                                                    try realm.write({
//                                                        self.currentBook.localAddress = "Books/\(self.finalFileName!)"
//                                                        self.currentBook.name = self.finalFileName!
//                                                        if self.loggedIn {
//                                                            Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                                        }
//                                                    })
//                                                    dispatchGroup.leave()
//                                                } catch let error {
//                                                    print(error.localizedDescription)
//                                                }
//                                        } catch let error {
//                                            print(error.localizedDescription)
//                                        }
//                                    }
//                                } else {
//                                    dispatchGroup.leave()
//                                }
//                                dispatchGroup.enter()
//                                if self.currentBook.author != self.author {
//                                    do {
//                                        try realm.write({
//                                            self.currentBook.author = self.author
//                                            if self.loggedIn {
//                                                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                            }
//                                        })
//                                        dispatchGroup.leave()
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                    }
//                                } else {
//                                    dispatchGroup.leave()
//                                }
//                                
//                                dispatchGroup.enter()
//                                if self.currentBook.year != self.year{
//                                    do {
//                                        try realm.write({
//                                            self.currentBook.year = self.year
//                                            if self.loggedIn {
//                                                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                            }
//                                        })
//                                        dispatchGroup.leave()
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                    }
//                                } else {
//                                    dispatchGroup.leave()
//                                }
//                                
//                                dispatchGroup.notify(queue: .main){
//                                    self.dismiss(animated: true, completion: nil)
//                                }
//                            } else {
//                                let alert = UIAlertController(title: "Error saving changes", message: "There was an error saving your shelves, try again later.", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                                self.present(alert, animated: true)
//                            }
//                        }
//                    } else {
//                        let alert = UIAlertController(title: "Error saving changes", message: "There was an error saving your changes to the cloud. Check your internet connection and try again!", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                        self.present(alert, animated: true)
//                    }
//                }
//            } else {
//                let alert = UIAlertController(title: "Error saving changes", message: "There was an error saving your changes locally. Try again later!", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
//    
//    }
//    
//    func updateLocalFile(realm: Realm, hashTables: Results<BookToListMap>, completion: @escaping(Bool) -> Void){
//        if fileShouldBeMoved{
//            if currentBook.localAddress != nil{
//                completion(true)
//            } else {
//                GoogleDriveTools.retrieveBookFromDrive(id: currentBook.driveID!, name: currentBook.name!, service: GoogleDriveTools.service){ success in
//                    if success{
//                        do{
//                            try realm.write({
//                                self.currentBook.localAddress = "/Books/\(self.currentBook.name!)"
//                            })
//                            completion(true)
//                        } catch let error{
//                            print(error.localizedDescription)
//                        }
//                    } else {
//                        self.presentInternetConnectionFailureAlert()
//                    }
//                }
//            }
//        } else {
//            if currentBook.localAddress != nil {
//                let alert = UIAlertController(title: "Local File will be removed", message: "If you continue this file will be removed. Keep a local copy to prevent this.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Keep File", style: .default, handler: {_ in
//                    completion(true)
//                }))
//                if loggedIn{
//                    alert.message = "If you continue this file will be removed. Save it to drive, or keep a local copy to prevent this."
//                    if !(currentBook.cloudVar.value ?? false){
//                        alert.addAction(UIAlertAction(title: "Move to Drive", style: .cancel, handler: { _ in
//                            GoogleDriveTools.uploadBookToDrive(fileName: self.currentBook.name!, bookTitle: self.currentBook.name!,fileURL: URL(fileURLWithPath: self.currentBook.localAddress!, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]), mimeType: "application/alexandria", parent: realm.objects(AlexandriaData.self)[0].filesFolderID!, service: GoogleDriveTools.service){ success in
//                                if (success){
//                                    do {
//                                        try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + self.currentBook.localAddress!)
//                                        do{
//                                            try realm.write({
//                                                self.currentBook.localAddress = nil
//                                            })
//                                        } catch let error {
//                                            print(error.localizedDescription)
//                                            completion(false)
//                                        }
//                                    } catch let error{
//                                        print(error.localizedDescription)
//                                        completion(false)
//                                    }
//                                    
//                                    hashTables[1].append(key: hashTables[0].keys[self.currentBookIndex], in: realm.objects(AlexandriaData.self)[0].cloudBooks.count)
//                                    
//                                    do {
//                                        try realm.write({
//                                            self.currentBook.cloudVar.value = true
//                                            let user = realm.objects(CloudUser.self)[0]
//                                            user.alexandria?.cloudBooks.append(self.currentBook)
//                                            user.alexandria?.localBooks.remove(at: self.currentBookIndex)
//                                            completion(true)
//                                        })
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                        completion(false)
//                                    }
//                                } else {
//                                    let newAlert = UIAlertController(title: "Error Uploading File", message: "There was an error and we could not upload your file correctly, try agian later.", preferredStyle: .alert)
//                                    newAlert.addAction(UIAlertAction(title: "Got it!", style: .cancel, handler: nil))
//                                    self.present(newAlert, animated: true)
//                                    completion(false)
//                                }
//                            }
//                        }))
//                    }
//                }
//                
//                alert.addAction(UIAlertAction(title: "Remove File", style: .destructive, handler: {_ in
//                    do {
//                        if !self.loggedIn{
//                            self.deleteFile()
//                            completion(true)
//                        } else {
//                            try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + self.currentBook.localAddress!)
//                            do{
//                                try realm.write({
//                                    self.currentBook.localAddress = nil
//                                })
//                                completion(true)
//                            } catch let error {
//                                print(error.localizedDescription)
//                            }
//                            completion(true)
//                        }
//                    } catch let error{
//                        print(error.localizedDescription)
//                        completion(false)
//                    }
//                }))
//                self.present(alert, animated: true)
//                
//            } else {
//                completion(true)
//            }
//        }
//    }
//    
//    func presentInternetConnectionFailureAlert(){
//        let alert = UIAlertController(title: "Error Downloading File", message: "There was an error downloading your file from Drive. Try checking your internet connection.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//        present(alert, animated: true)
//    }
//    
//    func updateCloudFile(realm: Realm, completion: @escaping(Bool) -> Void){
//        if loggedIn{
//            if toDrive{
//                if currentBook.cloudVar.value ?? false {
//                    completion(true)
//                } else {
//                    GoogleDriveTools.uploadBookToDrive(fileName: "\(currentBook.name!)", bookTitle: "\(currentBook.name!)" ,fileURL: URL(fileURLWithPath: currentBook.localAddress!, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]), mimeType: "application/alexandria", parent: realm.objects(AlexandriaData.self)[0].filesFolderID!, service: GoogleDriveTools.service){ success in
//                        let hashTables = realm.objects(BookToListMap.self)
//                        hashTables[1].append(key: hashTables[0].keys[self.currentBookIndex], in: realm.objects(AlexandriaData.self)[0].cloudBooks.count)
//                        
//                        do {
//                            try realm.write({
//                                self.currentBook.cloudVar.value = true
//                                let user = realm.objects(CloudUser.self)[0]
//                                user.alexandria?.cloudBooks.append(self.currentBook)
//                                user.alexandria?.localBooks.remove(at: self.currentBookIndex)
//                                completion(true)
//                            })
//                        } catch let error {
//                            print(error.localizedDescription)
//                            completion(false)
//                        }
//                    }
//                }
//            } else {
//                if currentBook.cloudVar.value ?? false {
//                    let alert = UIAlertController(title: "Cloud File will be removed!", message: "If you continue you will only be able to access this file from this device.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Keep in Cloud", style: .default, handler: nil))
//                    if currentBook.localAddress == nil {
//                        alert.message = "If you continue this file will be deleted from all devices. Make a local copy or keep the cloud file to prevent this."
//                        alert.addAction(UIAlertAction(title: "Local Copy", style: .cancel, handler: { _ in
//                            GoogleDriveTools.retrieveBookFromDrive(id: self.currentBook.driveID!, name: self.currentBook.name!, service: GoogleDriveTools.service){ success in
//                                if success{
//                                    GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: self.currentBook.driveID!, local: false)
//                                    let hashTables = realm.objects(BookToListMap.self)
//                                    hashTables[0].append(key: hashTables[1].keys[self.currentBookIndex], in: realm.objects(AlexandriaData.self)[0].localBooks.count)
//                                    do {
//                                        try realm.write({
//                                            self.currentBook.localAddress = "/Books/\(self.currentBook.name!)"
//                                            self.currentBook.cloudVar.value = false
//                                            let user = realm.objects(CloudUser.self)[0]
//                                            user.alexandria?.localBooks.append(self.currentBook)
//                                            user.alexandria?.cloudBooks.remove(at: self.currentBookIndex)
//                                            completion(true)
//                                        })
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                        completion(false)
//                                    }
//                                } else {
//                                    completion(false)
//                                }
//                            }
//                        }))
//                    }
//                    alert.addAction(UIAlertAction(title: "Delete Cloud File", style: .destructive, handler: { _ in
//                        self.deleteFile()
//                        completion(true)
//                    }))
//                } else {
//                    completion(true)
//                }
//            }
//        } else {
//            completion(true)
//        }
//    }
//    
//    func updateShelves(realm: Realm, hashTables: Results<BookToListMap>, completion: @escaping(Bool) -> Void){
//        if currentBook.cloudVar.value ?? false {
//            let newShelves = List<BookToListValue>()
//            for index in 0..<shelvesToAddress.count {
//                if shelvesToAddress[index].cloudVar.value ?? false {
//                    if currentBookIndex > Int(shelvesToAddress[index].books[shelvesToAddress[index].books.endIndex]) || shelvesToAddress[index].books.count == 0{
//                        shelvesToAddress[index].books.append(Double(currentBookIndex))
//                    } else {
//                        let newArray = List<Double>()
//                        for kindex in 0..<shelvesToAddress[index].books.count {
//                            if shelvesToAddress[index].books[kindex] > Double(currentBookIndex){
//                                newArray.append(Double(currentBookIndex))
//                            }
//                            newArray.append(shelvesToAddress[index].books[kindex])
//                        }
//                        do {
//                            try realm.write({
//                                shelvesToAddress[index].books.removeAll()
//                                shelvesToAddress[index].books = newArray
//                            })
//                        } catch let error {
//                            print(error.localizedDescription)
//                            completion(false)
//                        }
//                    }
//                } else {
//                    if currentBookIndex > Int(shelvesToAddress[index].oppositeBooks[shelvesToAddress[index].oppositeBooks.endIndex]) || shelvesToAddress[index].oppositeBooks.count == 0{
//                        shelvesToAddress[index].oppositeBooks.append(Double(currentBookIndex))
//                    } else {
//                        let newArray = List<Double>()
//                        for kindex in 0..<shelvesToAddress[index].oppositeBooks.count {
//                            if shelvesToAddress[index].oppositeBooks[kindex] > Double(currentBookIndex){
//                                newArray.append(Double(currentBookIndex))
//                            }
//                            newArray.append(shelvesToAddress[index].oppositeBooks[kindex])
//                        }
//                        do {
//                            try realm.write({
//                                shelvesToAddress[index].oppositeBooks.removeAll()
//                                shelvesToAddress[index].oppositeBooks = newArray
//                            })
//                        } catch let error {
//                            print(error.localizedDescription)
//                            completion(false)
//                        }
//                    }
//                }
//                newShelves.append(BookToListValue(shelvesToAddress[index], Double(currentBookIndex), currentBook.cloudVar.value!))
//            }
//            do {
//                if currentBookIndex < hashTables[1].keys.count {
//                    try realm.write({
//                        realm.delete(hashTables[1].keys[currentBookIndex].values)
//                        hashTables[1].keys[currentBookIndex].values = newShelves
//                    })
//                }
//                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                completion(true)
//            } catch let error {
//                print(error.localizedDescription)
//                completion(false)
//            }
//        } else {
//            let newShelves = List<BookToListValue>()
//            for index in 0..<shelvesToAddress.count {
//                newShelves.append(BookToListValue(shelvesToAddress[index], Double(currentBookIndex), currentBook.cloudVar.value!))
//            }
//            do {
//                try realm.write({
//                    realm.delete(hashTables[0].keys[currentBookIndex].values)
//                    hashTables[0].keys[currentBookIndex].values = newShelves
//                })
//                completion(true)
//            } catch let error {
//                print(error.localizedDescription)
//                completion(false)
//            }
//        }
//    }
//    
//    func deleteFile(){
//        let realm = try! Realm(configuration: AppDelegate.realmConfig)
//        if currentBook.localAddress != nil {
//            do{
//                try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(currentBook.localAddress!).path)
//                if currentBook.cloudVar.value ?? false {
//                    GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: currentBook.driveID!, local: false){ success in
//                        let hashTables = realm.objects(BookToListMap.self)
//                        hashTables[1].removeObject(in: self.currentBookIndex)
//                        do{
//                            try realm.write({
//                                let alexandria = realm.objects(AlexandriaData.self)[0]
//                                alexandria.cloudBooks.remove(at: self.currentBookIndex)
//                                realm.delete(self.currentBook)
//                            })
//                        } catch let error {
//                            print(error.localizedDescription)
//                            
//                        }
//                    }
//                } else {
//                    let hashTables = realm.objects(BookToListMap.self)
//                    hashTables[0].removeObject(in: currentBookIndex)
//                    do{
//                        try realm.write({
//                            let alexandria = realm.objects(AlexandriaData.self)[0]
//                            alexandria.localBooks.remove(at: currentBookIndex)
//                            realm.delete(currentBook)
//                        })
//                    } catch let error {
//                        print(error.localizedDescription)
//                    }
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        } else {
//            GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: currentBook.driveID!, local: false)
//            let hashTables = realm.objects(BookToListMap.self)
//            hashTables[1].removeObject(in: currentBookIndex)
//            do{
//                try realm.write({
//                    let alexandria = realm.objects(AlexandriaData.self)[0]
//                    alexandria.cloudBooks.remove(at: currentBookIndex)
//                    realm.delete(currentBook)
//                })
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "shelfPicker" {
//            let picker = segue.destination as! ShelfListViewController
//            picker.updateController = self
//            picker.selectedShelves = shelvesToAddress
//        }
//    }
//}
