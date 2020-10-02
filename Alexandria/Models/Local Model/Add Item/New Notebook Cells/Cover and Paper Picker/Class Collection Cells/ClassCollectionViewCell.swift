//
//  ClassCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/8/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "classCollectionViewCell"
    var currentCell: Int!
    var currentGroup: String!
    var controller: NotebookImageStyle!
    @IBOutlet weak var backgroundSelectedView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var paperName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectItem(_ sender: Any) {
        controller.selectedCellImage = currentCell
        controller.selectedGroup = currentGroup
        backgroundSelectedView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 0.7))
        controller.selectedCell?.backgroundSelectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
        controller.selectedCell = self
    }
    
}
