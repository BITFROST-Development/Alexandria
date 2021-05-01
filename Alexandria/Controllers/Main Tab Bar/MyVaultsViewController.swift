////
////  ViewController.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 6/15/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class MyVaultsViewController: AuthenticationSource {
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    var currentVault: Vault?
//    var editingNote: Notebook?
//    var editingSet: TermSet?
//    var editingVault: Vault?
//    var passingIndexInParent: Int?
//    var vaultsToDisplay: [Vault] = []
//    var notesToDisplay: [Notebook] = []
//    var setsToDisplay: [TermSet] = []
//    var displayableObjects: [VaultDisplayable] = []
//    var notebookToOpen: Notebook!
//    var setToOpen: TermSet!
//    var rootLeftNavBar:[UIBarButtonItem]!
//    var rootRightNavBar: [UIBarButtonItem]!
//    var intoLeftNavBar:[UIBarButtonItem]!
//    var intoRightNavBar: [UIBarButtonItem]!
//    var isRoot = true
//    var addItemPresent = false
//    var itemKind = ""
//    @IBOutlet weak var AddItemView: UITableView!
//    @IBOutlet weak var fileDisplayCollection: UICollectionView!
//    @IBOutlet weak var profileButton: UIBarButtonItem!
//    @IBOutlet weak var addButton: UIBarButtonItem!
//    @IBOutlet weak var backButton: UIBarButtonItem!
//    @IBOutlet weak var editVaultButton: UIBarButtonItem!
//    @IBOutlet weak var preferencesButton: UIBarButtonItem!
//    @IBOutlet weak var opacityFilter: UIView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        rootLeftNavBar = [profileButton, addButton]
//        rootRightNavBar = [preferencesButton]
//        intoLeftNavBar = [backButton, profileButton, addButton]
//        intoRightNavBar = [preferencesButton, editVaultButton]
//        navigationItem.leftBarButtonItems = rootLeftNavBar
//        prepareCollectionView()
//        prepareAddItemTableView()
//        opacityFilter.alpha = 0
//        AddItemView.alpha = 0
//        let dismissControll = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        dismissControll.numberOfTapsRequired = 1
//        dismissControll.numberOfTouchesRequired = 1
//        self.view.addGestureRecognizer(dismissControll)
//    }
//    
//    @objc func dismissView(){
//        if addItemPresent{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.opacityFilter.alpha = 0
//                self.AddItemView.alpha = 0
//            }){ _ in
//                self.addItemPresent = false
//            }
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        Socket.sharedInstance.delegate = self
//    }
//    
//}
//
//extension MyVaultsViewController: SocketDelegate{
//    func refreshView() {
//        
//    }
//}
//
