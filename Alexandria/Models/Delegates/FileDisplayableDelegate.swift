//
//  FileDisplayableDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/20/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol FileDisplayableDelegate {
    var controller: FileDisplayableControllerDelegate! {get set}
}

protocol FileDisplayableControllerDelegate {
    var realm: Realm {get set}
    var displayingTable: UITableView! {get set}
    var folderClue: String? {get set}
    var collectionClues: [String]? {get set}
    var pinClue: Bool? {get set}
    var favoriteClue: Bool? {get set}
    var goalCategoryClue: String? {get set}
    var addItemKindSelected: String! {get set}
    func addButton(_ sender: Any)
	func openItem(_ item: DocumentItem)
}

