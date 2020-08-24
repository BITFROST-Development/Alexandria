//
//  DefaultColorCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class DefaultColorCell: UICollectionViewCell {
    
    static var identifier = "defaultColorCell"
    
    var controller: ColorPickerViewController!
    var color: DisplayedColor!
    var colorName: String!
    var isSelectedColor = false
    
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        highlightView.alpha = 0
        highlightView.layer.cornerRadius = 10
        colorView.layer.cornerRadius = 10
    }
    
    @IBAction func pickColor(_ sender: Any) {
        if !isSelectedColor{
            highlightView.alpha = 1.0
            controller.currentCell?.deselectColor()
            controller.currentCell = self
            controller.pickedColor = color
            controller.pickedColorName = colorName
            isSelectedColor = true
        }
    }
    
    func deselectColor(){
        highlightView.alpha = 0.0
        isSelectedColor = false
    }
    
}
