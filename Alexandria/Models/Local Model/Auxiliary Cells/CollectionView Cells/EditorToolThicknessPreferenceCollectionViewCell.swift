//
//  EditorToolThicknessPreferenceCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolThicknessPreferenceCollectionViewCell: UICollectionViewCell {
	static var identifier = "editorToolThicknessPreferenceCollectionViewCell"
	
	var controller: EditingViewController!
	var chosen: Bool{
		get{
			return shadowSelected.alpha != 0
		}
	}
	
	@IBOutlet weak var shadowSelected: UIView!
	@IBOutlet weak var thicknessView: UIView!
	@IBOutlet weak var thickness: NSLayoutConstraint!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		shadowSelected.alpha = 0
		shadowSelected.layer.cornerRadius = 5
		thicknessView.layer.cornerRadius = thicknessView.frame.height / 5
    }
	
	@IBAction func thicknessPressed(_ sender: Any) {
		
	}
	
}
