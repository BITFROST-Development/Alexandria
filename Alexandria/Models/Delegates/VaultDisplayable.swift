//
//  VaultDisplayable.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/21/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol VaultDisplayable {
    var name: String? {get set}
    
}

protocol VaultRelated: Object {}
