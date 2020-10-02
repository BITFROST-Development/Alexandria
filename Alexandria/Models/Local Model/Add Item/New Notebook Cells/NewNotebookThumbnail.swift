//
//  AddFileThumbnail.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class NewNotebookThumbnail: UITableViewCell {

    static var identifier = "newNotebookThumbnail"
    @IBOutlet weak var fileThumbnail: FileThumbnail!
    @IBOutlet weak var filePaperStyle: FileThumbnail!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paperHeight: NSLayoutConstraint!
    @IBOutlet weak var paperWidth: NSLayoutConstraint!
    @IBOutlet weak var shadowPaper: UIView!
    @IBOutlet weak var heightShadow: NSLayoutConstraint!
    @IBOutlet weak var widthShadow: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print(self.layer.frame.height)
        fileThumbnail.image = fileThumbnail.image?.withRenderingMode(.alwaysTemplate)
        filePaperStyle.image = filePaperStyle.image?.withRenderingMode(.alwaysTemplate)
        shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        shadowView.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
}
