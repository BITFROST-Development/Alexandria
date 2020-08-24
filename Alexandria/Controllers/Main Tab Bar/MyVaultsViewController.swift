//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class MyVaultsViewController: AuthenticationSource {
    
    var parentFolderTitle = ""
    var parentVaults: [Vault]?
    var currentVault: Vault?
    var vaultsToDisplay: [Vault] = []
    var notesToDisplay: [Note] = []
    var setsToDisplay: [TermSet] = []
    var displayableObjects: [VaultDisplayable] = []
    var rootNavBar:[UIBarButtonItem]!
    var intoNavBar:[UIBarButtonItem]!
    var isRoot = true
    var itemKind = ""
    @IBOutlet weak var AddItemView: UITableView!
    @IBOutlet weak var fileDisplayCollection: UICollectionView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rootNavBar = [profileButton, addButton]
        intoNavBar = [backButton, profileButton, addButton]
        navigationItem.leftBarButtonItems = rootNavBar
        prepareCollectionView()
        prepareAddItemTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
}

extension MyVaultsViewController: SocketDelegate{
    func refreshView() {
        
    }
}

