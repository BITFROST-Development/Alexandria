//
//  Team.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/24/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

class Team: Object, InlinePickerItem {
    @objc dynamic var personalID: String?
    @objc dynamic var name: String?
    var memberNames = RealmSwift.List<ListWrapperForString>()
    var memberUsernames = RealmSwift.List<ListWrapperForString>()
    var messages = RealmSwift.List<TeamMessage>()
    var sharedFileIDs = RealmSwift.List<ListWrapperForString>()
    var sharedGoalIDs = RealmSwift.List<ListWrapperForString>()
    @objc dynamic var teamIcon: StoredFile?
    @objc dynamic var isFavorite:String?
}

class TeamMessage: Object {
    @objc dynamic var senderName: String = ""
    @objc dynamic var senderUsername: String = ""
    @objc dynamic var message: String = ""
    var membersAware = RealmSwift.List<ListWrapperForString>()
    @objc dynamic var timeSent: Date?
}

class Friend: Object, InlinePickerItem{
	@objc dynamic var personalID: String?
	@objc dynamic var name: String?
	
	convenience init(_ decFriend: FriendDec) {
		self.init()
		personalID = decFriend.personalID
		name = decFriend.name
	}
	
	static func != (_ lhs: Friend, _ rhs: FriendDec) -> Bool{
		if lhs.personalID != rhs.personalID || lhs.name != rhs.name{
			return true
		}
		return false
	}
}

class TeamObject{
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var teamWrap: Results<Team>!
    var team: Team?
    init(){
        teamWrap = realm.objects(Team.self)
        team = teamWrap[0]
    }
}


