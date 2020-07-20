//
//  AddFileCheckBoxes.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileCheckBoxes: UITableViewCell {

    static var identifier = "addFileCheckBoxes"
    var isChecked = false
    var controller: AddNewFileViewController!
    var loggedIn = true
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var checkCircle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(self.layer.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        if loggedIn {
            if !isChecked {
                UIView.animate(withDuration: 0.1, animations: {
                    self.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
                })
                UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.checkCircle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                }, completion: nil)
                isChecked = true
                if optionName.text == "Store in Google Drive"{
                    controller.toDrive = true
                } else {
                    controller.fileShouldBeMoved = true
                }
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.checkCircle.tintColor = .lightGray
                })
                UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
                }, completion: nil)
                isChecked = false
                if optionName.text == "Store in Google Drive"{
                    controller.toDrive = false
                } else {
                    controller.fileShouldBeMoved = false
                }
            }
        }
    }
}
