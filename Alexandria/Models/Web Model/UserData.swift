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
    var rootFolderID: String?
    var booksFolderID: String?
    var goals: [GoalDec]?
    var trophies: [TrophyDec]?
    var vaults: [VaultDec]?
    var shelves: [ShelfDec]?
    var books: [BookDec]?
    
    init(){}
    
    init(_ forCloud: Bool){
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let user = realm.objects(CloudUser.self)[0]
        
        rootFolderID = user.alexandriaData?.rootFolderID
        booksFolderID = user.alexandriaData?.booksFolderID
        goals = []
        trophies = []
        vaults = []
        shelves = []
        books = []
        for goal in user.alexandriaData!.goals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandriaData!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
        
        for vault in user.alexandriaData!.vaults{
            if vault.cloudVar.value == true{
                vaults?.append(VaultDec(storedVault: vault))
            }
        }
        
        for shelf in user.alexandriaData!.shelves{
            shelves?.append(ShelfDec(shelf))
        }
        
        for book in user.alexandriaData!.cloudBooks{
            books?.append(BookDec(storedBook: book))
        }
    }
    
    init(from user: CloudUser) {
        rootFolderID = user.alexandriaData?.rootFolderID
        booksFolderID = user.alexandriaData?.booksFolderID
        goals = []
        trophies = []
        vaults = []
        shelves = []
        books = []
        for goal in user.alexandriaData!.goals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandriaData!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
        
        for vault in user.alexandriaData!.vaults{
            if vault.cloudVar.value == true{
                vaults?.append(VaultDec(storedVault: vault))
            }
        }
        
        for shelf in user.alexandriaData!.shelves{
            if shelf.cloudVar.value == true {
                shelves?.append(ShelfDec(shelf))
            }
        }
        
        for book in user.alexandriaData!.cloudBooks{
            if book.cloudVar.value == true{
                books?.append(BookDec(storedBook: book))
            }
        }
    }
    
    static func == (lhs: AlexandriaDataDec, rhs: AlexandriaDataDec) -> Bool {
        if lhs.rootFolderID == rhs.rootFolderID && lhs.goals == rhs.goals && lhs.trophies == rhs.trophies && lhs.vaults == rhs.vaults && lhs.shelves == rhs.shelves{
            return true
        }
        
        return false
    }
    
}

struct GoalDec: Codable, Equatable{
    var birthName: String?
    var name: String?
    var achieved: String?
    var progress: Double?
    var theme: String?
    
    init(){}
    
    init(storedGoal: Goal){
        birthName = storedGoal.birthName
        name = storedGoal.name
        achieved = storedGoal.achieved
        progress = storedGoal.progress.value
        theme = storedGoal.theme
    }
}

struct TrophyDec: Codable, Equatable{
    var name: String?
    var earned: String?
    var progress:Double?
    var theme: String?
    
    init() {}
    
    init(storedTrophy: Trophy){
        name = storedTrophy.name
        earned = storedTrophy.earned
        progress = storedTrophy.progress.value
        theme = storedTrophy.theme
    }
}

struct ShelfDec: Codable, Equatable{
    var birthName: String?
    var name: String?
    var books: [Double]?
    
    init(){}
    init(_ storedShelf: Shelf){
        birthName = storedShelf.birthName
        name = storedShelf.name
        books = []
        for index in 0..<storedShelf.books.count {
            books?.append(Double(index))
        }
    }
}

struct VaultDec: Codable, Equatable{
    var vaultFolderID: String?
    var parentFolderID: String?
    var childrenFolderIDs: [String]?
    var birthName: String?
    var name: String?
    var terms: [TermDec]?
    var notes: [NoteDec]?
    
    init(){}
    
    init(storedVault: Vault){
        vaultFolderID = storedVault.vaultFolderID
        birthName = storedVault.birthName
        name = storedVault.name
        terms = []
        for term in storedVault.terms{
            terms?.append(TermDec(storedTerm: term))
        }
        notes = []
        for note in storedVault.notes{
            notes?.append(NoteDec(storedNote: note))
        }
    }
}

struct NoteDec: Codable, Equatable{
    var id: String?
    var title: String?
    var lastUpdated: Date?
    var thumbnail: StoredFileDec?
    
    init(){}
    
    init(storedNote: Note){
        self.id = storedNote.id
        self.title = storedNote.title
        self.lastUpdated = storedNote.lastUpdated
        self.thumbnail = StoredFileDec(storedNote.thumbnail!.name!, storedNote.thumbnail!.data!, storedNote.thumbnail!.contentType!)
    }
}

struct TermDec: Codable,Equatable{
    var type: String?
    var content: String?
    var location: String?
    
    init() {}
    
    init(storedTerm: Term){
        type = storedTerm.type
        content = storedTerm.content
        location = storedTerm.location
    }
}

struct StoredFileDec: Codable, Equatable{
    
    var name: String?
    var data: BufferDec?
    var contentType: String?
    
    init(){}
    
    init (_ label: String,_ file: Data,_ type: String) {
        name = label
        data = BufferDec("Buffer", file)
        contentType = type
    }
}

struct BufferDec: Codable, Equatable{
    static func == (lhs: BufferDec, rhs: BufferDec) -> Bool {
        if lhs.type == rhs.type && lhs.data == rhs.data{
            return true
        }
        return false
    }
    
    init (_ kind: String, _ info: Data){
        self.type = kind
        self.data = [UInt8](info)
    }
    
    var type: String?
    var data: [UInt8]?
}

struct BookDec: Codable, Equatable{
    var driveID: String?
    var title: String?
    var author: String?
    var year: String?
    var thumbnail: StoredFileDec?
    
    init (){}
    
    init (storedBook: Book){
        author = storedBook.author
        driveID = storedBook.id
        title = storedBook.title
        year = storedBook.year
        thumbnail = StoredFileDec(storedBook.thumbnail!.name!, storedBook.thumbnail!.data!, storedBook.thumbnail!.contentType!)
    }
}

struct GiganticDataDec: Codable{
    var avatar: StoredFileDec?
}

