//
//  BookPreferences.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/29/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class BookPreferences: UIViewController, BookChangerDelegate {
    var updating = true
    var controller: MyShelvesViewController!
    var currentBook: Book!
    var currentBookIndex: Int!
    var loggedIn: Bool!
    var fileShouldBeMoved: Bool = false
    var isCloud = false
    var originalFileName: String!
    var finalFileName: String!
    var thumbnail: UIImage!{
        get {
            return UIImage(data: currentBook.thumbnail!.data!)
        }
    }
    var author: String!
    var year: String!
    var shelvesToAddress: [Shelf] = []
    var toDrive: Bool = false
    var tableOriginalLoad = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddFileViewTitle.controller = self
        BookPreferencesDoneDelete.controller = self
        tableView.register(UINib(nibName: "AddFileThumbnail", bundle: nil), forCellReuseIdentifier: AddFileThumbnail.identifier)
        tableView.register(UINib(nibName: "AddFileViewTitle", bundle: nil), forCellReuseIdentifier: AddFileViewTitle.identifier)
        tableView.register(UINib(nibName: "AddFileShelfPickerTrigger", bundle: nil), forCellReuseIdentifier: AddFileShelfPickerTrigger.idetifier)
        tableView.register(UINib(nibName: "AddFileCheckBoxes", bundle: nil), forCellReuseIdentifier: AddFileCheckBoxes.identifier)
        tableView.register(UINib(nibName: "AddFileMetadataComponent", bundle: nil), forCellReuseIdentifier: AddFileMetadataComponent.identifier)
        tableView.register(UINib(nibName: "BookPreferencesDoneDelete", bundle: nil), forCellReuseIdentifier: BookPreferencesDoneDelete.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        finalFileName = originalFileName
        author = currentBook.author
        year = currentBook.year
        toDrive = isCloud
        if isCloud {
            if currentBook.localAddress != nil {
                fileShouldBeMoved = true
            } else {
                fileShouldBeMoved = false
            }
        } else {
            if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books/\(self.currentBook.title!).pdf"){
                fileShouldBeMoved = true
            } else {
                fileShouldBeMoved = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.refreshView()
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension BookPreferences: UITableViewDelegate{
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

extension BookPreferences: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
            if shelvesToAddress.count == 0 {
                cell.shelfName.text = "All my books"
            } else if shelvesToAddress.count == 1{
                cell.shelfName.text = shelvesToAddress[0].name
            } else {
                cell.shelfName.text = "Multiple"
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileCheckBoxes") as! AddFileCheckBoxes
            cell.optionName.text = "Store in Google Drive"
            if loggedIn {
                if isCloud {
                    cell.isChecked = true
                    cell.checkCircle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                    cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
                    cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
                    toDrive = true
                    if shelvesToAddress.count > 0{
                        cell.optionName.alpha = 0.3
                        cell.checkCircle.alpha = 0.3
                        cell.recommendedLabel.alpha = 0.3
                    }
                } else {
                    toDrive = false
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
            if fileShouldBeMoved || (isCloud && currentBook.localAddress != nil){
                cell.isChecked = true
                cell.checkCircle.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
            } else {
                cell.isChecked = false
            }
            cell.controller = self
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFileMetadataComponent") as! AddFileMetadataComponent
            cell.controller = self
            cell.metadataName.text = "Author"
            cell.metadataContent.placeholder = "Name"
            if author != ""{
                cell.metadataContent.text = author
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
            if year != ""{
                cell.metadataContent.text = year
            } else {
                if tableOriginalLoad {
                    cell.metadataContent.layer.frame.origin.x = cell.metadataContent.layer.frame.minX + 13
                }
            }
            cell.cleatButton.alpha = 0.0
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BookPreferencesDoneDelete.identifier) as! BookPreferencesDoneDelete
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension BookPreferences: SocketDelegate{
    func refreshView() {
        tableOriginalLoad = false
        tableView.reloadData()
        controller.refreshView()
    }
}
