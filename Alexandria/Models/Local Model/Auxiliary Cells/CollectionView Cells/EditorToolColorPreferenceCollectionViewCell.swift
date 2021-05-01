//
//  EditorToolColorPreferenceCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolColorPreferenceCollectionViewCell: UICollectionViewCell {
	static var identifier = "editorToolColorPreferenceCollectionViewCell"
	var controller: EditingViewController!
	var chosen: Bool{
		get{
			return shadowSelectedView.alpha != 0 && moreColorsView.alpha != 0
		}
	}
	@IBOutlet weak var shadowSelectedView: UIView!
	@IBOutlet weak var colorView: UIView!
	@IBOutlet weak var moreColorsView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		shadowSelectedView.alpha = 0
		moreColorsView.alpha = 0
		colorView.layer.cornerRadius = colorView.frame.height / 2
		shadowSelectedView.layer.cornerRadius = shadowSelectedView.frame.height / 2
    }
	
	@IBAction func colorPressed(_ sender: Any) {
		
	}
	

}
