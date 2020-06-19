//
//  UnloggedUser.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/25/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

class UnloggedUser: Object {
    @objc dynamic var alexandriaData = AlexandriaData()
}

class UnloggedUserObject{
    let realm = try! Realm()
    var currentUserWrap: Results<UnloggedUser>!
    var currentUser: UnloggedUser?
    init(){
        currentUserWrap = realm.objects(UnloggedUser.self)
        currentUser = currentUserWrap[0]
    }
}
