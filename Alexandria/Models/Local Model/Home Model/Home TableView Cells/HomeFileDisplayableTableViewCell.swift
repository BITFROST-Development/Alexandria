//
//  HomeFileDisplayableTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class HomeFileDisplayableTableViewCell: UITableViewCell, FileDisplayableDelegate, SortingDelegate {
    
    static var identifier = "homeFileDisplayableTableViewCell"
    
    var controller: FileDisplayableControllerDelegate!
    var displayableItems: [DocumentItem]!
    var currentHomeItem: HomeItem!
    var viewSorting: String! {
        get{
            return currentHomeItem.sorting
        } set (newSorting) {
            do{
                try self.controller.realm.write({
                    self.currentHomeItem.sorting = newSorting
                })
                self.sortingTable.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.sortingTable.alpha = 0
                }){_ in
                    if self.controller.displayingTable.indexPath(for: self) != nil{
                        self.controller.displayingTable.beginUpdates()
                        self.controller.displayingTable.reloadRows(at: [self.controller.displayingTable.indexPath(for:  self)!], with: .fade)
                        self.controller.displayingTable.endUpdates()
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
                
        }
    }
    
    @IBOutlet weak var isEmptyView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var fileCollectionView: UICollectionView!
    @IBOutlet weak var displayingSectionName: UILabel!
    @IBOutlet weak var moreLabelName: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var dragDropIcon: UIImageView!
    @IBOutlet weak var sortingTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fileCollectionView.delegate = self
        fileCollectionView.dataSource = self
        fileCollectionView.register(UINib(nibName: "FileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FileCollectionViewCell.identifier)
        sortingTable.register(UINib(nibName: "SortingViewTableViewCell", bundle: nil), forCellReuseIdentifier: SortingViewTableViewCell.identifier)
        sortingTable.delegate = self
        sortingTable.dataSource = self
        sortingTable.layer.cornerRadius = 10
        sortingTable.alpha = 0
        let newPressRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cellMovementStarted(_:)))
        newPressRecognizer.delegate = self
        dragDropIcon.addGestureRecognizer(newPressRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func askingForMore(_ sender: Any) {
        
    }
    
    @IBAction func presentCreateFile(_ sender: Any) {
        controller.folderClue = nil
        controller.collectionClues = nil
        controller.pinClue = false
        controller.goalCategoryClue = nil
        if currentHomeItem.name == "Favorites"{
            controller.favoriteClue = true
        } else if currentHomeItem.name != "Recents" {
            if let collection = controller.realm.objects(FileCollection.self).filter("personalID = '\(currentHomeItem.name ?? "")'").first {
                controller.collectionClues = [collection.personalID ?? ""]
            } else if let folder = controller.realm.objects(Folder.self).filter("personalID = '\(currentHomeItem.name ?? "")'").first {
                controller.folderClue = folder.personalID
            }
        }
        controller.addButton(self)
    }
    
    @IBAction func sort(_ sender: Any) {
        sortingTable.reloadData()
        UIView.animate(withDuration: 0.3, animations: {
            self.sortingTable.alpha = 1
        })
    }
    
    @objc func cellMovementStarted(_ gesture: UIPanGestureRecognizer){
        if(gesture.state == .began){
            if let homeController = controller as? HomeViewController{
                homeController.displayingTable.dragInteractionEnabled = true
            }
        } else if gesture.state == .ended || gesture.state == .changed || gesture.state == .failed{
            if let homeController = controller as? HomeViewController{
                homeController.finishedDragging.notify(queue: .main, execute: {
                    homeController.displayingTable.dragInteractionEnabled = true
                })
            }
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension HomeFileDisplayableTableViewCell: UICollectionViewDelegate{
    
}

extension HomeFileDisplayableTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.identifier, for: indexPath) as! FileCollectionViewCell
        cell.controller = self
        cell.currentFile = displayableItems[indexPath.row]
        if let currentBook = displayableItems[indexPath.row] as? Book{
            cell.fileImage.image = UIImage(data: currentBook.thumbnail!.data!)
            cell.fileTitle.text = currentBook.name
			cell.fileImage.clipsToBounds = true
			cell.thumbnailShadow.alpha = 1
			cell.fileImage.layer.cornerRadius = 10
			cell.fileImage.clipsToBounds = true
			cell.thumbnailShadow.layer.cornerRadius = 10
			cell.thumbnailShadow.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
			let image = UIImage(data: currentBook.thumbnail!.data!)!
			let imageRatio = image.size.height / image.size.width
			let imageHeight = 150 * imageRatio
			if imageHeight > 180{
				cell.topConstraint.constant = 15
				cell.shadowWidth.constant = (180 * (image.size.width / image.size.height)) + 3
				cell.imageWidth.constant = 180 * (image.size.width / image.size.height)
			} else {
				cell.topConstraint.constant = 271 - (76 + imageHeight)
				cell.shadowHeight.constant = imageHeight + 3
				cell.imageHeight.constant = imageHeight
			}
			cell.layoutSubviews()
            var description = "Unknown"
            var newLine = false
            if currentBook.author != "" {
                description = currentBook.author!
                newLine = true
            }
            if  currentBook.year != ""{
                if newLine {
                    description += ", \(currentBook.year!)"
                } else {
                    description = currentBook.year!
                }
            }
            cell.fileData.text = description
            if currentBook.isFavorite == "True"{
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 206/255, green: 75/255, blue: 54/255, alpha: 1))
            } else {
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.45))
            }
            cell.pinnedIndicator.alpha = 0
			cell.pinnedShadow.alpha = 0
        } else if let currentNotebook = displayableItems[indexPath.row] as? Notebook{
            cell.fileImage.image = UIImage(named: currentNotebook.coverStyle!)
            cell.fileTitle.text = currentNotebook.name
			cell.thumbnailShadow.alpha = 1
			cell.shadowWidth.constant = 146
			cell.shadowHeight.constant = 183
			cell.fileImage.layer.cornerRadius = 0
			cell.imageHeight.constant = 180
			cell.imageWidth.constant = 180 * 871 / 1082
			cell.thumbnailShadow.layer.cornerRadius = 8
			cell.thumbnailShadow.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
			cell.layoutSubviews()
            var description = "Unknown"
            var newLine = false
            if currentNotebook.author != "" {
                description = currentNotebook.author!
                newLine = true
            }
            if  currentNotebook.year != ""{
                if newLine {
                    description += ", \(currentNotebook.year!)"
                } else {
                    description = currentNotebook.year!
                }
            }
            cell.fileData.text = description
            if currentNotebook.isFavorite == "True"{
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 206/255, green: 75/255, blue: 54/255, alpha: 1))
            } else {
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.45))
            }
            cell.pinnedIndicator.alpha = 0
			cell.pinnedShadow.alpha = 0
        } else if let currentSet = displayableItems[indexPath.row] as? TermSet{
			cell.thumbnailShadow.alpha = 0
			cell.fileImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
            switch currentSet.color?.colorName {
            case "Blue":
                cell.fileImage.image = UIImage(named: "cardBlue")
				break
            case "Purple":
                cell.fileImage.image = UIImage(named: "cardPurple")
				break
            case "Pink":
                cell.fileImage.image = UIImage(named: "cardPink")
				break
            case "Red":
                cell.fileImage.image = UIImage(named: "cardRed")
				break
            case "Orange":
                cell.fileImage.image = UIImage(named: "cardOrange")
				break
            case "Yellow":
                cell.fileImage.image = UIImage(named: "cardYellow")
				break
            case "Green":
                cell.fileImage.image = UIImage(named: "cardGreen")
				break
            case "Turquoise":
                cell.fileImage.image = UIImage(named: "cardTurquoise")
				break
            case "Grey":
                cell.fileImage.image = UIImage(named: "cardGrey")
				break
            case "Black":
                cell.fileImage.image = UIImage(named: "cardBlack")
				break
            default:
                print("There was an error displaying")
            }
            cell.fileTitle.text = currentSet.name
            var description = "Unknown"
            var newLine = false
            if currentSet.author != "" {
                description = currentSet.author!
                newLine = true
            }
            if  currentSet.year != ""{
                if newLine {
                    description += ", \(currentSet.year!)"
                } else {
                    description = currentSet.year!
                }
            }
            cell.fileData.text = description
            if currentSet.isFavorite == "True"{
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 206/255, green: 75/255, blue: 54/255, alpha: 1))
            } else {
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.45))
            }
            cell.pinnedIndicator.alpha = 0
			cell.pinnedShadow.alpha = 0
        } else if let currentFolder = displayableItems[indexPath.row] as? Folder{
			cell.fileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
			cell.thumbnailShadow.alpha = 0
            switch currentFolder.color?.colorName {
            case "Blue":
                cell.fileImage.image = UIImage(named: "folderIconBlue")
				break
            case "Purple":
                cell.fileImage.image = UIImage(named: "folderIconPurple")
				break
            case "Pink":
                cell.fileImage.image = UIImage(named: "folderIconPink")
				break
            case "Red":
                cell.fileImage.image = UIImage(named: "folderIconRed")
				break
            case "Orange":
                cell.fileImage.image = UIImage(named: "folderIconOrange")
				break
            case "Yellow":
                cell.fileImage.image = UIImage(named: "folderIconYellow")
				break
            case "Green":
                cell.fileImage.image = UIImage(named: "folderIconGreen")
				break
            case "Turquoise":
                cell.fileImage.image = UIImage(named: "folderIconTurquoise")
				break
            case "Grey":
                cell.fileImage.image = UIImage(named: "folderIconGrey")
				break
            case "Black":
                cell.fileImage.image = UIImage(named: "folderIconBlack")
				break
            default:
                print("There was an error displaying")
            }
            cell.fileTitle.text = currentFolder.name
            cell.fileData.text = "\(currentFolder.childrenIDs.count) items"
            if currentFolder.isFavorite == "True"{
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 206/255, green: 75/255, blue: 54/255, alpha: 1))
            } else {
                cell.favoriteIndicator.tintColor = UIColor(cgColor: CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.45))
            }
            if controller.realm.objects(AlexandriaData.self).filter({($0).home.filter("name = '\(currentFolder.personalID!)'").count > 0}).count > 0 {
                cell.pinnedIndicator.tintColor = UIColor(cgColor: CGColor(red: 206/255, green: 75/255, blue: 54/255, alpha: 1))
            } else {
                cell.pinnedIndicator.tintColor = UIColor(cgColor: CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.45))
            }
        }
        return cell
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		fileCollectionView.reloadData()
	}
    
}

extension HomeFileDisplayableTableViewCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewSorting = (tableView.cellForRow(at: indexPath) as! SortingViewTableViewCell).currentSortKind
		tableView.deselectRow(at: indexPath, animated: true)
        (tableView.cellForRow(at: indexPath) as! SortingViewTableViewCell).setSelected(false, animated: true)
    }
}

extension HomeFileDisplayableTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortingViewTableViewCell.identifier, for: indexPath) as! SortingViewTableViewCell
        cell.controller = self
        if indexPath.row == 0{
            cell.currentSortKind = "Ascending"
            cell.sortingKindLabel.text = "Ascending"
            cell.sortIcon.image = UIImage(systemName: "a.square.fill")
            if viewSorting == "Ascending"{
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 111/255, green: 191/255, blue: 218/255, alpha: 1))
            } else {
                cell.selectedMarker.alpha = 0
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            }
        } else if indexPath.row == 1{
            cell.currentSortKind = "Descending"
            cell.sortingKindLabel.text = "Descending"
            cell.sortIcon.image = UIImage(systemName: "z.square.fill")
            if viewSorting == "Descending"{
//                cell.selectedMarker.alpha = 1
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 111/255, green: 191/255, blue: 218/255, alpha: 1))
            } else {
                cell.selectedMarker.alpha = 0
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            }
        } else if indexPath.row == 2{
            cell.currentSortKind = "Last Modified"
            cell.sortingKindLabel.text = "Last Modified"
            cell.sortIcon.image = UIImage(systemName: "calendar")
            if viewSorting == "Last Modified"{
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 111/255, green: 191/255, blue: 218/255, alpha: 1))
            } else {
                cell.selectedMarker.alpha = 0
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            }
        } else{
            cell.currentSortKind = "Last Opened"
            cell.sortingKindLabel.text = "Last Opened"
            cell.sortIcon.image = UIImage(systemName: "clock.fill")
            cell.separator.alpha = 0
            if viewSorting == "Last Opened"{
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 111/255, green: 191/255, blue: 218/255, alpha: 1))
            } else {
                cell.selectedMarker.alpha = 0
                cell.contentView.backgroundColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            }
        }
        return cell
    }
    
    
}

