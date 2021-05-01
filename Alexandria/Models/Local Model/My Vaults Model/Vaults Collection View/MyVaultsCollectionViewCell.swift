////
////  MyVaultsCollectionViewCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/20/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class MyVaultsCollectionViewCell: UICollectionViewCell {
//    
//    static var identifier = "myVaultsCollectionViewCell"
//    
//    var controller: MyVaultsViewController!
//    var kind: String!
//    var currentVault: Vault!
//    var indexInVault: Int!
//    @IBOutlet weak var vaultIcon: VaultIconView!
//    @IBOutlet weak var vaultTitle: UILabel!
//    @IBOutlet weak var iconShadow: UIView!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        vaultIcon.controller = self
//        // Initialization code
//        iconShadow.layer.cornerRadius = 6
//        iconShadow.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
//    }
//    
//    @IBAction func goTo(_ sender: Any) {
//        if kind == "vault" {
//            controller.navigateToVault(currentVault, towards: "right")
//        } else if kind == "note" {
//            controller.itemKind = "note"
//            controller.notebookToOpen = controller.displayableObjects[indexInVault] as? Notebook
//            controller.performSegue(withIdentifier: "toEditingView", sender: controller)
//        } else if kind == "set" {
//            controller.itemKind = "set"
//            controller.setToOpen = controller.displayableObjects[indexInVault] as? TermSet
//            controller.performSegue(withIdentifier: "toEditingView", sender: controller)
//        }
//    }
//    
//    @IBAction func itemPreferences(_ sender: Any) {
//        if kind == "note"{
//            controller.editingNote = controller.displayableObjects[indexInVault] as? Notebook
//        }
//    }
//    
//}
//
//class VaultIconView: UIImageView{
//    var controller: MyVaultsCollectionViewCell!
//    override var intrinsicContentSize: CGSize{
//        get{
//            if controller.kind == "vault" || controller.kind == "set"{
//                return CGSize(width: 50, height: 100)
//            }
//            return super.intrinsicContentSize
//        }
//    }
//}
