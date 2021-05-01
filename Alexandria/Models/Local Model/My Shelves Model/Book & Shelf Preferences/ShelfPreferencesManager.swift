////
////  ShelfPreferencesManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/17/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//extension ShelfPreferences: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == 2{
//            performSegue(withIdentifier: "bookPicker", sender: self)
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 3 {
//            if CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) % 3) == 0{
//                return 280 * CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) / 3)
//            }
//            return 280 * ((CGFloat((booksCell.cloudBooksInCollection.count + booksCell.localBooksInCollection.count) / 3)) + 1)
//        } else if indexPath.row != 0 {
//            return 60
//        }
//        return 100
//    }
//}
//
//extension ShelfPreferences: UITableViewDataSource{
//   
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfName.identifier) as! ShelfName
//            ShelfName.controller = self
//            cell.shelfName.text = currentShelf.name
//            cell.clearButton.alpha = 1.0
//            titleCell = cell
//            return cell
//        } else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfToCloudSwitch.identifier) as! ShelfToCloudSwitch
//            toCloudSwitch = cell
//            if !loggedIn {
//                cell.cloudLabel.alpha = 0.3
//                cell.cloudSwitch.isEnabled = false
//                cell.cloudSwitch.isOn = false
//            } else {
//                if cloudVar {
//                    cell.cloudSwitch.isOn = true
//                } else {
//                    cell.cloudSwitch.isOn = false
//                }
//            }
//            return cell
//        } else if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfBookPicker.identifier) as! ShelfBookPicker
//            return cell
//        } else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: ShelfBookCollection.identifier) as! ShelfBookCollection
//            cell.cloudBooksInCollection = cloudBooksToCell
//            cell.localBooksInCollection = localBooksToCell
//            booksCell = cell
//            cell.bookCollection.reloadData()
//            return cell
//        }
//    }
//    
//}
//
//extension ShelfPreferences: SocketDelegate{
//    
//    func refreshView() {
//        tableView.reloadData()
//        controller.refreshView()
//    }
//    
//}
//
//extension ShelfPreferences{
//    func reloadAllData(){
//        booksCell.bookCollection.reloadData()
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "bookPicker" {
//            let picker = segue.destination as! BookCollectionViewControler
//            picker.controller = self
//            picker.selectedCloudBooks = booksCell.cloudBooksInCollection
//            picker.selectedLocalBooks = booksCell.localBooksInCollection
//        }
//    }
//    
//    func writeShelf(completion: (Bool) -> Void){
//        let hashTables = realm.objects(BookToListMap.self)
//        let alexandria = realm.objects(AlexandriaData.self)[0]
//        do{
//            try realm.write({
//                self.currentShelf.name = self.titleCell.shelfName.text
//                self.currentShelf.books.removeAll()
//                self.currentShelf.oppositeBooks.removeAll()
//                if self.cloudVar != currentShelf.cloudVar.value {
//                    self.currentShelf.cloudVar.value = self.cloudVar
//                    if self.cloudVar {
//                        alexandria.localShelves.remove(at: currentShelfIndex!)
//                    } else {
//                        alexandria.shelves.remove(at: currentShelfIndex!)
//                    }
//                }
//            })
//            for book in self.booksCell.cloudBooksInCollection {
//                do {
//                    try realm.write({
//                        if self.cloudVar {
//                            self.currentShelf.books.append(book)
//                        } else {
//                            self.currentShelf.oppositeBooks.append(book)
//                        }
//                    })
//                    hashTables[1].keys[Int(book)].append(self.currentShelf, book, true)
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//            for book in booksCell.localBooksInCollection {
//                do{
//                    try realm.write({
//                        if !cloudVar{
//                            self.currentShelf.books.append(book)
//                        } else {
//                            self.currentShelf.oppositeBooks.append(book)
//                        }
//                    })
//                    hashTables[0].keys[Int(book)].append(self.currentShelf, book, false)
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            }
//            completion(true)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    
//    @IBAction func dismissView(_ sender: Any){
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func saveShelf(_ sender: Any){
//        cloudVar = toCloudSwitch.cloudSwitch.isOn
//        if titleCell.shelfName.text != ""{
//            writeShelf(){ success in
//                if success {
//                    if self.loggedIn{
//                        Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
//                    }
//                    self.dismiss(animated: true, completion: nil)
//                } else {
//                    let alert = UIAlertController(title: "Error Saving Shelf", message: "There was an unexpected error trying to save your changes. Try again later!", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                }
//            }
//        } else {
//            let alert = UIAlertController(title: "Error Saving Shelf", message: "You need to give your shelf a name!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
//    }
//}
