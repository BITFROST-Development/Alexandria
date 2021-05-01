//
//  ItemChangerDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol InlinePickerItem: Object {
	dynamic var personalID: String? {get set}
    dynamic var name: String? {get set}
}

protocol InlinePickerDelegate {
    var realm: Realm {get}
	func needs(_ space: CGFloat)
	func itemsUpdated(_ items: [InlinePickerItem])
}

