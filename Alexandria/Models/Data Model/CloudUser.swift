//
//  Data.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/24/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

class CloudUser: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var subscription: String = ""
    @objc dynamic var subscriptionStatus: String = ""
    var daysLeftOnSubscription = RealmOptional<Int>()
    @objc dynamic var googleAccountEmail: String = ""
	var friendList = RealmSwift.List<Friend>()
    var teamIDs = RealmSwift.List<ListWrapperForString>()
    @objc dynamic var alexandria:AlexandriaData? = AlexandriaData()
    @objc dynamic var gigantic: GiganticData?
}

class CloudUserObject{
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var currentUserWrap: Results<CloudUser>!
    var currentUser: CloudUser?
    init(){
        currentUserWrap = realm.objects(CloudUser.self)
        currentUser = currentUserWrap[0]
    }
}
