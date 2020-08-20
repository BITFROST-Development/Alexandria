//
//  AddFileViewTitle.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileViewTitle: UITableViewCell {
    
    static var identifier = "addFileViewTitle"
    static var controller: BookChangerDelegate!
    @IBOutlet weak var fileTitle: FileTitle!
    @IBOutlet weak var clearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fileTitle.sizeToFit()
        fileTitle.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clearTitle(_ sender: Any) {
        fileTitle.text = ""
        fileTitle.becomeFirstResponder()
        clearButton.alpha = 0
    }
    
}

extension AddFileViewTitle: UITextFieldDelegate{
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
            AddFileViewTitle.controller.finalFileName = textField.text!
            print(AddFileViewTitle.controller.finalFileName)
        } else {
            AddFileViewTitle.controller.finalFileName = ""
            print(AddFileViewTitle.controller.finalFileName)
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
    }
}

class FileTitle: UITextField {
    override var intrinsicContentSize: CGSize {
        get{
            var width:CGFloat = 80.0
            if text?.count != 0{
                width = (self.text! as NSString).size(withAttributes: self.typingAttributes).width + 8.0
                if width > AddFileViewTitle.controller.view.layer.frame.width - 120 {
                    width = AddFileViewTitle.controller.view.layer.frame.width - 120
                }
            }
            return CGSize(width: width, height: 40.0)
        } set {
            
        }
    }
}
