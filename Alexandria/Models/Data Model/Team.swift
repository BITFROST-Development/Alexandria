//
//  Team.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/24/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

class Team: Object {
    @objc dynamic var id: Double = 0.0
    @objc dynamic var name: String = ""
    var memberNames = RealmSwift.List<String?>()
    var memberUsernames = RealmSwift.List<String?>()
    var messages = RealmSwift.List<TeamMessage>()
}

class TeamMessage: Object {
    var senderName: String = ""
    var senderUsername: String = ""
    var message: String = ""
    var timeSent: Date?
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
