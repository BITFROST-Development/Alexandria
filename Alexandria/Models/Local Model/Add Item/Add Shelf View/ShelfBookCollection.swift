//
//  ShelfBookCollection.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/21/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class ShelfBookCollection: UITableViewCell {
    
    static var identifier = "shelfBookCollection"
    
    let realm = AppDelegate.realm
    var cloudBooksInCollection: [Double] = []
    var localBooksInCollection: [Double] = []
    @IBOutlet var bookCollection: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookCollection.delegate = self
        bookCollection.dataSource = self
        bookCollection.register(UINib(nibName: "ShelfBookCollectionCell", bundle: nil), forCellWithReuseIdentifier: ShelfBookCollectionCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ShelfBookCollection: UICollectionViewDelegate{
    
    
    
}

extension ShelfBookCollection: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cloudBooksInCollection.count + localBooksInCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < cloudBooksInCollection.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfBookCollectionCell.identifier, for: indexPath) as! ShelfBookCollectionCell
            cell.bookIndex = indexPath.row
            cell.isCloud = true
            cell.controller = self
            cell.bookImage.setImage(UIImage(data: realm!.objects(AlexandriaData.self)[0].cloudBooks[Int(cloudBooksInCollection[indexPath.row])].thumbnail!.data!), for: .normal)
            cell.bookTitle.text = realm!.objects(AlexandriaData.self)[0].cloudBooks[Int(cloudBooksInCollection[indexPath.row])].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfBookCollectionCell.identifier, for: indexPath) as! ShelfBookCollectionCell
            cell.bookIndex = indexPath.row - cloudBooksInCollection.count
            cell.controller = self
            cell.bookImage.setImage(UIImage(data: realm!.objects(AlexandriaData.self)[0].localBooks[Int(localBooksInCollection[indexPath.row - cloudBooksInCollection.count])].thumbnail!.data!), for: .normal)
            cell.bookTitle.text = realm!.objects(AlexandriaData.self)[0].localBooks[Int(localBooksInCollection[indexPath.row - cloudBooksInCollection.count])].name
            return cell
        }
    }
}
