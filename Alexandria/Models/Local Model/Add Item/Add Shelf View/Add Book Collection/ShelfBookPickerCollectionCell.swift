//
//  ShelfBookCollectionCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/27/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ShelfBookPickerCollectionCell: UICollectionViewCell {
    
    static var identifier = "shelfBookPickerCollectionCell"
    
    var controller: BookCollectionViewControler!
    var isCloud = true
    var bookIndexInContext: Double!
    var isSelectedBook = false
    
    @IBOutlet weak var bookImage: UIButton!
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var bookShadow: UIView!
    @IBOutlet var addDeleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookImage.imageView?.layer.cornerRadius = 6
        bookShadow.layer.cornerRadius = 6
    }
    
    @IBAction func addBookToShelf(_ sender: Any) {
        if isSelectedBook{
            addRemoveAction(false)
        } else {
            addRemoveAction(true)
        }
    }
    
    @IBAction func imageClickEvent(_ sender: Any) {
        if isSelectedBook{
            addRemoveAction(false)
        } else {
            addRemoveAction(true)
        }
    }
    
    func addRemoveAction(_ add: Bool){
        if add {
            let baseImage = UIImage(systemName: "xmark.circle.fill")
            let imageToSet = baseImage?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
            addDeleteButton.setImage(imageToSet, for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.bookShadow.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 0.6))
            })
            isSelectedBook = true
            var newBookList: [Double] = []
            if isCloud {
                if controller.selectedCloudBooks.count != 0{
                    var shouldAppend = true
                    for book in controller.selectedCloudBooks{
                        if book > bookIndexInContext{
                            newBookList.append(bookIndexInContext)
                            newBookList.append(book)
                            shouldAppend = false
                        } else {
                            newBookList.append(book)
                        }
                    }
                    if shouldAppend{
                        newBookList.append(bookIndexInContext)
                    }
                } else {
                    newBookList.append(bookIndexInContext)
                }
                controller.selectedCloudBooks = newBookList
            } else {
                if controller.selectedLocalBooks.count != 0{
                    var shouldAppend = true
                    for book in controller.selectedLocalBooks{
                        if shouldAppend && book > bookIndexInContext{
                            newBookList.append(bookIndexInContext)
                            newBookList.append(book)
                            shouldAppend = false
                        } else {
                            newBookList.append(book)
                        }
                    }
                    if shouldAppend {
                        newBookList.append(bookIndexInContext)
                    }
                } else {
                    newBookList.append(bookIndexInContext)
                }
                controller.selectedLocalBooks = newBookList
            }
        } else {
            let baseImage = UIImage(systemName: "plus.circle.fill")
            let imageToSet = baseImage?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
            addDeleteButton.setImage(imageToSet, for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.bookShadow.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 77/255, green: 77/255, blue: 77/255, alpha: 0.08))
            })
            isSelectedBook = false
            var newBookList: [Double] = []
            if isCloud{
                for book in controller.selectedCloudBooks{
                    if book == bookIndexInContext{
                        continue
                    }
                    newBookList.append(book)
                }
                controller.selectedCloudBooks = newBookList
            } else {
                for book in controller.selectedLocalBooks{
                    if book == bookIndexInContext{
                        continue
                    }
                    newBookList.append(book)
                }
                controller.selectedLocalBooks = newBookList
            }
        }
    }
    
}
