////
////  EditingFilePickerManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 9/25/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class FilePickerSectionTitle: UICollectionReusableView {
//    
//    var controller: EditingFilePickerViewController!
//    
//    @IBOutlet weak var sectionTitle: UILabel!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
//    
//    @IBAction func goBack(_ sender: Any) {
//        if controller.sourceKind == "Book"{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.controller.pickerCollection.layer.frame.origin.x = self.controller.view.layer.frame.size.width
//            }){ _ in
//                self.controller.pickerCollection.layer.frame.origin.x = 0 - self.controller.view.layer.frame.size.width
//                self.controller.sourceKind = "Shelf"
//                self.controller.currentShelf = nil
//                self.controller.pickerCollection.reloadData()
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.controller.pickerCollection.layer.frame.origin.x = 0
//                })
//            }
//        } else {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.controller.pickerCollection.layer.frame.origin.x = self.controller.view.layer.frame.size.width
//            }){ _ in
//                self.controller.pickerCollection.layer.frame.origin.x = 0 - self.controller.view.layer.frame.size.width
//                if self.controller.parentVault != nil{
//                    self.controller.currentVault = self.controller.parentVault.last
//                    if self.controller.parentVault.count > 0{
//                        self.controller.parentVault.removeLast()
//                    }
//                } else {
//                    self.controller.currentVault = nil
//                }
//                self.controller.displayingVaultItems.removeAll()
//                self.controller.pickerCollection.reloadData()
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.controller.pickerCollection.layer.frame.origin.x = 0
//                })
//            }
//        }
//    }
//    
//}
