//
//  EditorToolPickerPreferenceCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolPickerPreferenceCollectionViewCell: UICollectionViewCell {
	
	static var identifier = "editorToolPickerPreferenceCollectionViewCell"
	
	var controller: EditingViewController!
	var pickerKind: String!
	
	
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var pickerIcon: UIImageView!
	@IBOutlet weak var pickerImage: UIImageView!
	@IBOutlet weak var fontWidth: NSLayoutConstraint!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		fontWidth.isActive = false
    }

	@IBAction func pickerPressed(_ sender: Any) {
		
	}
	
}
