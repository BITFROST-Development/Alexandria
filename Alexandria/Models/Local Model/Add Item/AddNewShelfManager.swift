//
//  AddNewShelfManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/17/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension AddNewShelfViewController{
    func reloadAllData(){
        tableView.reloadData()
        booksCell.bookCollection.reloadData()
    }
    
    @IBAction func dismissView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createShelf(_ sender: Any){
        toCloud = toCloudSwitch.cloudSwitch.isOn
        if titleCell.shelfName.text != ""{
            let hashTables = realm.objects(BookToListMap.self)
            let newShelf = Shelf()
            newShelf.birthName = titleCell.shelfName.text!
            newShelf.name = titleCell.shelfName.text!
            for book in booksCell.cloudBooksInCollection {
                if toCloud {
                    newShelf.books.append(book)
                } else {
                    newShelf.oppositeBooks.append(book)
                }
                hashTables[1].keys[Int(book)].append(newShelf, book, true)
            }
            for book in booksCell.localBooksInCollection {
                if !toCloud{
                    newShelf.books.append(book)
                } else {
                    newShelf.oppositeBooks.append(book)
                }
                hashTables[0].keys[Int(book)].append(newShelf, book, false)
            }
            do{
                try realm.write(){
                    if createController != nil {
                        if createController.loggedIn {
                            if toCloud {
                                newShelf.cloudVar.value = true
                                realm.objects(CloudUser.self)[0].alexandriaData!.shelves.append(newShelf)
                                Socket.sharedInstance.updateAlexandriaCloud(username: realm.objects(CloudUser.self)[0].username, alexandriaInfo: AlexandriaDataDec(true))
                            } else {
                                newShelf.cloudVar.value = false
                                realm.objects(CloudUser.self)[0].alexandriaData!.localShelves.append(newShelf)
                            }
                        } else {
                            newShelf.cloudVar.value = false
                            realm.objects(UnloggedUser.self)[0].alexandriaData!.localShelves.append(newShelf)
                        }
                    } else {
                        if newFileController.controller.loggedIn {
                            if toCloud {
                                newShelf.cloudVar.value = true
                                realm.objects(CloudUser.self)[0].alexandriaData!.shelves.append(newShelf)
                            } else {
                                newShelf.cloudVar.value = false
                                realm.objects(CloudUser.self)[0].alexandriaData!.localShelves.append(newShelf)
                            }
                        } else {
                            newShelf.cloudVar.value = false
                            realm.objects(UnloggedUser.self)[0].alexandriaData!.localShelves.append(newShelf)
                        }
                    }
                    sem.signal()
                }
            } catch {
                print("Shelf could not be created")
            }
            
            if createController != nil {
                sem.wait()
                createController.shelvesList.reloadData()
            } else {
                newFileController.selectedShelves.append(newShelf)
                sem.wait()
                newFileController.tableView.reloadData()
            }
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error Creating Shelf", message: "You need to give your shelf a name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookPicker" {
            let picker = segue.destination as! BookCollectionViewControler
            picker.controller = self
            picker.selectedCloudBooks = booksCell.cloudBooksInCollection
            picker.selectedLocalBooks = booksCell.localBooksInCollection
        }
    }
}
