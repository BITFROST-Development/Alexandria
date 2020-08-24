//
//  BookChangerDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/31/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

protocol BookChangerDelegate: ItemChangerDelegate{
    var author: String!{get set}
    var year: String!{get set}
}
