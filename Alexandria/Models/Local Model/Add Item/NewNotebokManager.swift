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
//extension NewNotebookViewController{
//    func saveNotebook(){
//        if finalFileName != nil{
//            currentNotebook.coverStyle = selectedCoverName
//            currentNotebook.sheetStyleGroup.append(displayedPaperStyle)
//            currentNotebook.sheetIndexInStyleGroup.append((Double(selectedPaperName[selectedPaperName.index(before: selectedPaperName.endIndex)..<selectedPaperName.endIndex]) ?? 1) - 1)
//            currentNotebook.name = finalFileName
//            currentNotebook.lastModified = Date()
//            currentNotebook.sheetDefaultColor = displayedPaperColor
//            currentNotebook.sheetDefaultStyle = selectedPaperName
//            currentNotebook.sheetDefaultOrientation = displayedOrientation
//            let newNotbook = PDFDocument()
//            let pageDoc = PDFDocument(data: NSDataAsset(name: selectedPaperName + "/\(displayedOrientation ?? "")/\(displayedPaperColor ?? "")pdf")!.data)
//            let startingPage = pageDoc!.page(at: 0)!
//            newNotbook.insert(startingPage, at: 0)
//            do{
//                if self.fileShouldBeMoved{
//                    let vaultAddress = URL(fileURLWithPath: self.parentVault.localAddress!, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
//                    var pathCheck = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    for component in parentVault.pathVaults{
//                        pathCheck.appendPathComponent(component)
//                        if !FileManager.default.fileExists(atPath: pathCheck.path){
//                            do{
//                                try FileManager.default.createDirectory(at: pathCheck, withIntermediateDirectories: true, attributes: nil)
//                            } catch let error {
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
//                    if !FileManager.default.fileExists(atPath: vaultAddress.path + "/" + self.currentNotebook.name!){
//                        let newFileCreatorAddress = vaultAddress.appendingPathComponent(finalFileName)
//                        try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
//                        let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
//                        try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: newNotbook.dataRepresentation(), attributes: nil)
//                        FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("top").path, contents: nil, attributes: nil)
//                        let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
//                        try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
//                        do{
//                            try AppDelegate.realm.write({
//                                self.currentNotebook.localAddress = parentVault.localAddress! + "/" + self.currentNotebook.name!
//                            })
//                            self.controller.fileDisplayCollection.reloadData()
//                            if toDrive{
//                                GoogleDriveTools.uploadNotebook(name: currentNotebook.name!, fileData: newFileCreatorAddress, thumbnail: UIImage(named: selectedCoverName)!, mimeType: "application/alexandria", parent: parentVault.vaultFolderID!, service: GoogleDriveTools.service){(fileID, success) in
//                                    if success {
//                                        do{
//                                            try AppDelegate.realm.write({
//                                                self.currentNotebook.cloudVar.value = true
//                                                self.currentNotebook.id = fileID
//                                                self.currentNotebook.indexInParent.value = Double(self.parentVault.notes.count)
//                                                self.parentVault.notes.append(self.currentNotebook)
//                                            })
//                                        } catch let error {
//                                            print(error.localizedDescription)
//                                        }
//                                    }else {
//                                        let alert = UIAlertController(title: "Error Creating Notebook", message: "There was a problem uploading your file to the cloud, please check your internet connection and try again or uncheck the store in cloud Checkbox.", preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                                        self.present(alert, animated: true)
//                                    }
//                                }
//                            } else {
//                                do{
//                                    try AppDelegate.realm.write({
//                                        self.currentNotebook.indexInParent.value = Double(self.parentVault.localNotes.count)
//                                        self.parentVault.localNotes.append(self.currentNotebook)
//                                    })
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                }
//                            }
//                            self.dismiss(animated: true, completion: nil)
//                        } catch let error {
//                            print(error.localizedDescription)
//                        }
//                    } else {
//                        let alert = UIAlertController(title: "Error Creating Notebook", message: "There is an existing notebook with the same name, you must change the name of this file or replace the existing one.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Rename File", style: .cancel, handler: nil))
//                        alert.addAction(UIAlertAction(title: "Replace Existing File", style: .destructive, handler: { _ in
//                            do{
//                                try FileManager.default.removeItem(atPath: vaultAddress.path + "/" + self.currentNotebook.name!)
//                                let newFileCreatorAddress = vaultAddress.appendingPathComponent(self.finalFileName)
//                                try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
//                                let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
//                                try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
//                                FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: newNotbook.dataRepresentation(), attributes: nil)
//                                FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("top").path, contents: nil, attributes: nil)
//                                let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
//                                try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
//                                FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
//                                FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
//                                FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
//                                FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
//                                FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
//                                do{
//                                    try AppDelegate.realm.write({
//                                        self.currentNotebook.localAddress = self.parentVault.localAddress! + "/" + self.currentNotebook.name!
//                                    })
//                                    self.controller.fileDisplayCollection.reloadData()
//                                    if self.toDrive{
//                                        GoogleDriveTools.uploadNotebook(name: self.currentNotebook.name!, fileData: newFileCreatorAddress, thumbnail: UIImage(named: self.selectedCoverName)!, mimeType: "application/alexandria", parent: self.parentVault.vaultFolderID!, service: GoogleDriveTools.service){(fileID, success) in
//                                            if success {
//                                                do{
//                                                    try AppDelegate.realm.write({
//                                                        self.currentNotebook.cloudVar.value = true
//                                                        self.currentNotebook.id = fileID
//                                                        self.currentNotebook.indexInParent.value = Double(self.parentVault.notes.count)
//                                                        self.parentVault.notes.append(self.currentNotebook)
//                                                    })
//                                                    try FileManager.default.removeItem(at: newFileCreatorAddress)
//                                                } catch let error {
//                                                    print(error.localizedDescription)
//                                                }
//                                            }else {
//                                                let alert = UIAlertController(title: "Error Creating Notebook", message: "There was a problem uploading your file to the cloud, please check your internet connection and try again or uncheck the store in cloud Checkbox.", preferredStyle: .alert)
//                                                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                                                self.present(alert, animated: true)
//                                            }
//                                        }
//                                    } else {
//                                        do{
//                                            try AppDelegate.realm.write({
//                                                self.currentNotebook.indexInParent.value = Double(self.parentVault.localNotes.count)
//                                                self.parentVault.localNotes.append(self.currentNotebook)
//                                            })
//                                        } catch let error {
//                                            print(error.localizedDescription)
//                                        }
//                                    }
//                                    self.dismiss(animated: true, completion: nil)
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                }
//                            } catch let error {
//                                print(error.localizedDescription)
//                            }
//                        }))
//                        self.controller.fileDisplayCollection.reloadData()
//                        self.present(alert, animated: true)
//                    }
//                } else {
//                    var hiddenFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    hiddenFolder.appendPathComponent("fileCreator")
//                    if !FileManager.default.fileExists(atPath: hiddenFolder.path){
//                        do{
//                            try FileManager.default.createDirectory(at: hiddenFolder, withIntermediateDirectories: true, attributes: nil)
//                        } catch let error{
//                            print(error.localizedDescription)
//                        }
//                    }
//                    do{
//                        let newFileCreatorAddress = hiddenFolder.appendingPathComponent(finalFileName)
//                        try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
//                        let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
//                        try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: newNotbook.dataRepresentation(), attributes: nil)
//                        FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("top").path, contents: nil, attributes: nil)
//                        let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
//                        try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
//                        GoogleDriveTools.uploadNotebook(name: currentNotebook.name!, fileData: newFileCreatorAddress, thumbnail: UIImage(named: selectedCoverName)!, mimeType: "application/alexandria", parent: parentVault.vaultFolderID!, service: GoogleDriveTools.service){(fileID, success) in
//                            if success {
//                                do{
//                                    try AppDelegate.realm.write({
//                                        self.currentNotebook.cloudVar.value = true
//                                        self.currentNotebook.id = fileID
//                                        self.currentNotebook.indexInParent.value = Double(self.parentVault.notes.count)
//                                        self.parentVault.notes.append(self.currentNotebook)
//                                    })
//                                    try FileManager.default.removeItem(at: newFileCreatorAddress)
//                                } catch let error {
//                                    print(error.localizedDescription)
//                                }
//                            } else {
//                                let alert = UIAlertController(title: "Error Creating Notebook", message: "There was a problem uploading your file to the cloud, please check your internet connection and try again or uncheck the store in cloud Checkbox.", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                                self.present(alert, animated: true)
//                            }
//                        }
//                    } catch let error {
//                        print(error.localizedDescription)
//                    }
//                    
//                }
//            } catch let error{
//                print(error.localizedDescription)
//            }
//        } else {
//            let alert = UIAlertController(title: "No Title!", message: "You need to give your notebook a title!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//            present(alert, animated: true)
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
