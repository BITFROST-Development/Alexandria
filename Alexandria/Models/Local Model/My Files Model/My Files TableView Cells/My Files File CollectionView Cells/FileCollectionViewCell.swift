//
//  FileCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/20/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "fileCollectionViewCell"

    var controller: FileDisplayableDelegate!
    var currentFile: DocumentItem!
    
    @IBOutlet weak var fileImage: FileIconImage!
    @IBOutlet weak var fileTitle: UILabel!
    @IBOutlet weak var fileData: UILabel!
    @IBOutlet weak var favoriteIndicator: UIButton!
    @IBOutlet weak var pinnedIndicator: UIButton!
	@IBOutlet weak var thumbnailShadow: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	@IBOutlet weak var shadowWidth: NSLayoutConstraint!
	@IBOutlet weak var shadowHeight: NSLayoutConstraint!
	@IBOutlet weak var favoritesShadow: UIView!
	@IBOutlet weak var pinnedShadow: UIView!
	@IBOutlet weak var imageWidth: NSLayoutConstraint!
	@IBOutlet weak var imageHeight: NSLayoutConstraint!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		favoritesShadow.layer.cornerRadius = 3
		pinnedShadow.layer.cornerRadius = 3
    }

    @IBAction func fileSelected(_ sender: Any) {
		controller.controller.openItem(currentFile)
	}
	
    @IBAction func pinFile(_ sender: Any) {
        
    }
    
	@IBAction func makeFavorite(_ sender: Any) {
    
	}
    
    @IBAction func toFilePreferences(_ sender: Any) {
    
	}
}

class FileIconImage: UIImageView{
	override var intrinsicContentSize: CGSize{
		get{
			if let myImage = self.image {
				let myImageWidth = myImage.size.width
				let myImageHeight = myImage.size.height
				let myViewWidth = self.frame.size.width

				let ratio = myImageHeight/myImageWidth
				let scaledHeight = myViewWidth * ratio
				if scaledHeight > 180{
					return CGSize(width: 180 * (myImageWidth / myImageHeight), height: 180)
				}

				return CGSize(width: myViewWidth, height: scaledHeight)
			}

			return CGSize(width: -1.0, height: -1.0)
		}
	}
}
