//
//  AddNewFileManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/25/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension AddNewFileViewController: SocketDelegate {
    func refreshView(){
        tableOriginalLoad = false
        tableView.reloadData()
        controller.refreshView()
    }
}

extension AddNewFileViewController {
    func updateArray(_ newArray: [Shelf]) {
        shelvesToAddress.removeAll()
        shelvesToAddress = newArray
    }
    
    func createFile() {
        
        let newBook = Book()
        newBook.title = finalFileName
        newBook.author = author
        newBook.year = year
        thumbnailData.name = "\(finalFileName!) Thumbnail"
        thumbnailData.contentType = "image"
        newBook.thumbnail = thumbnailData
        let temp = newBookURL.deletingLastPathComponent().appendingPathComponent(finalFileName + ".pdf")
        if fileShouldBeMoved{
            do{
                try FileManager.default.copyItem(at: originalBookURL, to: newBookURL)
                newBook.localAddress = temp.path
                do{
                    try FileManager.default.moveItem(at: newBookURL, to: temp)
                } catch let error{
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error Adding File", message: "There was an error adding \"\(finalFileName!)\" to your shelves. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        if toDrive{
            newBook.cloudVar.value = true
        }
        writeBook(newBook: newBook, completion: { (user) in
            if self.toDrive {
                let update = AlexandriaDataDec(true)
                Socket.sharedInstance.updateAlexandriaCloud(username: user!.username, alexandriaInfo: update)
                self.controller.shelfCollectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.controller.shelfCollectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func writeBook(newBook: Book, completion: @escaping(CloudUser?) -> Void){
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let alexandria = realm.objects(AlexandriaData.self)[0]
        do{
            try realm.write({
                if toDrive {
                    newBook.cloudVar.value = true
                    alexandria.cloudBooks.append(newBook)
                    if shelvesToAddress.count == 0{
                        realm.objects(BookToListMap.self)[1].append(key: Double(alexandria.cloudBooks.count - 1), value: nil, isCloud: true)
                    }
                } else {
                    newBook.cloudVar.value = false
                    alexandria.localBooks.append(newBook)
                    if shelvesToAddress.count == 0{
                        realm.objects(BookToListMap.self)[0].append(key: Double(alexandria.localBooks.count - 1), value: nil, isCloud: false)
                    }
                }
            })
            for storedShelf in shelvesToAddress{
                do{
                    try realm.write(){
                        if isCloud {
                            storedShelf.books.append(Double(alexandria.cloudBooks.count))
                            realm.objects(BookToListMap.self)[1].append(key: Double(alexandria.cloudBooks.count), value: storedShelf, isCloud: true)
                        } else {
                            storedShelf.books.append(Double(alexandria.localBooks.count))
                            realm.objects(BookToListMap.self)[0].append(key: Double(alexandria.localBooks.count), value: storedShelf, isCloud: false)
                        }
                        
                    }
                } catch {
                    print("could not add shelves")
                }
            }
        } catch {
            print("could not wirte book")
        }
        if toDrive {
            if fileShouldBeMoved {
                GoogleDriveTools.uploadFileToDrive(fileName: newBook.title!, bookTitle: newBook.title! ,fileURL: URL(fileURLWithPath: newBook.localAddress!), mimeType: "application/pdf", parent: alexandria.booksFolderID!, service: GoogleDriveTools.service){ should in
                    if should {
                        completion(realm.objects(CloudUser.self)[0])
                    }
                }
            } else {
                GoogleDriveTools.uploadFileToDrive(fileName: newBook.title!, bookTitle: newBook.title! ,fileURL: originalBookURL, mimeType: "application/pdf", parent: alexandria.booksFolderID!, service: GoogleDriveTools.service){ should in
                    if should {
                        completion(realm.objects(CloudUser.self)[0])
                    }
                }
            }
        } else if loggedIn{
            let alert = UIAlertController(title: "Cloud Alert", message: "If you don't share your files to Google Drive you will not be able to access them from other devices", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive){ action in
                completion(nil)
            })
            alert.addAction(UIAlertAction(title: "Add to Drive", style: .default){ action in
                GoogleDriveTools.uploadFileToDrive(fileName: newBook.title!, bookTitle: newBook.title! ,fileURL: URL(fileURLWithPath: newBook.localAddress!), mimeType: "application/pdf", parent: alexandria.rootFolderID!, service: GoogleDriveTools.service){ should in
                    if should{
                        completion(realm.objects(CloudUser.self)[0])
                    }
                }
            })
            self.present(alert, animated: true)
        } else {
            completion(nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shelfPicker" {
            let picker = segue.destination as! ShelfListViewController
            picker.controller = self
            picker.selectedShelves = shelvesToAddress
        }
    }
}
