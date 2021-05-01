//
//  AddFileDone.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/16/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemDone: UITableViewCell {

    static var identifier = "addItemDone"
    static var controller: AddItemViewController!
    @IBOutlet weak var saveFileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        saveFileButton.layer.cornerRadius = 5
        NotificationCenter.default.addObserver(self, selector: #selector(finishedRotating), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func finishedRotating() {
        AddItemDone.controller.tableOriginalLoad = false
        if UIDevice.current.orientation.isLandscape{
            AddItemDone.controller.displayingView.reloadData()
        } else {
            AddItemDone.controller.displayingView.reloadData()
        }
    }
    
    @IBAction func saveFile(_ sender: Any) {
        AddItemDone.controller.donePressed()
    }
    
}
