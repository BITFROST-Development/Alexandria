//
//  AddFileDone.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/16/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddFileDone: UITableViewCell {

    static var identifier = "addFileDone"
    static var controller: AddNewFileViewController!
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
        AddFileDone.controller.tableOriginalLoad = false
        if UIDevice.current.orientation.isLandscape{
            AddFileDone.controller.tableView.reloadData()
        } else {
            AddFileDone.controller.tableView.reloadData()
        }
    }
    
    @IBAction func saveFile(_ sender: Any) {
        AddFileDone.controller.createFile()
    }
    
}
