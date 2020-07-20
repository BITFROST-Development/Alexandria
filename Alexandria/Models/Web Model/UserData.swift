//
//  UserData.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/24/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

struct UserData: Codable{
    let name: String?
    let lastName: String?
    let username: String?
    let email: String?
    let subscription: String?
    let daysLeftOnSubscription: Int?
    let subscriptionStatus: String?
    let googleAccountEmail: String?
    let teamIDs: [Double]?
    let alexandria: AlexandriaDataDec?
    let gigantic: GiganticDataDec?
}

struct AlexandriaDataDec: Codable{
    
    static func == (lhs: AlexandriaDataDec, rhs: AlexandriaDataDec) -> Bool {
        if lhs.rootFolderID == rhs.rootFolderID && lhs.goals == rhs.goals && lhs.trophies == rhs.trophies && lhs.vaults == rhs.vaults && lhs.shelves == rhs.shelves{
            return true
        }
        
        return false
    }
    
    var rootFolderID: String?
    var booksFolderID: String?
    var goals: [GoalDec]?
    var trophies: [TrophyDec]?
    var vaults: [VaultDec]?
    var shelves: [ShelfDec]?
}

struct GoalDec: Codable, Equatable{
    var birthName: String?
    var name: String?
    var achieved: String?
    var progress: Double?
    var theme: String?
}

struct TrophyDec: Codable, Equatable{
    var name: String?
    var earned: String?
    var progress:Double?
    var theme: String?
}

struct ShelfDec: Codable, Equatable{
    var birthName: String?
    var name: String?
    var books: [BookDec]?
}

struct VaultDec: Codable, Equatable{
    var vaultFolderID: String?
    var birthName: String?
    var name: String?
    var terms: [TermDec]?
}

struct TermDec: Codable,Equatable{
    var type: String?
    var content: String?
    var location: String?
}

struct StoredFileDec: Codable, Equatable{
    
    var name: String?
    var data: Data?
    var contentType: String?
    
    init (_ label: String,_ file: Data,_ type: String) {
        name = label
        data = file
        contentType = type
    }
}

struct BookDec: Codable, Equatable{
    var id: String?
    var title: String?
    var author: String?
    var year: String?
    var thumbnail: StoredFileDec?
}

struct GiganticDataDec: Codable{
    var avatar: StoredFileDec?
}

