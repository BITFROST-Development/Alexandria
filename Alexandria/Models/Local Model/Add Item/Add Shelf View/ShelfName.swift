//
//  ShelfName.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/21/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ShelfName: UITableViewCell {
    
    static var identifier = "shelfName"
    static var controller: UIViewController!
    
    @IBOutlet var shelfName: ShelfNameTitle!
    @IBOutlet var clearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shelfName.delegate = self
        clearButton.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearTitle(_ sender: Any) {
        shelfName.text = ""
        shelfName.becomeFirstResponder()
        clearButton.alpha = 0
    }
    
}

extension ShelfName: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.placeholder = "Shelf Name"
            let field = textField as! ShelfNameTitle
            field.layer.frame.size.width = 160
            field.layer.frame.origin.x = center.x - 50
            clearButton.alpha = 0
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" && textField.text?.count == 1 && string.isEmpty{
            let field = textField as! ShelfNameTitle
            field.layer.frame.size.width = 10
            field.layer.frame.origin.x = center.x - 5
            clearButton.alpha = 0
        } else if textField.text != "" && range.length == textField.text?.count && string.isEmpty{
            let field = textField as! ShelfNameTitle
            field.layer.frame.size.width = 10
            field.layer.frame.origin.x = center.x - 5
            clearButton.alpha = 0
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.clearButton.alpha = 1
            })
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let field = textField as! ShelfNameTitle
        if field.text == "" {
            textField.placeholder = ""
            field.layer.frame.size.width = 10
            field.layer.frame.origin.x = center.x - 5
        }
    }
}

class ShelfNameTitle: UITextField{
    override var intrinsicContentSize: CGSize {
        get{
            var width:CGFloat = 160.0
            if text?.count != 0{
                width = (self.text! as NSString).size(withAttributes: self.typingAttributes).width + 20.0
                if width > ShelfName.controller.view.layer.frame.width - 120 {
                    width = ShelfName.controller.view.layer.frame.width - 120
                }
            }
            return CGSize(width: width, height: 70.0)
        } set {
            
        }
    }
}
