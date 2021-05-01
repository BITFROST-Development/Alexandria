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

class AddNewFileViewController: UIViewController, BookChangerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var updating = false
    var originalBookURL: URL!
    var controller: MyShelvesViewController!
    var newBookURL: URL!
    var loggedIn: Bool!
    var fileShouldBeMoved = false
    var originalFileName: String {
        get{
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
        } set{}
    }
    var finalFileName: String!
    var thumbnail: UIImage{
        do {
            let data = try Data(contentsOf: originalBookURL)
            let page = PDFDocument(data: data)?.page(at: 0)
            let pageSize = page?.bounds(for: .mediaBox)
            let pdfScale = 180 / pageSize!.width
            let scale = UIScreen.main.scale * pdfScale
            let screenSize = CGSize(width: pageSize!.width * scale, height: pageSize!.height * scale)
            return page!.thumbnail(of: screenSize, for: .mediaBox)
        } catch {
            return UIDocumentInteractionController(url: originalBookURL).icons.last!
        }
        
    }
    var thumbnailData: StoredFile!
    var author: String! = ""
    var year: String! = ""
    var metadataCount = 2
    var isCloud: Bool{
        if toDrive{
            return true
        } else {
            for shelf in shelvesToAddress {
                if shelf.cloudVar.value == true{
                    return true
                }
            }
        }
        return false
    }
    var shelvesToAddress: [Shelf] = []
    var toDrive = false
    var tableOriginalLoad = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingShadeView: UIView!
    @IBOutlet weak var importBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.importBar.progress = 0
        loadingShadeView.alpha = 0
        AddFileViewTitle.controller = self
        AddFileDone.controller = self
        thumbnailData = StoredFile()
        thumbnailData.data = thumbnail.jpegData(compressionQuality: 0.1)
        print(thumbnailData!)
        tableView.register(UINib(nibName: "AddFileThumbnail", bundle: nil), forCellReuseIdentifier: AddFileThumbnail.identifier)
        tableView.register(UINib(nibName: "AddFileViewTitle", bundle: nil), forCellReuseIdentifier: AddFileViewTitle.identifier)
        tableView.register(UINib(nibName: "AddFilePickerTrigger", bundle: nil), forCellReuseIdentifier: AddFilePickerTrigger.identifier)
        tableView.register(UINib(nibName: "AddFileCheckBoxes", bundle: nil), forCellReuseIdentifier: AddFileCheckBoxes.identifier)
        tableView.register(UINib(nibName: "AddFileMetadataComponent", bundle: nil), forCellReuseIdentifier: AddFileMetadataComponent.identifier)
        tableView.register(UINib(nibName: "AddFileDone", bundle: nil), forCellReuseIdentifier: AddFileDone.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        finalFileName = originalFileName
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
            cell.fileTitle.text = finalFileName
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFilePickerTrigger.identifier) as! AddFilePickerTrigger
            if shelvesToAddress.count == 0 {
                cell.fieldDescription.text = "All my books"
            } else if shelvesToAddress.count == 1{
                cell.fieldDescription.text = shelvesToAddress[0].name
            } else {
                cell.fieldDescription.text = "Multiple"
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileCheckBoxes") as! AddFileCheckBoxes
            cell.optionName.text = "Store in Google Drive"
            if loggedIn && Socket.sharedInstance.socket.status == .connected{
                cell.isChecked = true
                cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
                cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
                cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
                toDrive = true
                if isCloud && shelvesToAddress.count > 0{
                    toDrive = true
                    cell.optionName.alpha = 0.3
                    cell.checkCircle.alpha = 0.3
                    cell.recommendedLabel.alpha = 0.3
                    cell.loggedIn = false
                }
            } else {
                toDrive = false
                cell.loggedIn = loggedIn
                cell.optionName.alpha = 0.3
                cell.checkCircle.alpha = 0.3
                cell.recommendedLabel.alpha = 0.3
            }
            cell.controller = self
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileCheckBoxes") as! AddFileCheckBoxes
            cell.optionName.text = "Local Copy"
            if !loggedIn {
                cell.isChecked = true
                cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
                cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
                cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
                fileShouldBeMoved = true
                if !isCloud && shelvesToAddress.count > 0{
                    fileShouldBeMoved = true
                    cell.optionName.alpha = 0.3
                    cell.checkCircle.alpha = 0.3
                    cell.recommendedLabel.alpha = 0.3
                    cell.loggedIn = false
                }
            }
            cell.isChecked = false
            cell.controller = self
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileMetadataComponent") as! AddFileMetadataComponent
            cell.controller = self
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
            cell.controller = self
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
