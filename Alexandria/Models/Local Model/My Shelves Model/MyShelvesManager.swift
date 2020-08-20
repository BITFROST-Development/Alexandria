//
//  MyShelvesManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/5/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import SocketIO
import MobileCoreServices
import PDFKit

class MyShelvesManager: UIActivity {
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var viewController: MyShelvesViewController?
    var loggedIn = false
}

extension MyShelvesManager: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            viewController?.shelfName.setTitle((tableView.cellForRow(at: indexPath) as! ShelfListCell).shelfName.text, for: .normal)
            viewController?.cloudShelf = (tableView.cellForRow(at: indexPath) as! ShelfListCell).cloudVar
            viewController?.shelfCollectionView.reloadData()
            viewController?.dismissView()
        }
    }
}

extension MyShelvesManager: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loggedIn = viewController?.loggedIn ?? false
        if loggedIn {
            return realm.objects(CloudUser.self)[0].alexandriaData!.shelves.count + realm.objects(CloudUser.self)[0].alexandriaData!.localShelves.count + 2
        } else {
            return realm.objects(UnloggedUser.self)[0].alexandriaData!.localShelves.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelvesListTitleCell.identifier, for: indexPath) as! ShelvesListTitleCell
            let selectedView = UIView()
            selectedView.backgroundColor = .white
            cell.selectedBackgroundView = selectedView
            cell.controller = viewController
            cell.manager = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfListCell.identifier, for: indexPath) as! ShelfListCell
            cell.shelfName.text = "All my books"
            cell.moreButton.alpha = 0.0
            cell.deleteButton.alpha = 0.0
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfListCell.identifier, for: indexPath) as! ShelfListCell
            cell.controller = viewController
            if loggedIn{
                if indexPath.row - 2 < realm.objects(CloudUser.self)[0].alexandriaData!.shelves.count{
                    cell.shelfName.text = realm.objects(CloudUser.self)[0].alexandriaData!.shelves[indexPath.row - 2].name!
                    cell.cloudVar = true
                } else {
                    cell.shelfName.text = realm.objects(CloudUser.self)[0].alexandriaData!.localShelves[indexPath.row - realm.objects(CloudUser.self)[0].alexandriaData!.shelves.count - 2].name!
                }
            } else {
                cell.shelfName.text = realm.objects(UnloggedUser.self)[0].alexandriaData!.localShelves[indexPath.row - 2].name!
            }
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
        self.originalBookURL = urls[0]
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if FileManager.default.fileExists(atPath: dir.path + "/Books"){
            books = URL(fileURLWithPath: dir.absoluteString + "/Books")
        } else {
            do {
                try FileManager.default.createDirectory(atPath: dir.path + "/Books", withIntermediateDirectories: true, attributes: nil)
                books = URL(fileURLWithPath: dir.absoluteString + "/Books")
            } catch {
                print(error.localizedDescription)
            }
        }
        print(books.absoluteString)
        let sandboxFileUrl = books.appendingPathComponent(selectedUrl.lastPathComponent)
        print(sandboxFileUrl.absoluteString)
        if FileManager.default.fileExists(atPath: sandboxFileUrl.path){
            
        } else {
            self.newBookURL = sandboxFileUrl
            performSegue(withIdentifier: "toAddNewFileView", sender: self)
        }
    }
}

extension MyShelvesViewController: SocketDelegate{
    func refreshView(){
        shelfCollectionView.reloadData()
        shelvesList.reloadData()
    }
}

extension MyShelvesViewController {
    func prepareAddItemTableView() {
        addNewElementTableView.alpha = 0.0
        addNewElementTableView.delegate = self
        addNewElementTableView.dataSource = self
        addNewElementTableView.register(UINib(nibName: "AddItemCell", bundle: nil), forCellReuseIdentifier: "addItemCell")
        addNewElementTableView.layer.cornerRadius = 5
    }
    
    func prepareShelfPrePreferencesTableView() {
        shelfPrePreferencesTableView.alpha = 0.0
        shelfPrePreferencesTableView.delegate = preferencesManager
        shelfPrePreferencesTableView.dataSource = preferencesManager
        shelfPrePreferencesTableView.register(UINib(nibName: "ShelfPrePreferencesCell", bundle: nil), forCellReuseIdentifier: ShelfPrePreferencesCell.identifier)
        shelfPrePreferencesTableView.layer.cornerRadius = 5
    }
    
