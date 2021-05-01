////
////  MyShelvesPreferencesManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/20/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class MyShelvesPreferencesManager: UIView {
//    let realm = try! Realm(configuration: AppDelegate.realmConfig)
//    var currentShelf: Shelf? {
//        get{
//            if viewController?.selectedShelfIndex == -1{
//                return nil
//            } else if viewController?.cloudShelf ?? false{
//                return realm.objects(AlexandriaData.self)[0].shelves[viewController?.selectedShelfIndex ?? 0]
//            } else {
//                return realm.objects(AlexandriaData.self)[0].localShelves[viewController?.selectedShelfIndex ?? 0]
//            }
//        }
//    }
//    var viewController: MyShelvesViewController?
//    var loggedIn = false
//}
//
//extension MyShelvesPreferencesManager: UITableViewDelegate{
//    
//}
//
//extension MyShelvesPreferencesManager: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: ShelfPrePreferencesCell.identifier) as! ShelfPrePreferencesCell
//        cell.controller = viewController
//        cell.currentShelf = currentShelf
//        cell.cloudVar = (viewController?.cloudShelf ?? false)
//        if indexPath.row == 0 {
//            cell.actionButton.setTitle("Edit Shelf", for: .normal)
//            cell.actionButton.setImage(UIImage(systemName: "hammer.fill"), for: .normal)
//            cell.separatorView.alpha = 0
//            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 225/255, green: 173/255, blue: 169/255, alpha: 1))
//        } else {
//            cell.actionButton.setTitle("Delete Shelf", for: .normal)
//            cell.actionButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
//            cell.separatorView.alpha = 0.0
//            cell.actionButton.imageEdgeInsets.left = 20
//            cell.actionButton.titleEdgeInsets.left = 30
//            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 164/255, green: 204/255, blue: 218/255, alpha: 1))
//        }
//        return cell
//    }
//    
//    
//}
//
