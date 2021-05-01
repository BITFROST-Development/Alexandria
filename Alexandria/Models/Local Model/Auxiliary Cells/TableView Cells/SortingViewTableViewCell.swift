//
//  SortingViewTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/23/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class SortingViewTableViewCell: UITableViewCell {

    static var identifier = "sortingViewTableViewCell"
    
    var controller: SortingDelegate!
    var currentSortKind: String!
    
    @IBOutlet weak var sortingKindLabel: UILabel!
    @IBOutlet weak var selectedMarker: UIImageView!
    @IBOutlet weak var sortIcon: UIImageView!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
