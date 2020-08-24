//
//  ItemChangerDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

protocol ItemChangerDelegate: UIViewController {
    var toDrive: Bool{ get set}
    var fileShouldBeMoved: Bool{get set}
    var updating: Bool{get set}
    var finalFileName: String!{get set}
}
