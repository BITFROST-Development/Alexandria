//
//  NewNotebokManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/8/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension NewNotebookViewController{
    func saveNotebook(){
        if finalFileName != nil{
            currentNotbook.coverStyle = selectedCoverName
            currentNotbook.sheetStyleGroup.append(displayedPaperStyle)
            currentNotbook.sheetIndexInGroup.append((Double(selectedPaperName[selectedPaperName.index(before: selectedPaperName.endIndex)..<selectedPaperName.endIndex]) ?? 1) - 1)
            currentNotbook.name = finalFileName
            currentNotbook.lastUpdated = Date()
            let newNotbook = PDFDocument()
            let pageDoc = PDFDocument(data: NSDataAsset(name: selectedPaperName + "/\(displayedOrientation ?? "")/\(displayedPaperColor ?? "")pdf")!.data)
            let startingPage = pageDoc!.page(at: 0)!
            newNotbook.insert(startingPage, at: 0)
            if toDrive{
                GoogleDriveTools.uploadNotebook(name: currentNotbook.name! + ".alexandria", fileData: newNotbook.dataRepresentation()!, thumbnail: UIImage(named: selectedCoverName)!, mimeType: "application/notebook.alexandria", parent: parentVault.vaultFolderID!, service: GoogleDriveTools.service){(fileID, success) in
                    if success {
                        self.currentNotbook.cloudVar.value = true
                        self.currentNotbook.id = fileID
                        if self.fileShouldBeMoved{
                            let vaultAddress = URL(fileURLWithPath: self.parentVault.localAddress!, isDirectory: true)
                            if !FileManager.default.fileExists(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"){
                                FileManager.default.createFile(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria", contents: newNotbook.dataRepresentation()!, attributes: nil)
                                do{
                                    try AppDelegate.realm.write({
                                        self.currentNotbook.localAddress = vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"
                                        self.parentVault.notes.append(self.currentNotbook)
                                    })
                                    self.controller.fileDisplayCollection.reloadData()
                                    self.dismiss(animated: true, completion: nil)
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            } else {
                                let alert = UIAlertController(title: "Error Creating Notebook", message: "There is an existing notebook with the same name, you must change the name of this file or replace the existing one.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Rename File", style: .cancel, handler: nil))
                                alert.addAction(UIAlertAction(title: "Replace Existing File", style: .destructive, handler: { _ in
                                    do{
                                        try FileManager.default.removeItem(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria")
                                        FileManager.default.createFile(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria", contents: newNotbook.dataRepresentation()!, attributes: nil)
                                        do{
                                            try AppDelegate.realm.write({
                                                self.currentNotbook.localAddress = vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"
                                                self.parentVault.notes.append(self.currentNotbook)
                                            })
                                            Socket.sharedInstance.updateAlexandriaCloud(username: AppDelegate.realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
                                            self.controller.fileDisplayCollection.reloadData()
                                            self.dismiss(animated: true, completion: nil)
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    } catch let error {
                                        print(error.localizedDescription)
                                    }
                                }))
                                self.present(alert, animated: true)
                            }
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "Error Creating Notebook", message: "There was a problem uploading your file to the cloud, please check your internet connection and try again or uncheck the store in cloud Checkbox.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } else{
                if self.fileShouldBeMoved{
                    let vaultAddress = URL(fileURLWithPath: self.parentVault.localAddress!, isDirectory: true)
                    if !FileManager.default.fileExists(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"){
                        FileManager.default.createFile(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria", contents: newNotbook.dataRepresentation()!, attributes: nil)
                        do{
                            try AppDelegate.realm.write({
                                self.currentNotbook.localAddress = vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"
                                self.parentVault.localNotes.append(self.currentNotbook)
                            })
                            self.controller.fileDisplayCollection.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error Creating Notebook", message: "There is an existing notebook with the same name, you must change the name of this file or replace the existing one.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Rename File", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Replace Existing File", style: .destructive, handler: { _ in
                            do{
                                try FileManager.default.removeItem(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria")
                                FileManager.default.createFile(atPath: vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria", contents: newNotbook.dataRepresentation()!, attributes: nil)
                                do{
                                    try AppDelegate.realm.write({
                                        self.currentNotbook.localAddress = vaultAddress.path + "/" + self.currentNotbook.name! + ".alexandria"
                                        self.parentVault.notes.append(self.currentNotbook)
                                    })
                                    self.dismiss(animated: true, completion: nil)
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }))
                        self.controller.fileDisplayCollection.reloadData()
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "No Title!", message: "You need to give your notebook a title!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCoverPicker"{
            let destination = segue.destination as! CoverPickerViewController
            destination.controller = self
            destination.selectedGroup = displayedCoverStyle
            destination.selectedCellImage = (Int(selectedCoverName[selectedCoverName.index(before: selectedCoverName.endIndex)..<selectedCoverName.endIndex]) ?? 1) - 1
        } else {
            let destination = segue.destination as! PaperStylePickerViewController
            destination.controller = self
            destination.selectedGroup = displayedPaperStyle
            destination.selectedCellImage = (Int(selectedPaperName[selectedPaperName.index(before: selectedPaperName.endIndex)..<selectedPaperName.endIndex]) ?? 1) - 1
            destination.selectedColor = displayedPaperColor
            destination.selectedOrientation = displayedOrientation
        }
    }
}
