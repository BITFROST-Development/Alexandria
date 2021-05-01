////
////  AddNewFileManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/25/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import ZIPFoundation
//import PDFKit
//
//extension AddNewFileViewController: SocketDelegate {
//    func refreshView(){
//        tableOriginalLoad = false
//        tableView.reloadData()
//        controller.refreshView()
//    }
//}
//
//extension AddNewFileViewController {
//    func updateArray(_ newArray: [Shelf]) {
//        shelvesToAddress.removeAll()
//        shelvesToAddress = newArray
//    }
//    
//    func createFile() {
//        
//        let newBook = Book()
//        newBook.name = finalFileName
//        newBook.author = author
//        newBook.year = year
//        thumbnailData.name = "\(finalFileName!) Thumbnail"
//        thumbnailData.contentType = "image"
//        newBook.thumbnail = thumbnailData
////        let temp = newBookURL.deletingLastPathComponent().appendingPathComponent(finalFileName + ".alexandria")
//        UIView.animate(withDuration: 0.3, animations: {
//            self.loadingShadeView.alpha = 1
//        }){ _ in
//            self.importBar.progress = 0
//            let bookDoc = PDFDocument(url: self.originalBookURL)
//            var annotationImageString = ""
//            for index in 0..<(bookDoc?.pageCount ?? 0){
//                let currentPage = bookDoc?.page(at: index)
//                var currentPageAnnotations: [PDFAnnotation] = []
//                for annotation in currentPage?.annotations ?? []{
//                    currentPageAnnotations.append(annotation)
//                    currentPage?.removeAnnotation(annotation)
//                }
//                autoreleasepool(invoking: {
//                    UIGraphicsBeginImageContextWithOptions(currentPage!.bounds(for: .mediaBox).size, false, 0.0)
//                    let currentContext = UIGraphicsGetCurrentContext()!
//                    currentContext.translateBy(x: 0.0, y: currentPage!.bounds(for: .mediaBox).height)
//                    currentContext.scaleBy(x: 1.0, y: -1.0)
//                    for annotation in currentPageAnnotations{
//                        annotation.draw(with: .cropBox, in: currentContext)
//                    }
//                    let image = UIGraphicsGetImageFromCurrentImageContext()
//                    UIGraphicsEndImageContext()
//                    annotationImageString = "\(annotationImageString)/page/\(index)/begin/\n\(image!.pngData()!.base64EncodedString())\n/page/\(index)/end/\n"
//                })
//                self.importBar.setProgress(Float(index) * 0.85 / Float(bookDoc!.pageCount), animated: true)
//            }
//            
//            var booksFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            booksFolder.appendPathComponent("Books")
//            if !FileManager.default.fileExists(atPath: booksFolder.path){
//                do{
//                    try FileManager.default.createDirectory(at: booksFolder, withIntermediateDirectories: true, attributes: nil)
//                } catch let error{
//                    print(error.localizedDescription)
//                }
//            }
//            var newFileCreatorAddress = booksFolder.appendingPathComponent("\(self.finalFileName ?? "")")
//            do{
//                
//                var writingURL: URL? = newFileCreatorAddress
//                if self.fileShouldBeMoved{
//                    try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
//                    let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
//                    try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
//                    FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: bookDoc?.dataRepresentation(), attributes: nil)
//                    try annotationImageString.write(to: attachmentsFolder.appendingPathComponent("top"), atomically: false, encoding: .utf8)
//                    let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
//                    try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
//                    FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
//                    FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
//                    FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
//                    FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
//                    FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
//                    newBook.localAddress = "Books/" + newFileCreatorAddress.lastPathComponent
//                    self.importBar.setProgress(0.9, animated: true)
//                } else {
//                    do{
//                        let hiddenFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".hidden")
//                        if !FileManager.default.fileExists(atPath: hiddenFolder.path){
//                            do{
//                                try FileManager.default.createDirectory(at: hiddenFolder, withIntermediateDirectories: true, attributes: nil)
//                            } catch let error{
//                                print(error.localizedDescription)
//                            }
//                        }
//                        newFileCreatorAddress = hiddenFolder.appendingPathComponent("\(self.finalFileName ?? "")")
//                        try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
//                        let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
//                        try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: bookDoc?.dataRepresentation(), attributes: nil)
//                        try annotationImageString.write(to: attachmentsFolder.appendingPathComponent("top"), atomically: false, encoding: .utf8)
//                        let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
//                        try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
//                        FileManager.default.createFile(atPath: userDataFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
//                        writingURL = hiddenFolder.appendingPathComponent("\(self.finalFileName ?? "")")
//                        self.importBar.setProgress(0.9, animated: true)
//                    } catch let error {
//                        print(error.localizedDescription)
//                        let alert = UIAlertController(title: "Error Adding File", message: "There was an error adding \"\(self.finalFileName!)\" to your shelves. Please try again.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                        self.present(alert, animated: true)
//                    }
//                }
//                if self.toDrive{
//                    newBook.cloudVar.value = true
//                }
//                self.writeBook(newBook: newBook, tempFile: writingURL?.path, completion: { (user) in
//                    if self.toDrive {
//                        let update = AlexandriaDataDec(true)
//                        Socket.sharedInstance.updateAlexandriaCloud(username: user!.username, alexandriaInfo: update)
//                        self.controller.shelfCollectionView.reloadData()
//                        self.importBar.setProgress(1, animated: true)
//                        self.dismiss(animated: true, completion: nil)
//                    } else {
//                        self.controller.shelfCollectionView.reloadData()
//                        self.importBar.setProgress(1, animated: true)
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                })
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func writeBook(newBook: Book, tempFile: String?, completion: @escaping(CloudUser?) -> Void){
//        let realm = try! Realm(configuration: AppDelegate.realmConfig)
//        let alexandria = realm.objects(AlexandriaData.self)[0]
//        do{
//            try realm.write({
//                if toDrive {
//                    newBook.cloudVar.value = true
//                    alexandria.cloudBooks.append(newBook)
//                    if shelvesToAddress.count == 0{
//                        realm.objects(BookToListMap.self)[1].append(key: Double(alexandria.cloudBooks.count - 1), value: nil, isCloud: true)
//                    }
//                } else {
//                    newBook.cloudVar.value = false
//                    alexandria.localBooks.append(newBook)
//                    if shelvesToAddress.count == 0{
//                        realm.objects(BookToListMap.self)[0].append(key: Double(alexandria.localBooks.count - 1), value: nil, isCloud: false)
//                    }
//                }
//            })
//            for storedShelf in shelvesToAddress{
//                do{
//                    try realm.write(){
//                        if isCloud {
//                            storedShelf.books.append(Double(alexandria.cloudBooks.count))
//                            realm.objects(BookToListMap.self)[1].append(key: Double(alexandria.cloudBooks.count), value: storedShelf, isCloud: true)
//                        } else {
//                            storedShelf.books.append(Double(alexandria.localBooks.count))
//                            realm.objects(BookToListMap.self)[0].append(key: Double(alexandria.localBooks.count), value: storedShelf, isCloud: false)
//                        }
//                        
//                    }
//                } catch {
//                    print("could not add shelves")
//                }
//            }
//        } catch {
//            print("could not wirte book")
//        }
//        if toDrive {
//            if fileShouldBeMoved {
//                let tempFileAddress = URL(fileURLWithPath: newBook.localAddress!, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
//                GoogleDriveTools.uploadBookToDrive(fileName: newBook.name!, bookTitle: newBook.name! ,fileURL: tempFileAddress, mimeType: "application/alexandria", parent: alexandria.filesFolderID!, service: GoogleDriveTools.service){ should in
//                    if should {
//                        completion(realm.objects(CloudUser.self)[0])
//                    }
//                }
//            } else {
//                GoogleDriveTools.uploadBookToDrive(fileName: newBook.name!, bookTitle: newBook.name! ,fileURL: URL(fileURLWithPath: tempFile!), mimeType: "application/alexandria", parent: alexandria.filesFolderID!, service: GoogleDriveTools.service){ should in
//                    if should {
//                        do{
//                            try FileManager.default.removeItem(atPath: tempFile!)
//                        } catch let error {
//                            print(error.localizedDescription)
//                        }
//                        completion(realm.objects(CloudUser.self)[0])
//                    }
//                }
//            }
//        } else if loggedIn{
//            let alert = UIAlertController(title: "Cloud Alert", message: "If you don't share your files to Google Drive you will not be able to access them from other devices", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Continue", style: .destructive){ action in
//                completion(nil)
//            })
//            alert.addAction(UIAlertAction(title: "Add to Drive", style: .default){ action in
//                let tempFileAddress = URL(fileURLWithPath: newBook.localAddress!, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
//                GoogleDriveTools.uploadBookToDrive(fileName: newBook.name!, bookTitle: newBook.name! ,fileURL: tempFileAddress, mimeType: "application/alexandria", parent: alexandria.filesFolderID!, service: GoogleDriveTools.service){ should in
//                    if should {
//                        completion(realm.objects(CloudUser.self)[0])
//                    }
//                }
//            })
//            self.present(alert, animated: true)
//        } else {
//            completion(nil)
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "shelfPicker" {
//            let picker = segue.destination as! ShelfListViewController
//            picker.controller = self
//            picker.selectedShelves = shelvesToAddress
//        }
//    }
//}
