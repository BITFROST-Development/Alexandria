//
//  TeamDisplayableDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/19/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol TeamDisplayableDelegate {
    var controller: TeamDisplayableControllerDelegate! {get set}
}

protocol TeamDisplayableControllerDelegate {
    var realm: Realm {get set}
    var displayingTable: UITableView! {get set}
}
