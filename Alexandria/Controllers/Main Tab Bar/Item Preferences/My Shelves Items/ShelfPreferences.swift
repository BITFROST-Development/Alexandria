//
//  ShelfPreferences.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/17/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class ShelfPreferences: UIViewController, ShelfChangerDelegate {
    
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var currentShelf: Shelf!
    var controller: MyShelvesViewController!
    var titleCell: ShelfName!
    var booksCell: ShelfBookCollection!
    var cloudBooksToCell: [Double]!
    var localBooksToCell: [Double]!
    var toCloudSwitch: ShelfToCloudSwitch!
    var loggedIn = false
    var cloudVar = false
    var currentShelfIndex: Int?{
        get{
            let alexandria = realm.objects(AlexandriaData.self)[0]
            if currentShelf.cloudVar.value ?? false {
                for index in 0..<alexandria.shelves.count{
                    if alexandria.shelves[index].name == currentShelf.name {
                        return index
                    }
                }
            } else {
                for index in 0..<alexandria.localShelves.count{
                    if alexandria.shelves[index].name == currentShelf.name {
                        return index
                    }
                }
            }
             return nil
        }
    }
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ShelfName", bundle: nil), forCellReuseIdentifier: ShelfName.identifier)
        tableView.register(UINib(nibName: "ShelfBookPicker", bundle: nil), forCellReuseIdentifier: ShelfBookPicker.identifier)
        tableView.register(UINib(nibName: "ShelfBookCollection", bundle: nil), forCellReuseIdentifier: ShelfBookCollection.identifier)
        tableView.register(UINib(nibName: "ShelfToCloudSwitch", bundle: nil), forCellReuseIdentifier: ShelfToCloudSwitch.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controller.refreshView()
    }
}
