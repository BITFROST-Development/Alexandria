//
//  MyProfileLogoutCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/23/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class MyProfileLogoutCell: UITableViewCell {
    
    var presentingView: MyProfileViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func logout(_ sender: Any) {
        presentingView!.logoutPressed()
    }
    
}
