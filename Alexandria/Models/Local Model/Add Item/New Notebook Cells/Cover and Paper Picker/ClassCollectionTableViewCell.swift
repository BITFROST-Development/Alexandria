//
//  ClassCollectionTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 10/2/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class ClassCollectionTableViewCell: UITableViewCell {
    
    
    static var identifier = "classCollectionTableViewCell"
    var controller: PaperStylePickerViewController!
    var selectedOrientation: String!
    var imagesToDisplay: [UIImage]!
    var namesToDisplay: [String]!
    var currentGroup: String!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ClassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ClassCollectionTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCollectionViewCell.identifier, for: indexPath) as! ClassCollectionViewCell
        cell.currentCell = indexPath.row
        cell.controller = controller
        cell.itemImage.image = imagesToDisplay[indexPath.row]
        cell.currentGroup = currentGroup
        cell.paperName.text = namesToDisplay[indexPath.row]
        
        if selectedOrientation == "Portrait"{
            cell.heightConstraint.constant = 160
            cell.widthConstraint.constant = 127.59
        } else {
            cell.widthConstraint.constant = 160
            cell.heightConstraint.constant = 127.59
        }
        
        if currentGroup == controller.selectedGroup && indexPath.row == controller.selectedCellImage{
            cell.backgroundSelectedView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 0.7))
            controller.selectedCell = cell
        } else {
            cell.backgroundSelectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
        }
        
        return cell
    }
    
    
}

extension ClassCollectionTableViewCell: UICollectionViewDelegate{
    override func prepareForReuse() {
        collectionView.reloadData()
    }
}
