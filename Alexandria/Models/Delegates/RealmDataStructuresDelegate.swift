//
//  RealmDataStructuresDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/3/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol DocumentItem: Object {
    dynamic var personalID: String? {get set}
    dynamic var name: String? {get set}
}

protocol FolderItem: DocumentItem {
    dynamic var lastModified: Date? {get set}
}

protocol FileItem: FolderItem {
    dynamic var lastOpened: Date? {get set}
	dynamic var collectionIDs: RealmSwift.List<ItemIDWrapper>{get set}
	dynamic var personalCollectionID: String? {get set}
}

protocol NonDocumentItem: Object {
    dynamic var personalID: String? {get set}
}
