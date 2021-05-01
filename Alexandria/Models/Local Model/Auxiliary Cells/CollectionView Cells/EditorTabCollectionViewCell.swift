//
//  EditorTabCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/17/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorTabCollectionViewCell: UICollectionViewCell {

	static var identifier = "editorTabCollectionViewCell"
	
	var controller: EditingViewController!
	var index: Int!
	
	@IBOutlet weak var tabName: UILabel!
	@IBOutlet weak var closeImage: UIImageView!
	@IBOutlet weak var selectedView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectedView.layer.cornerRadius = 5
		selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

	@IBAction func closeFile(_ sender: Any) {
		controller.closeTabAt(index: index)
	}
	
	@IBAction func tabSelected(_ sender: Any) {
		controller.changeTabTo(index: index)
	}
	
}
