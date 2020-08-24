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
                            currentVault.birthName = finalFileName
                            currentVault.name = finalFileName
                            currentVault.parentFolderID = parentFolderID
                            currentVault.vaultPathComponents = parentVault?.vaultPathComponents ?? currentVault.vaultPathComponents
                            currentVault.vaultPathComponents.append(finalFileName)
                        })
                        if toDrive {
                            var parentToDrive: String!
                            if parentFolderID == ""{
                                parentToDrive = "root"
                            } else {
                                parentToDrive = parentFolderID
                            }
                            GoogleDriveTools.createFolderForClient(parent: parentToDrive, name: finalFileName){ folderID in
                                do {
                                    try realm.write({
                                        self.currentVault.vaultFolderID = folderID
                                    })
                                    if self.fileShouldBeMoved {
                                        var pathToFollow = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                                        for component in self.currentVault.vaultPathComponents{
                                            pathToFollow?.appendPathComponent(component)
                                            if !FileManager.default.fileExists(atPath: pathToFollow!.path){
                                                do{
                                                    try FileManager.default.createDirectory(at: pathToFollow!, withIntermediateDirectories: true, attributes: nil)
                                                } catch let error {
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                        do{
                                            try realm.write({
                                                self.currentVault.localAddress = pathToFollow?.path
                                            })
                                        } catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else if currentSet != nil{
                
            }
        } else {
            let alert = UIAlertController(title: "Error Creating File", message: "You must provide a title to your file!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
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
