//
//  MyVaultsCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/20/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyVaultsCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "myVaultsCollectionViewCell"
    
    var controller: MyVaultsViewController!
    var kind: String!
    var currentVault: Vault!
    @IBOutlet weak var vaultIcon: UIImageView!
    @IBOutlet weak var vaultTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func goTo(_ sender: Any) {
        if kind == "vault" {
            controller.navigateToVault(currentVault, towards: "left")
        } else if kind == "note" {
            
        } else if kind == "set" {
            
        }
    }
    
    @IBAction func itemPreferences(_ sender: Any) {
        
    }
    
}
