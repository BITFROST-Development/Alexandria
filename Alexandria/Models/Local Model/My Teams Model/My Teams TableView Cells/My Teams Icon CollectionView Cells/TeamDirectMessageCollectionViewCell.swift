//
//  TeamDirectMessageCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class TeamDirectMessageCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "teamDirectMessageCollectionViewCell"
    
    var controller: TeamDisplayableDelegate!
    
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circleView.layer.cornerRadius = 30
    }
    
    @IBAction func toDirectMessages(_ sender: Any) {
    }
    
}
