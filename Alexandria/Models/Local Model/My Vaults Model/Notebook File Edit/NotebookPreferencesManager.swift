////
////  NewNotebokManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 9/8/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import PDFKit
//import ZIPFoundation
//
//extension NotebookPreferencesViewController{
//    func saveNotebook(){
//        if finalFileName != nil{
//            
//            updateLocalNotebook(){ success in
//                if !success {
//                    if self.fileShouldBeMoved{
//                        print()
//                    } else {
//                        print()
//                    }
//                }
//                
//                do{
//                    try AppDelegate.realm.write({
//                        self.currentNotebook.name = self.finalFileName
//                        self.currentNotebook.coverStyle = self.selectedCoverName
//                        self.currentNotebook.sheetDefaultColor = self.displayedPaperColor
//                        self.currentNotebook.sheetDefaultStyle = self.selectedPaperName
//                    })
//                    self.updateCloudNotebook(){ successess in
//                        if successess{
//                            if self.loggedIn {
//                                Socket.sharedInstance.updateAlexandriaCloud(username: AppDelegate.realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                                self.dismiss(animated: true, completion: nil)
//                            } else {
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                        } else {
//                            
//                        }
//                    }
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//            
//        }
//    }
//    
//    func updateLocalNotebook(completion: @escaping(Bool) -> Void){
//        if fileShouldBeMoved{
//            if currentNotebook.localAddress != nil {
//                let addressPrefix = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//                let newLocalAddress = URL(fileURLWithPath: addressPrefix + currentNotebook.localAddress!).deletingLastPathComponent().appendingPathComponent(finalFileName)
//                do{
//                    try FileManager.default.moveItem(at: URL(fileURLWithPath: addressPrefix + currentNotebook.localAddress!), to: newLocalAddress)
//                    completion(true)
//                } catch let error {
//                    print(error.localizedDescription)
//                    let alert = UIAlertController(title: "Couldn't Rename File!", message: "The file could not be renamed, try again later!", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                        completion(false)
//                    }))
//                    self.present(alert, animated: true)
//                }
//            } else {
//                GoogleDriveTools.retrieveFileData(id: currentNotebook.driveID!, mimeType: "application/alexandria", service: GoogleDriveTools.service, completion: { data in
//                    if data != nil{
//                        let newLocalStore = self.parentVault.localAddress! + "/\(self.finalFileName!)"
//                        let newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + newLocalStore
//                        do{
//                            try FileManager.default.createDirectory(atPath: newURL, withIntermediateDirectories: true, attributes: nil)
//                            try data?.write(to: URL(fileURLWithPath: newURL))
//                            completion(true)
//                        } catch let error{
//                            print(error.localizedDescription)
//                            let alert = UIAlertController(title: "Couldn't Download File!", message: "The file could not be downloaded because it was deleted from your Google Drive account or because you are currently not connected to the internet.", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                                completion(false)
//                            }))
//                            self.present(alert, animated: true)
//                        }
//                    } else {
//                        let alert = UIAlertController(title: "Couldn't Download File!", message: "The file could not be downloaded because it was deleted from your Google Drive account or because you are currently not connected to the internet.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                            completion(false)
//                        }))
//                        self.present(alert, animated: true)
//                    }
//                })
//            }
//        } else {
//            if currentNotebook.localAddress != nil{
//                if toDrive {
//                    completion(true)
//                } else {
//                    let alert = UIAlertController(title: "Deletion Alert!", message: "This file will be deleted.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Delete File", style: .destructive, handler: { _ in
//                        if self.currentNotebook.driveID != nil{
//                            GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: self.currentNotebook.driveID!, local: false, completion: {success in
//                                if success{
//                                    if self.currentNotebook.localAddress != nil{
//                                        do{
//                                            try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                                            try! AppDelegate.realm.write({
//                                                self.parentVault.notes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                                AppDelegate.realm.delete(self.currentNotebook)
//                                            })
//                                            completion(true)
//                                        } catch let error {
//                                            print(error.localizedDescription)
//                                        }
//                                    } else {
//                                        try! AppDelegate.realm.write({
//                                            self.parentVault.notes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                            AppDelegate.realm.delete(self.currentNotebook)
//                                        })
//                                        completion(true)
//                                    }
//                                }
//                            })
//                        } else {
//                            do{
//                                try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                                try! AppDelegate.realm.write({
//                                    self.parentVault.localNotes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                    AppDelegate.realm.delete(self.currentNotebook)
//                                })
//                                completion(true)
//                            } catch let error {
//                                print(error.localizedDescription)
//                                completion(false)
//                            }
//                        }
//                    }))
//                    
//                    if loggedIn{
//                        alert.message = "This file will be deleted if you don't back it but to your cloud storage first!"
//                        alert.addAction(UIAlertAction(title: "Save to Drive", style: .cancel, handler: {_ in
//                            self.toDrive = true
//                            completion(true)
//                        }))
//                        alert.addAction(UIAlertAction(title: "Keep Local File", style: .default, handler: { _ in
//                            let addressPrefix = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//                            let newLocalAddress = URL(fileURLWithPath: addressPrefix + self.currentNotebook.localAddress!).deletingLastPathComponent().appendingPathComponent(self.finalFileName)
//                            do{
//                                try FileManager.default.moveItem(at: URL(fileURLWithPath: addressPrefix + self.currentNotebook.localAddress!), to: newLocalAddress)
//                                do{
//                                    try AppDelegate.realm.write({
//                                        self.currentNotebook.localAddress = self.parentVault.localAddress! + self.finalFileName!
//                                        completion(true)
//                                    })
//                                }catch let error{
//                                    print(error.localizedDescription)
//                                }
//                            } catch let error {
//                                print(error.localizedDescription)
//                                let alert = UIAlertController(title: "Couldn't Rename File!", message: "The file could not be renamed, try again later!", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                                    completion(false)
//                                }))
//                                self.present(alert, animated: true)
//                            }
//                        }))
//                    } else {
//                        alert.addAction(UIAlertAction(title: "Keep File", style: .cancel, handler: { _ in
//                            let addressPrefix = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//                            let newLocalAddress = URL(fileURLWithPath: addressPrefix + self.currentNotebook.localAddress!).deletingLastPathComponent().appendingPathComponent(self.finalFileName)
//                            do{
//                                try FileManager.default.moveItem(at: URL(fileURLWithPath: addressPrefix + self.currentNotebook.localAddress!), to: newLocalAddress)
//                                do{
//                                    try AppDelegate.realm.write({
//                                        self.currentNotebook.localAddress = self.parentVault.localAddress! + self.finalFileName!
//                                        completion(true)
//                                    })
//                                }catch let error{
//                                    print(error.localizedDescription)
//                                }
//                            } catch let error {
//                                print(error.localizedDescription)
//                                let alert = UIAlertController(title: "Couldn't Rename File!", message: "The file could not be renamed, try again later!", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                                    completion(false)
//                                }))
//                                self.present(alert, animated: true)
//                            }
//                        }))
//                    }
//                    
//                }
//            } else {
//                completion(true)
//            }
//        }
//    }
//    
//    func updateCloudNotebook(completion: @escaping(Bool) -> Void){
//        if toDrive{
//            if currentNotebook.driveID == nil{
//                parentCloudCheck(checkingVault: parentVault, checkingVaultMap: parentVaultMap, completion: {
//                    GoogleDriveTools.uploadFileToDrive(name: self.finalFileName!, fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!), mimeType: "application/alexandria", parent: self.parentVault.vaultFolderID!, service: GoogleDriveTools.service, completion: { (id, success) in
//                        if success{
//                            if !self.fileShouldBeMoved{
//                                do{
//                                    try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                                    do{
//                                        try AppDelegate.realm.write{
//                                            self.currentNotebook.id = id
//                                            self.currentNotebook.cloudVar.value = true
//                                            self.currentNotebook.localAddress = nil
//                                        }
//                                        completion(true)
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                        completion(false)
//                                    }
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                }
//                            } else {
//                                do{
//                                    try AppDelegate.realm.write{
//                                        self.currentNotebook.id = id
//                                        self.currentNotebook.cloudVar.value = true
//                                        self.parentVault.localNotes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                        self.parentVault.notes.append(self.currentNotebook)
//                                    }
//                                    completion(true)
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                    completion(false)
//                                }
//                            }
//                        } else {
//                            let alert = UIAlertController(title: "Couldn't Upload File!", message: "The file could not be uploaded because it was deleted from your local storage or because you are currently not connected to the internet.", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                                completion(false)
//                            }))
//                            self.present(alert, animated: true)
//                        }
//                    })
//                })
//            } else {
//                GoogleDriveTools.updateFile(name: finalFileName!, id: currentNotebook.id!, fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(currentNotebook.localAddress!), mimeType: "application/alexandria", parent: parentVault.vaultFolderID!, service: GoogleDriveTools.service, completion: { (id, success) in
//                    if success{
//                        if !self.fileShouldBeMoved{
//                            do{
//                                try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                                do{
//                                    try AppDelegate.realm.write{
//                                        self.currentNotebook.id = id
//                                        self.currentNotebook.localAddress = nil
//                                    }
//                                    completion(true)
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                    completion(false)
//                                }
//                            } catch let error {
//                                print(error.localizedDescription)
//                            }
//                        } else {
//                            do{
//                                try AppDelegate.realm.write{
//                                    self.currentNotebook.id = id
//                                }
//                                completion(true)
//                            } catch let error {
//                                print(error.localizedDescription)
//                                completion(false)
//                            }
//                        }
//                        
//                    } else {
//                        let alert = UIAlertController(title: "Couldn't Upload File!", message: "The file could not be uploaded because it was deleted from your local storage or because you are currently not connected to the internet.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: {_ in
//                            completion(false)
//                        }))
//                        self.present(alert, animated: true)
//                    }
//                })
//            }
//        } else {
//            if currentNotebook != nil && currentNotebook.driveID != nil{
//                GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: self.currentNotebook.driveID!, local: false, completion: {success in
//                    if success{
//                        do{
//                            try AppDelegate.realm.write({
//                                self.currentNotebook.driveID = nil
//                                self.currentNotebook.cloudVar.value = false
//                                self.parentVault.notes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                self.parentVault.localNotes.append(self.currentNotebook)
//                            })
//                            completion(true)
//                        } catch let error{
//                            print(error.localizedDescription)
//                        }
//                    }
//                })
//            } else {
//                completion(true)
//            }
//        }
//    }
//    
//    func parentCloudCheck(checkingVault: Vault, checkingVaultMap: VaultMap, completion: @escaping() -> Void){
//        if parentVault.cloudVar.value ?? false{
//            completion()
//        } else {
////            parentCloudCheck(checkingVault: <#T##Vault#>, checkingVaultMap: <#T##VaultMap#>, completion: {
////                GoogleDriveTools.createFolderForClient(parent: <#T##String#>, name: checkingVault.name!, completion: {folderID in
////                    do{
////                        try AppDelegate.realm.write({
////                            checkingVault.vaultFolderID = folderID
////                            checkingVault.cloudVar.value = true
////                            self.alexandria.localVaults.remove(at: Int(checkingVault.indexInArray.value!))
////                            self.alexandria.localVaultMaps.remove(at: Int(checkingVault.indexInArray.value!))
////                            var parentCount = 0
////                            for index in 0..<self.alexandria.localVaultDivisionPoints.count{
////                                if self.alexandria.localVaultDivisionPoints[index] > checkingVault.indexInArray.value!{
////                                    do{
////                                        try AppDelegate.realm.write({
////                                            self.alexandria.localVaultDivisionPoints[index] -= 1
////                                        })
////                                    } catch let error {
////                                        print(error.localizedDescription)
////                                    }
////                                } else {
////                                    parentCount += 1
////                                }
////                            }
////                            
////                            if parentCount < self.alexandria.cloudVaultDivisionPoints.count{
////                                let indexOfInsertion = Int(self.alexandria.cloudVaultDivisionPoints[parentCount])
////                                
////                            } else {
////                                
////                            }
////                        })
////                    } catch let error {
////                        print(error.localizedDescription)
////                    }
////                })
////            })
//        }
//    }
//    
//    func deleteNotebook(completion: @escaping(Bool) -> Void){
//        if self.currentNotebook.driveID != nil{
//            GoogleDriveTools.deleteFile(service: GoogleDriveTools.service, id: self.currentNotebook.driveID!, local: false, completion: {success in
//                if success{
//                    if self.currentNotebook.localAddress != nil{
//                        do{
//                            try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                            try! AppDelegate.realm.write({
//                                self.parentVault.notes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                                AppDelegate.realm.delete(self.currentNotebook)
//                            })
//                        } catch let error {
//                            print(error.localizedDescription)
//                        }
//                    } else {
//                        try! AppDelegate.realm.write({
//                            self.parentVault.notes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                            AppDelegate.realm.delete(self.currentNotebook)
//                        })
//                    }
//                }
//            })
//        } else {
//            do{
//                try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.currentNotebook.localAddress!))
//                try! AppDelegate.realm.write({
//                    self.parentVault.localNotes.remove(at: Int(self.currentNotebook.indexInParent.value!))
//                    AppDelegate.realm.delete(self.currentNotebook)
//                })
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toCoverPicker"{
//            let destination = segue.destination as! CoverPickerViewController
//            destination.controller = self
//            destination.selectedGroup = displayedCoverStyle
//            destination.selectedCellImage = (Int(selectedCoverName[selectedCoverName.index(before: selectedCoverName.endIndex)..<selectedCoverName.endIndex]) ?? 1) - 1
//        } else {
//            let destination = segue.destination as! PaperStylePickerViewController
//            destination.controller = self
//            destination.selectedGroup = displayedPaperStyle
//            destination.selectedCellImage = (Int(selectedPaperName[selectedPaperName.index(before: selectedPaperName.endIndex)..<selectedPaperName.endIndex]) ?? 1) - 1
//            destination.selectedColor = displayedPaperColor
//            destination.selectedOrientation = displayedOrientation
//        }
//    }
//}
