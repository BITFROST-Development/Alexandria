//
//  IconlessItemsTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/28/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddIconlessThumbnailTableViewCell: UITableViewCell {
    
    static var identifier = "addIconlessThumbnailTableViewCell"
    static var controller: AddItemViewController!
    @IBOutlet weak var fileTitle: FileTitle!
    @IBOutlet weak var clearButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        fileTitle.sizeToFit()
        fileTitle.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearTitle(_ sender: Any) {
        fileTitle.text = ""
        fileTitle.becomeFirstResponder()
        clearButton.alpha = 0
    }
    
}

extension AddIconlessThumbnailTableViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.placeholder = "Title"
            let field = textField as! FileTitle
            field.layer.frame.size.width = 100
            field.layer.frame.origin.x = center.x - 50
            clearButton.alpha = 0
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" && textField.text?.count == 1 && string.isEmpty{
            let field = textField as! FileTitle
            field.layer.frame.size.width = 10
            field.layer.frame.origin.x = center.x - 5
            clearButton.alpha = 0
        } else {
            clearButton.alpha = 1
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != nil {
            AddIconlessThumbnailTableViewCell.controller.finalName = textField.text!
        } else {
            AddIconlessThumbnailTableViewCell.controller.finalName = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let field = textField as! FileTitle
        if field.text == "" {
            textField.placeholder = ""
            field.layer.frame.size.width = 10
            field.layer.frame.origin.x = center.x - 5
        }
		let neededVisibleSpace = AddIconlessThumbnailTableViewCell.controller.displayingView.convert(AddIconlessThumbnailTableViewCell.controller.displayingView.rectForRow(at: AddIconlessThumbnailTableViewCell.controller.displayingView.indexPath(for: self)!), to: AddIconlessThumbnailTableViewCell.controller.displayingView.superview).origin
//		neededVisibleSpace.y += 175
		AddIconlessThumbnailTableViewCell.controller.keysShouldNotCover(neededVisibleSpace)
    }
}
