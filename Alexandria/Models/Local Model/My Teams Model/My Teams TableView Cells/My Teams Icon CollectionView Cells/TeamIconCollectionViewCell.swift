//
//  TeamIconCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class TeamIconCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "teamIconCollectionViewCell";
    
    var controller: TeamDisplayableDelegate!
    var currentTeam: Team!
    
    @IBOutlet weak var teamPicture: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamPicture.layer.cornerRadius = 30
        notificationView.layer.cornerRadius = 10
    }
    
    @IBAction func selectTeam(_ sender: Any) {
        
    }
    
}
