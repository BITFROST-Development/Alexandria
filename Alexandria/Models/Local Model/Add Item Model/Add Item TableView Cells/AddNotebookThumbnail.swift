//
//  AddFileThumbnail.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddNotebookThumbnail: UITableViewCell {

    static var identifier = "addNotebookThumbnail"
    @IBOutlet weak var fileThumbnail: UIImageView!
    @IBOutlet weak var filePaperStyle: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowPaper: UIView!
	@IBOutlet weak var paperContainer: UIView!
	
	var portraitShadowRatio: NSLayoutConstraint!
	var portraitPaperRatio: NSLayoutConstraint!
	var landscapeShadowRatio: NSLayoutConstraint!
	var landscapePaperRatio: NSLayoutConstraint!
	var portraitShadowHeight: NSLayoutConstraint!
	var portraitPaperHeight: NSLayoutConstraint!
	var landscapeShadowHeight: NSLayoutConstraint!
	var landscapePaperHeight: NSLayoutConstraint!
	
    override func awakeFromNib() {
        super.awakeFromNib()
//        print(self.layer.frame.height)
        fileThumbnail.image = fileThumbnail.image?.withRenderingMode(.alwaysTemplate)
        filePaperStyle.image = filePaperStyle.image?.withRenderingMode(.alwaysTemplate)
        shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        shadowView.layer.cornerRadius = 7
		portraitShadowRatio = NSLayoutConstraint(item: shadowPaper!, attribute: .height, relatedBy: .equal, toItem: shadowPaper!, attribute: .width, multiplier: 201.66/156.4, constant: 0)
		portraitPaperRatio = NSLayoutConstraint(item: filePaperStyle!, attribute: .height, relatedBy: .equal, toItem: filePaperStyle!, attribute: .width, multiplier: 200/155.55, constant: 0)
		landscapeShadowRatio = NSLayoutConstraint(item: shadowPaper!, attribute: .height, relatedBy: .equal, toItem: shadowPaper!, attribute: .width, multiplier: 156.4/201.66, constant: 0)
		landscapePaperRatio = NSLayoutConstraint(item: filePaperStyle!, attribute: .height, relatedBy: .equal, toItem: filePaperStyle!, attribute: .width, multiplier: 155.55/200, constant: 0)
		landscapeShadowHeight = NSLayoutConstraint(item: shadowPaper!, attribute: .height, relatedBy: .equal, toItem: shadowPaper, attribute: .height, multiplier: 0, constant: 178.8825)
//			shadowPaper.heightAnchor.constraint(equalToConstant: 178.8825)
		landscapePaperHeight = NSLayoutConstraint(item: filePaperStyle!, attribute: .height, relatedBy: .equal, toItem: filePaperStyle, attribute: .height, multiplier: 0, constant: 179.6668848557)
//		filePaperStyle.heightAnchor.constraint(equalToConstant: 179.6668848557)
		portraitShadowHeight = NSLayoutConstraint(item: shadowPaper!, attribute: .height, relatedBy: .equal, toItem: shadowPaper, attribute: .height, multiplier: 0, constant: 231.66)
//		shadowPaper.heightAnchor.constraint(equalToConstant: 231.66)
		portraitPaperHeight = NSLayoutConstraint(item: filePaperStyle!, attribute: .height, relatedBy: .equal, toItem: filePaperStyle, attribute: .height, multiplier: 0, constant: 230)
//		shadowPaper.heightAnchor.constraint(equalToConstant: 230)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
}
