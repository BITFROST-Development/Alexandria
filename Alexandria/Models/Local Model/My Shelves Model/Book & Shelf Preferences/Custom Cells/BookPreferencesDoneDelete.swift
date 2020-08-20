//
//  BookPreferencesDoneDelete.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/31/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class BookPreferencesDoneDelete: UITableViewCell {
    
    static var identifier = "bookPreferencesDoneDelete"
    static var controller: BookPreferences!

    @IBOutlet weak var saveFileButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        saveFileButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
        NotificationCenter.default.addObserver(self, selector: #selector(finishedRotating), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func finishedRotating(){
        BookPreferencesDoneDelete.controller.tableOriginalLoad = false
        BookPreferencesDoneDelete.controller.tableView.reloadData()
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        BookPreferencesDoneDelete.controller.updateFile()
    }
    
    @IBAction func deleteFile(_ sender: Any) {
        BookPreferencesDoneDelete.controller.deleteFile()
    }
    
}