    func prepareShelvesLists() {
        shelvesList.delegate = manager
        shelvesList.dataSource = manager
        shelvesList.register(UINib(nibName: "ShelfListCell", bundle: nil), forCellReuseIdentifier: ShelfListCell.identifier)
        shelvesList.register(UINib(nibName: "ShelvesListTitleCell", bundle: nil), forCellReuseIdentifier: ShelvesListTitleCell.identifier)
    }
    
    func prepareShelfCollectionView() {
        shelfCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: BookCell.identifier)
        shelfCollectionView.delegate = self
        shelfCollectionView.dataSource = self
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
        UIView.animate(withDuration: 0.3, animations: {
            self.addNewElementTableView.alpha = 0.0
            self.opacityFilter.alpha = 0.0
        })
        performSegue(withIdentifier: "toAddNewShelf", sender: self)
    }
    
    func displayBookOptions(for cell: BookCell) {
        if (currentBook?.cloudVar.value ?? false) && Socket.sharedInstance.socket.status == SocketIOStatus.connected || !(currentBook?.cloudVar.value ?? false){
            let alexandria = realm.objects(AlexandriaData.self)[0]
            currentBookIndex = Int(cell.bookIndex)
            if cell.isCloud{
                currentBook = alexandria.cloudBooks[Int(cell.bookIndex)]
                currentBookCloudStatus = true
                
            } else {
                currentBook = alexandria.localBooks[Int(cell.bookIndex)]
                currentBookCloudStatus = false
            }
            performSegue(withIdentifier: "toBookPreferences", sender: self)
        } else {
            let alert = UIAlertController(title: "Network Error", message: "You're trying to change a cloud object but are not connected to the internet. Check your internet connection if you wish to continue!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert,animated: true)
        }
    }
    
    func openBook(named book: String){
        if currentBook?.localAddress != nil {
            performSegue(withIdentifier: "toEditingView", sender: self)
        } else {
            GoogleDriveTools.retrieveBookFromDrive(id: currentBook!.id!, name: currentBook!.title! + ".pdf", service: GoogleDriveTools.service){ success in
                do{
                    try self.realm.write({
                        self.currentBook!.localAddress = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books/\(self.currentBook!.title!).pdf"
                    })
                    self.performSegue(withIdentifier: "toEditingView", sender: self)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toAddNewFileView"{
            let presentedView = segue.destination as! AddNewFileViewController
            presentedView.loggedIn = self.loggedIn
            presentedView.originalBookURL = self.originalBookURL
            presentedView.newBookURL = self.newBookURL
            presentedView.controller = self
        } else if segue.identifier == "toAddNewShelf"{
            let presentedView = segue.destination as! AddNewShelfViewController
            if loggedIn{
                presentedView.toCloud = true
            }
            presentedView.createController = self
        } else if segue.identifier == "toBookPreferences"{
            let presentedView = segue.destination as! BookPreferences
            presentedView.controller = self
            presentedView.currentBook = currentBook
            presentedView.currentBookIndex = currentBookIndex
            presentedView.loggedIn = loggedIn
            presentedView.isCloud = currentBookCloudStatus!
            presentedView.originalFileName = currentBook?.title
        } else if segue.identifier == "toShelfPreferences" {
            let presentedView = segue.destination as! ShelfPreferences
            presentedView.controller = self
            presentedView.currentShelf = currentShelf
            presentedView.loggedIn = loggedIn
            presentedView.cloudVar = (currentShelf?.cloudVar.value ?? false)
            var books: [Double] = []
            var oppositeBooks: [Double] = []
            for book in currentShelf!.books{
                books.append(book)
            }
            for book in currentShelf!.oppositeBooks{
                oppositeBooks.append(book)
            }
            if currentShelf?.cloudVar.value ?? false {
                presentedView.cloudBooksToCell = books
                presentedView.localBooksToCell = oppositeBooks
            } else {
                presentedView.cloudBooksToCell = oppositeBooks
                presentedView.localBooksToCell = books
            }
        } else if segue.identifier == "toEditingView" {
            let presentedView = segue.destination as! EditingViewController
            presentedView.currentBook = currentBook
        }
    }
}
