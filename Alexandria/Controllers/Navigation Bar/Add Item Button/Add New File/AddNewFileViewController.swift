//
//  AddNewFileViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit
import RealmSwift
import GoogleAPIClientForREST

class AddNewFileViewController: UIViewController {
    
    var originalBookURL: URL!
    var newBookURL: URL!
    var loggedIn: Bool!
    var fileShouldBeMoved = false
    var originalFileName: String {
        let base = String(originalBookURL.lastPathComponent)
        var lastPeriod = 0
        var counter = 0
        
        for character in base {
            if character == "." {
                lastPeriod = counter
            }
            counter += 1
        }
        
        return String(base.prefix(lastPeriod))
    }
    var finalTitle: String {
        get{
            return originalFileName
        } set {
            
        }
    }
    var thumbnail: UIImage{
        do {
            let data = try Data(contentsOf: originalBookURL)
            let page = PDFDocument(data: data)?.page(at: 0)
            let pageSize = page?.bounds(for: .mediaBox)
            let pdfScale = 240 / pageSize!.width
            let scale = UIScreen.main.scale * pdfScale
            let screenSize = CGSize(width: pageSize!.width * scale, height: pageSize!.height * scale)
            return page!.thumbnail(of: screenSize, for: .mediaBox)
        } catch {
            return UIDocumentInteractionController(url: originalBookURL).icons.last!
        }
        
    }
    var author = ""
    var year = ""
    var metadataCount = 2
    var shelfName = ["All my books"]
    var toDrive = true
    var shouldCopy = false
    var doneCell:AddFileDone!
    var tableOriginalLoad = true
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AddFileViewTitle.controller = self
        AddFileDone.controller = self
        tableView.register(UINib(nibName: "AddFileThumbnail", bundle: nil), forCellReuseIdentifier: AddFileThumbnail.identifier)
        tableView.register(UINib(nibName: "AddFileViewTitle", bundle: nil), forCellReuseIdentifier: AddFileViewTitle.identifier)
        tableView.register(UINib(nibName: "AddFileShelfPickerTrigger", bundle: nil), forCellReuseIdentifier: AddFileShelfPickerTrigger.idetifier)
        tableView.register(UINib(nibName: "AddFileCheckBoxes", bundle: nil), forCellReuseIdentifier: AddFileCheckBoxes.identifier)
        tableView.register(UINib(nibName: "AddFileMetadataComponent", bundle: nil), forCellReuseIdentifier: AddFileMetadataComponent.identifier)
        tableView.register(UINib(nibName: "AddFileDone", bundle: nil), forCellReuseIdentifier: AddFileDone.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createFile() {
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let newBook = Book()
        newBook.title = finalTitle
        newBook.author = author
        newBook.year = year
        newBook.thumbnail?.initialize("\(finalTitle) Thumbnail", thumbnail.jpegData(compressionQuality: 0.5)!, "image")
        if fileShouldBeMoved{
            do{
                try FileManager.default.copyItem(at: originalBookURL, to: newBookURL)
                newBook.localAddress = newBookURL.absoluteString
            } catch {
                let alert = UIAlertController(title: "Error Adding File", message: "There was an error adding \"\(finalTitle)\" to your shelves. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        } else {
            newBook.localAddress = originalBookURL.absoluteString
        }
        if loggedIn {
            let user = realm.objects(CloudUser.self)[0]
            for shelf in user.alexandriaData!.shelves {
                for name in shelfName{
                    if shelf.name == name {
                        do{
                            try realm.write(){
                                shelf.books.append(newBook)
                            }
                        } catch {
                            
                        }
                    }
                }
            }
            if toDrive {
                GoogleDriveTools.uploadFileToDrive(name: newBook.title!, fileURL: URL(string: newBook.localAddress!)!, mimeType: "application/pdf", parent: user.alexandriaData!.booksFolderID!, service: GoogleDriveTools.service)
            } else {
                let alert = UIAlertController(title: "Cloud Alert", message: "If you don't share your files to Google Drive you will not be able to access them from other devices", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "Add to Drive", style: .default){ action in
                    GoogleDriveTools.uploadFileToDrive(name: newBook.title!, fileURL: URL(string: newBook.localAddress!)!, mimeType: "application/pdf", parent: user.alexandriaData!.rootFolderID!, service: GoogleDriveTools.service)
                })
                self.present(alert, animated: true)
            }
        } else {
            let user = realm.objects(UnloggedUser.self)[0]
            for shelf in user.alexandriaData!.shelves {
                for name in shelfName{
                    if shelf.name == name {
                        do{
                            try realm.write(){
                                shelf.books.append(newBook)
                            }
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
}

extension AddNewFileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "shelfPicker", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            if view.frame.height < 723{
                return 90
            } else {
                return view.frame.size.height - 718
            }
        }
        return UITableView.automaticDimension
    }
}

extension AddNewFileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 + metadataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileThumbnail.identifier) as! AddFileThumbnail
            cell.fileThumbnail.image = thumbnail
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileViewTitle.identifier) as! AddFileViewTitle
            cell.fileTitle.text = originalFileName
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileShelfPickerTrigger.idetifier) as! AddFileShelfPickerTrigger
            if shelfName.count == 1 {
                cell.shelfName.text = shelfName[0]
            } else {
                cell.shelfName.text = "Multiple"
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileCheckBoxes") as! AddFileCheckBoxes
            cell.optionName.text = "Store in Google Drive"
            if loggedIn {
                cell.isChecked = true
                cell.checkCircle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
                cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
            } else {
                cell.loggedIn = loggedIn
                cell.optionName.alpha = 0.3
                cell.checkCircle.alpha = 0.3
                cell.recommendedLabel.alpha = 0.3
            }
            cell.controller = self
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileCheckBoxes") as! AddFileCheckBoxes
            cell.optionName.text = "Copy to App Folder"
            cell.isChecked = false
            cell.controller = self
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileMetadataComponent") as! AddFileMetadataComponent
            cell.metadataName.text = "Author"
            cell.metadataContent.placeholder = "Name"
            if let title = PDFDocument(url: originalBookURL)?.documentAttributes![PDFDocumentAttribute.authorAttribute] as? String{
                cell.metadataContent.text = title
            } else {
                if tableOriginalLoad {
                    cell.metadataContent.layer.frame.origin.x = cell.metadataContent.layer.frame.minX + 13
                }
                cell.cleatButton.alpha = 0.0
            }
            return cell
        } else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileMetadataComponent.identifier) as! AddFileMetadataComponent
            cell.metadataName.text = "Year"
            cell.metadataContent.placeholder = "Date"
            if tableOriginalLoad {
                cell.metadataContent.layer.frame.origin.x = cell.metadataContent.layer.frame.minX + 13
            }
            cell.cleatButton.alpha = 0.0
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileDone.identifier) as! AddFileDone
            return cell
        }
        return UITableViewCell()
    }
    
    
}
