//
//  ShelfBookCollectionCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/21/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ShelfBookCollectionCell: UICollectionViewCell {
    
    static var identifier = "shelfBookCollectionCell"
    
    var bookIndex = 0
    var controller:ShelfBookCollection!
    var isCloud = false
    @IBOutlet var bookImage: UIButton!
    @IBOutlet var bookShadow: UIView!
    @IBOutlet var bookTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookImage.imageView?.layer.cornerRadius = 6
        bookImage.imageView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        bookShadow.layer.cornerRadius = 6
        bookShadow.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func removeBook(_ sender: Any) {
        if self.isCloud{
            var newArray:[Double] = []
            
            for index in 0..<self.controller.cloudBooksInCollection.count{
                if index == self.bookIndex{
                    continue
                }
                newArray.append(self.controller.cloudBooksInCollection[index])
            }
            
            self.controller.cloudBooksInCollection = newArray
        } else {
            var newArray:[Double] = []
            
            for index in 0..<self.controller.localBooksInCollection.count{
                if index == self.bookIndex{
                    continue
                }
                newArray.append(self.controller.localBooksInCollection[index])
            }
            
            self.controller.localBooksInCollection = newArray
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }){ _ in
            self.controller.bookCollection.deleteItems(at: [self.controller.bookCollection.indexPath(for: self)!])
        }
    }
    
}
