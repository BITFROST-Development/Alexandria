//
//  BookChangerDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/31/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

protocol BookChangerDelegate: UIViewController{
    var toDrive: Bool{ get set}
    var fileShouldBeMoved: Bool{get set}
    var author: String!{get set}
    var year: String!{get set}
    var updating: Bool{get set}
    var finalFileName: String!{get set}
}
