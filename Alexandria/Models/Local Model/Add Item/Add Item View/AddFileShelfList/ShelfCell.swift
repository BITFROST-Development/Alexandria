////
////  ShelfCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/22/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class ShelfCell: UITableViewCell {
//    
//    static var identifier = "shelfCellIdentifier"
//    
//    var controller: ShelfListViewController!
//    var storedShelf: Shelf!
//    var indexOfShelf = 0
//    var isSelectedShelf = false
//    
//    let realm = try! Realm(configuration: AppDelegate.realmConfig)
//    
//    @IBOutlet var shelfSelectableCell: UIButton!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(false, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//    
//    @IBAction func shelfSelectEvent(_ sender: Any) {
//        if isSelectedShelf{
//            shelfSelectableCell.setTitleColor(.black, for: .normal)
//            shelfSelectableCell.tintColor = .black
//            shelfSelectableCell.setImage(UIImage(systemName: "circle"), for: .normal)
//            var newShelfList: [Shelf] = []
//            for shelf in controller.selectedShelves {
//                if shelf == storedShelf {
//                    continue
//                }
//                newShelfList.append(shelf)
//            }
//            isSelectedShelf = false
//            controller.updateArray(newShelfList)
//        } else {
//            shelfSelectableCell.setTitleColor(UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1)), for: .normal)
//            shelfSelectableCell.tintColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
//            shelfSelectableCell.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//            var newShelfList: [Shelf] = []
//            var shouldContinueChecking = true
//            var startingIndex = 0
//            var divisionIndex = 0
//            let storedCloudShelves = realm.objects(AlexandriaData.self)[0].shelves
//            let storedLocalShelves = realm.objects(AlexandriaData.self)[0].localShelves
//            if indexOfShelf == 0 && (storedShelf.cloudVar.value ?? false){
//                newShelfList.append(storedShelf)
//                shouldContinueChecking = false
//            }
//            if storedShelf.cloudVar.value ?? false {
//                for shelf in controller.selectedShelves {
//                    if (shelf.cloudVar.value ?? false) && shouldContinueChecking{
//                        for index in startingIndex..<storedCloudShelves.count{
//                            if Shelf.equals(shelf, storedCloudShelves[index]){
//                                if index > indexOfShelf{
//                                    newShelfList.append(storedShelf)
//                                    shouldContinueChecking = false
//                                }
//                                newShelfList.append(shelf)
//                                startingIndex = index
//                                break
//                            }
//                        }
//                    } else if shouldContinueChecking {
//                        newShelfList.append(storedShelf)
//                        break
//                    }
//                    newShelfList.append(shelf)
//                    divisionIndex += 1
//                }
//            } else {
//                startingIndex = 0
//                shouldContinueChecking = true
//                for index in startingIndex...controller.selectedShelves.count {
//                    if (index < controller.selectedShelves.count) && shouldContinueChecking{
//                        let shelf = controller.selectedShelves[index]
//                        for kindex in startingIndex..<storedLocalShelves.count{
//                            if Shelf.equals(shelf, storedLocalShelves[kindex]){
//                                if kindex > indexOfShelf{
//                                    newShelfList.append(storedShelf)
//                                    shouldContinueChecking = false
//                                }
//                                newShelfList.append(shelf)
//                                startingIndex = kindex
//                                break
//                            }
//                        }
//                    } else {
//                        newShelfList.append(storedShelf)
//                        break
//                    }
//                    let shelf = controller.selectedShelves[index]
//                    newShelfList.append(shelf)
//                }
//            }
//            isSelectedShelf = true
//            controller.updateArray(newShelfList)
//        }
//    }
//    
//    
//}
