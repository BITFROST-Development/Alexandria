//
//  ShelveListCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/5/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class ShelfListCell: UITableViewCell {

    static var identifier = "shelfListCell"
    var cloudVar = false
    var controller: MyShelvesViewController?
    var widthConstraint: NSLayoutConstraint!
    var currentShelf: Shelf?{
        get{
            let realm = AppDelegate.realm
            if cloudVar {
                for shelf in realm!.objects(AlexandriaData.self)[0].shelves{
                    if shelf.name! == shelfName.text {
                        return shelf
                    }
                }
            } else {
                for shelf in realm!.objects(AlexandriaData.self)[0].localShelves{
                    if shelf.name! == shelfName.text {
                        return shelf
                    }
                }
            }
            return nil
        }
    }
    @IBOutlet weak var shelfName: UILabel!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        widthConstraint = shelfName.widthAnchor.constraint(equalToConstant: layer.frame.width - 32)
        widthConstraint.isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shelfInfo(_ sender: Any) {
        controller?.dismissView()
        controller?.currentShelf = currentShelf
        controller?.performSegue(withIdentifier: "toShelfPreferences", sender: controller)
    }
    
    @IBAction func deleteShelf(_ sender: Any) {
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let hashTables = realm.objects(BookToListMap.self)
        do {
            try realm.write({
                for book in currentShelf!.books {
                    if cloudVar {
                        for index in 0..<hashTables[1].keys[Int(book)].values.count {
                            if Shelf.equals(hashTables[1].keys[Int(book)].values[index].value!, currentShelf!){
                                hashTables[1].keys[Int(book)].values.remove(at: index)
                            }
                        }
                    } else {
                        for index in 0..<hashTables[0].keys[Int(book)].values.count {
                            if Shelf.equals(hashTables[0].keys[Int(book)].values[index].value!, currentShelf!){
                                hashTables[0].keys[Int(book)].values.remove(at: index)
                            }
                        }
                    }
                }
                for book in currentShelf!.oppositeBooks {
                    if !cloudVar {
                        for index in 0..<hashTables[1].keys[Int(book)].values.count {
                            if Shelf.equals(hashTables[1].keys[Int(book)].values[index].value!, currentShelf!){
                                hashTables[1].keys[Int(book)].values.remove(at: index)
                            }
                        }
                    } else {
                        for index in 0..<hashTables[0].keys[Int(book)].values.count {
                            if Shelf.equals(hashTables[0].keys[Int(book)].values[index].value!, currentShelf!){
                                hashTables[0].keys[Int(book)].values.remove(at: index)
                            }
                        }
                    }
                }
                realm.delete(currentShelf!)
            })
        } catch let error {
            print(error.localizedDescription)
        }
        controller?.shelfName.setTitle("All my books", for: .normal)
        controller?.cloudShelf = false
        controller?.shelfCollectionView.reloadData()
        controller?.dismissView()
    }
    
    
}
