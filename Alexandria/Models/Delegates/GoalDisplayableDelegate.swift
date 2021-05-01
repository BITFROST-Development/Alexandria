//
//  GoalDisplayableDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/21/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol GoalDisplayableDelegate {
    var controller: GoalDisplayableControllerDelegate! {get set}
}

protocol GoalDisplayableControllerDelegate {
    var realm: Realm {get set}
    var displayingTable: UITableView! {get set}
}
