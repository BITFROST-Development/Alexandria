////
////  AddFileDone.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/16/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class NotebookEditDone: UITableViewCell {
//
//    static var identifier = "notebookEditDone"
//    static var controller: NotebookPreferencesViewController!
//    @IBOutlet weak var saveFileButton: UIButton!
//    @IBOutlet weak var deleteFileButton: UIButton!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        saveFileButton.layer.cornerRadius = 5
//        deleteFileButton.layer.cornerRadius = 5
//        NotificationCenter.default.addObserver(self, selector: #selector(finishedRotating), name: UIDevice.orientationDidChangeNotification, object: nil)
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(false, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    @objc func finishedRotating() {
//        if UIDevice.current.orientation.isLandscape{
//            NotebookEditDone.controller.tableView.reloadData()
//        } else {
//            NotebookEditDone.controller.tableView.reloadData()
//        }
//    }
//    
//    @IBAction func saveFile(_ sender: Any) {
//        NotebookEditDone.controller.saveNotebook()
//    }
//    
//    @IBAction func deleteFile(_ sender: Any){
//        NotebookEditDone.controller.deleteNotebook(){success in
//            if success{
//                if NotebookEditDone.controller.loggedIn{
//                    Socket.sharedInstance.updateAlexandriaCloud(username: AppDelegate.realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                }
//                NotebookEditDone.controller.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//    
//}
