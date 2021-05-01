////
////  ShelfPrePreferencesCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/20/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class ShelfPrePreferencesCell: UITableViewCell {
//    
//    static var identifier = "shelfPrePreferences"
//    
//    var controller: MyShelvesViewController!
//    var currentShelf: Shelf?
//    var cloudVar: Bool!
//    @IBOutlet weak var actionButton: UIButton!
//    @IBOutlet weak var separatorView: UIView!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    @IBAction func actionPressed(_ sender: Any) {
//        if actionButton.currentTitle == "Edit Shelf"{
//            controller.dismissView()
//            controller.currentShelf = currentShelf
//            controller.performSegue(withIdentifier: "toShelfPreferences", sender: controller)
//        } else {
//            let realm = AppDelegate.realm!
//            let hashTables = realm.objects(BookToListMap.self)
//            do {
//                try realm.write({
//                    for book in currentShelf!.books {
//                        if cloudVar {
//                            for index in 0..<hashTables[1].keys[Int(book)].values.count {
//                                if Shelf.equals(hashTables[1].keys[Int(book)].values[index].value!, currentShelf!){
//                                    hashTables[1].keys[Int(book)].values.remove(at: index)
//                                }
//                            }
//                        } else {
//                            for index in 0..<hashTables[0].keys[Int(book)].values.count {
//                                if Shelf.equals(hashTables[0].keys[Int(book)].values[index].value!, currentShelf!){
//                                    hashTables[0].keys[Int(book)].values.remove(at: index)
//                                }
//                            }
//                        }
//                    }
//                    for book in currentShelf!.oppositeBooks {
//                        if !cloudVar {
//                            for index in 0..<hashTables[1].keys[Int(book)].values.count {
//                                if Shelf.equals(hashTables[1].keys[Int(book)].values[index].value!, currentShelf!){
//                                    hashTables[1].keys[Int(book)].values.remove(at: index)
//                                }
//                            }
//                        } else {
//                            for index in 0..<hashTables[0].keys[Int(book)].values.count {
//                                if Shelf.equals(hashTables[0].keys[Int(book)].values[index].value!, currentShelf!){
//                                    hashTables[0].keys[Int(book)].values.remove(at: index)
//                                }
//                            }
//                        }
//                    }
//                    realm.delete(currentShelf!)
//                })
//            } catch let error {
//                print(error.localizedDescription)
//            }
//            controller?.shelfName.setTitle("All my books", for: .normal)
//            controller?.cloudShelf = false
//            controller?.shelfCollectionView.reloadData()
//            controller?.dismissView()
//        }
//    }
//    
//}
