//
//  AddNewShelfViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/18/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewShelfViewController: UIViewController, ShelfChangerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var createController: MyShelvesViewController!
    var newFileController: ShelfListViewController!
    var titleCell: ShelfName!
    var booksCell: ShelfBookCollection!
    var toCloudSwitch: ShelfToCloudSwitch!
    var toCloud = false
    var sem = DispatchSemaphore(value: 0)
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
        if createController != nil {
            createController.refreshView()
        } else if newFileController != nil {
            newFileController.refreshView()
        }
    }
}

extension AddNewShelfViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2{
            performSegue(withIdentifier: "bookPicker", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            if CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) % 3) == 0{
                return 280 * CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) / 3)
            }
            return 280 * ((CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) / 3)) + 1)
        } else if indexPath.row != 0 {
            return 60
        }
        return 100
    }
}

extension AddNewShelfViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfName.identifier) as! ShelfName
            ShelfName.controller = self
            titleCell = cell
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfToCloudSwitch.identifier) as! ShelfToCloudSwitch
            toCloudSwitch = cell
            if !toCloud {
                cell.cloudLabel.alpha = 0.3
                cell.cloudSwitch.isEnabled = false
                cell.cloudSwitch.isOn = false
            }
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfBookPicker.identifier) as! ShelfBookPicker
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfBookCollection.identifier) as! ShelfBookCollection
            booksCell = cell
            cell.bookCollection.reloadData()
            return cell
        }
    }
    
}

extension AddNewShelfViewController: SocketDelegate{
    func refreshView(){
        tableView.reloadData()
        if createController != nil {
            createController.refreshView()
        } else if newFileController != nil {
            newFileController.refreshView()
        }
    }
}
