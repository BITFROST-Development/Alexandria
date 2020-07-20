//
//  MyShelvesManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/5/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices

class MyShelvesManager: UIActivity {
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var viewController: MyShelvesViewController?
    var loggedIn = false
}

extension MyShelvesManager: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            viewController?.dismissView()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            viewController?.dismissView()
        }
    }
}

extension MyShelvesManager: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loggedIn {
            return realm.objects(CloudUser.self)[0].alexandriaData!.shelves.count + 2
        } else {
            return realm.objects(UnloggedUser.self)[0].alexandriaData!.shelves.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelvesListTitleCell.identifier, for: indexPath) as! ShelvesListTitleCell
            let selectedView = UIView()
            selectedView.backgroundColor = .white
            cell.selectedBackgroundView = selectedView
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfListCell.identifier, for: indexPath) as! ShelfListCell
            cell.shelfName.text = "All my books"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfListCell.identifier, for: indexPath) as! ShelfListCell
            cell.shelfName.text = realm.objects(CloudUser.self)[0].alexandriaData!.shelves[indexPath.row - 2].name!
            return cell
        }
    }
    
    
}

extension MyShelvesViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var books: URL!
        guard let selectedUrl = urls.first else {
            return
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if FileManager.default.fileExists(atPath: dir.path + "/Books"){
            books = URL(fileURLWithPath: dir.absoluteString + "/Books")
        } else {
            books = dir.appendingPathComponent("Books", isDirectory: true)
        }
        let sandboxFileUrl = books.appendingPathComponent(selectedUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: sandboxFileUrl.path){
            
        } else {
            originalBookURL = selectedUrl
            newBookURL = sandboxFileUrl
            performSegue(withIdentifier: "toAddNewFileView", sender: self)
        }
    }
}

extension MyShelvesViewController {
    func prepareAddItemTableView() {
        addNewElementTableView.alpha = 0.0
        addNewElementTableView.delegate = self
        addNewElementTableView.dataSource = self
        addNewElementTableView.register(UINib(nibName: "AddItemCell", bundle: nil), forCellReuseIdentifier: "addItemCell")
        addNewElementTableView.layer.cornerRadius = 5
//        addNewElementTableView.layer.borderWidth = 1
//        addNewElementTableView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func prepareShelvesLists() {
        shelvesList.delegate = manager
        shelvesList.dataSource = manager
        shelvesList.register(UINib(nibName: "ShelfListCell", bundle: nil), forCellReuseIdentifier: ShelfListCell.identifier)
        shelvesList.register(UINib(nibName: "ShelvesListTitleCell", bundle: nil), forCellReuseIdentifier: ShelvesListTitleCell.identifier)
    }
    
    func addNewFileView() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        UIView.animate(withDuration: 0.3, animations: {
            self.addNewElementTableView.alpha = 0.0
            self.opacityFilter.alpha = 0.0
        })
        addNewElementViewIsPresent = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func addNewShelfView() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toAddNewFileView"{
            var presentedView = segue.destination as! AddNewFileViewController
            presentedView.loggedIn = self.loggedIn
            presentedView.originalBookURL = self.originalBookURL
            presentedView.newBookURL = self.newBookURL
        }
    }
}
