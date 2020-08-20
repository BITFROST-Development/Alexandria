//
//  ShlefListViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class ShelfListViewController: UIViewController {
    
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    
    var controller: AddNewFileViewController!
    var updateController: BookPreferences!
    var selectedShelves: [Shelf] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SectionTitle", bundle: nil), forCellReuseIdentifier: SectionTitle.identifier)
        tableView.register(UINib(nibName: "CreateNewShelf", bundle: nil), forCellReuseIdentifier: CreateNewShelf.identifier)
        tableView.register(UINib(nibName: "ShelfCell", bundle: nil), forCellReuseIdentifier: ShelfCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if controller != nil {
            controller.refreshView()
        } else {
            updateController.refreshView()
        }
    }
    
    func toCreateShelf(){
        performSegue(withIdentifier: "toAddNewShelf", sender: self)
    }
    
    func updateArray(_ newArray: [Shelf]){
        selectedShelves.removeAll()
        print(selectedShelves)
        selectedShelves = newArray
        print(selectedShelves)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishedSelecting(_ sender: Any) {
        if controller != nil {
            controller.updateArray(self.selectedShelves)
            controller.tableOriginalLoad = false
            controller.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            updateController.updateArray(self.selectedShelves)
            updateController.tableOriginalLoad = false
            updateController.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNewShelf" {
            let picker = segue.destination as! AddNewShelfViewController
            if controller != nil && controller.loggedIn || updateController != nil && updateController.loggedIn {
                picker.toCloud = true
            }
            picker.newFileController = self
        }
    }
    
}

extension ShelfListViewController: UITableViewDelegate{
    
}

extension ShelfListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Shelf.self).count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitle.identifier)
            return cell!
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateNewShelf.identifier) as! CreateNewShelf
            cell.controller = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfCell.identifier) as! ShelfCell
            cell.controller = self
            let alexandria = realm.objects(AlexandriaData.self)[0]
            if indexPath.row - 2 < alexandria.shelves.count {
                cell.storedShelf = alexandria.shelves[indexPath.row - 2]
                cell.indexOfShelf = indexPath.row - 2
            } else {
                cell.storedShelf = alexandria.localShelves[indexPath.row - 2 - alexandria.shelves.count]
                cell.indexOfShelf = indexPath.row - 2 - alexandria.shelves.count
            }
            
            cell.shelfSelectableCell.setTitle(" \(cell.storedShelf.name!)", for: .normal)
            print(selectedShelves)
            for shelf in selectedShelves {
                if Shelf.equals(shelf, cell.storedShelf){
                    cell.isSelectedShelf = true
                    cell.shelfSelectableCell.setTitleColor(UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1)), for: .normal)
                    cell.shelfSelectableCell.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
                    cell.shelfSelectableCell.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
            }
            return cell
        }
    }
    
    
}

extension ShelfListViewController: SocketDelegate{
    func refreshView(){
        tableView.reloadData()
        if controller != nil {
            controller.refreshView()
        } else {
            updateController.refreshView()
        }
    }
}
