//
//  EditorToolButtonPreferenceCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolButtonPreferenceCollectionViewCell: UICollectionViewCell {
	static var identifier = "editorToolButtonPreferenceCollectionViewCell"
	
	var controller: EditingViewController!
	var kind: String!
	
	@IBOutlet weak var optionButton: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	@IBAction func optionPressed(_ sender: Any) {
		
	}
}
