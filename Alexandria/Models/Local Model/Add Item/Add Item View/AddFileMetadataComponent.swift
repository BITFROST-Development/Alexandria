//
//  AddFileMetadataComponent.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileMetadataComponent: UITableViewCell {

    static var identifier = "addFileMetadataComponent"
    @IBOutlet weak var metadataName: UILabel!
    @IBOutlet weak var metadataContent: UITextField!
    @IBOutlet weak var cleatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        metadataContent.delegate = self
//        print(self.layer.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clearField(_ sender: Any) {
        metadataContent.text = ""
        metadataContent.layer.frame.origin.x = metadataContent.layer.frame.minX + 13
        cleatButton.alpha = 0.0
    }
    
}

extension AddFileMetadataComponent: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" && textField.text?.count == 1 && string.isEmpty{
            metadataContent.layer.frame.origin.x = metadataContent.layer.frame.minX + 13
            cleatButton.alpha = 0.0
            return true
        } else {
            metadataContent.layer.frame.origin.x = metadataContent.layer.frame.minX - 13
            cleatButton.alpha = 1.0
            return true
        }
    }
}
