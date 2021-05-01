//
//  ClassTitleTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/8/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ClassTitleTableViewCell: UITableViewCell {

    static var identifier = "classTitleTableViewCell"
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var goToChevron: UIImageView!
    @IBOutlet weak var goToLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
