//
//  EditorToolTogglePreferenceCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolTogglePreferenceCollectionViewCell: UICollectionViewCell {
	static var identifier = "editorToolTogglePreferenceCollectionViewCell"
	var controller: EditingViewController!
	var chosen: Bool{
		get{
			return shadowSelectedView.alpha != 0
		}
	}
	
	@IBOutlet weak var shadowSelectedView: UIView!
	@IBOutlet weak var toggleImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	@IBAction func togglePressed(_ sender: Any) {
	}
	
}
