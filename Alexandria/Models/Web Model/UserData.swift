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
    var defaultPaperStyle: String?
    var defaultPaperOrientation: String?
    var defaultCoverStyle: String?
    var defaultPaperColor: String?
    var defaultWritingToolThickness01: Double?
    var defaultWritingToolThickness02: Double?
    var defaultWritingToolThickness03: Double?
    var defaultWritingToolColor01: IconColorDec?
    var defaultWritingToolColor02: IconColorDec?
    var defaultWritingToolColor03: IconColorDec?
    var defaultEraserToolThickness01: Double?
    var defaultEraserToolThickness02: Double?
    var defaultEraserToolThickness03: Double?
    var defaultHighlighterToolThickness01: Double?
    var defaultHighlighterToolThickness02: Double?
    var defaultHighlighterToolThickness03: Double?
    var defaultHighlighterToolColor01: IconColorDec?
    var defaultHighlighterToolColor02: IconColorDec?
    var defaultHighlighterToolColor03: IconColorDec?
    var defaultTextToolFont: Double?
    var goals: [GoalDec]?
    var trophies: [TrophyDec]?
    var vaultDivisionPoints: [Double]?
    var vaultMaps: [VaultMapDec]?
    var vaults: [VaultDec]?
    var shelves: [ShelfDec]?
    var books: [BookDec]?
    
    init(){}
    
    init(_ forCloud: Bool){
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let user = realm.objects(CloudUser.self)[0]
        
        rootFolderID = user.alexandriaData?.rootFolderID
        booksFolderID = user.alexandriaData?.booksFolderID
        defaultPaperStyle = user.alexandriaData?.defaultPaperStyle
        defaultCoverStyle = user.alexandriaData?.defaultCoverStyle
        defaultPaperColor = user.alexandriaData?.defaultPaperColor
        defaultPaperOrientation = user.alexandriaData?.defaultPaperOrientation
        defaultWritingToolThickness01 = user.alexandriaData!.defaultWritingToolThickness01.value
        defaultWritingToolThickness02 = user.alexandriaData!.defaultWritingToolThickness02.value
        defaultWritingToolThickness03 = user.alexandriaData!.defaultWritingToolThickness03.value
        defaultWritingToolColor01 = IconColorDec(user.alexandriaData!.defaultWritingToolColor01!)
        defaultWritingToolColor02 = IconColorDec(user.alexandriaData!.defaultWritingToolColor02!)
        defaultWritingToolColor03 = IconColorDec(user.alexandriaData!.defaultWritingToolColor03!)
        defaultEraserToolThickness01 = user.alexandriaData!.defaultEraserToolThickness01.value
        defaultEraserToolThickness02 = user.alexandriaData!.defaultEraserToolThickness02.value
        defaultEraserToolThickness03 = user.alexandriaData!.defaultEraserToolThickness03.value
        defaultHighlighterToolThickness01 = user.alexandriaData!.defaultHighlighterToolThickness01.value
        defaultHighlighterToolThickness02 = user.alexandriaData!.defaultHighlighterToolThickness02.value
        defaultHighlighterToolThickness03 = user.alexandriaData!.defaultHighlighterToolThickness03.value
        defaultHighlighterToolColor01 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor01!)
        defaultHighlighterToolColor02 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor02!)
        defaultHighlighterToolColor03 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor03!)
        defaultTextToolFont = user.alexandriaData!.defaultTextToolFont.value
        goals = []
        trophies = []
        vaultDivisionPoints = []
        vaultMaps = []
        vaults = []
        shelves = []
        books = []
        for goal in user.alexandriaData!.goals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandriaData!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
        
        for vault in user.alexandriaData!.cloudVaults{
            vaults?.append(VaultDec(storedVault: vault))
        }
        
        for vaultMap in user.alexandriaData!.cloudVaultMaps{
            vaultMaps?.append(VaultMapDec(vaultMap))
        }
        
        for index in user.alexandriaData!.cloudVaultDivisionPoints{
            vaultDivisionPoints?.append(index)
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
        defaultPaperStyle = user.alexandriaData?.defaultPaperStyle
        defaultCoverStyle = user.alexandriaData?.defaultCoverStyle
        defaultPaperColor = user.alexandriaData?.defaultPaperColor
        defaultPaperOrientation = user.alexandriaData?.defaultPaperOrientation
        defaultWritingToolThickness01 = user.alexandriaData!.defaultWritingToolThickness01.value
        defaultWritingToolThickness02 = user.alexandriaData!.defaultWritingToolThickness02.value
        defaultWritingToolThickness03 = user.alexandriaData!.defaultWritingToolThickness03.value
        defaultWritingToolColor01 = IconColorDec(user.alexandriaData!.defaultWritingToolColor01!)
        defaultWritingToolColor02 = IconColorDec(user.alexandriaData!.defaultWritingToolColor02!)
        defaultWritingToolColor03 = IconColorDec(user.alexandriaData!.defaultWritingToolColor03!)
        defaultEraserToolThickness01 = user.alexandriaData!.defaultEraserToolThickness01.value
        defaultEraserToolThickness02 = user.alexandriaData!.defaultEraserToolThickness02.value
        defaultEraserToolThickness03 = user.alexandriaData!.defaultEraserToolThickness03.value
        defaultHighlighterToolThickness01 = user.alexandriaData!.defaultHighlighterToolThickness01.value
        defaultHighlighterToolThickness02 = user.alexandriaData!.defaultHighlighterToolThickness02.value
        defaultHighlighterToolThickness03 = user.alexandriaData!.defaultHighlighterToolThickness03.value
        defaultHighlighterToolColor01 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor01!)
        defaultHighlighterToolColor02 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor02!)
        defaultHighlighterToolColor03 = IconColorDec(user.alexandriaData!.defaultHighlighterToolColor03!)
        defaultTextToolFont = user.alexandriaData!.defaultTextToolFont.value
        goals = []
        trophies = []
        vaultDivisionPoints = []
        vaultMaps = []
        vaults = []
        shelves = []
        books = []
        for goal in user.alexandriaData!.goals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandriaData!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
        
        for vault in user.alexandriaData!.cloudVaults{
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
        if lhs.rootFolderID == rhs.rootFolderID && lhs.booksFolderID == rhs.booksFolderID && lhs.defaultPaperStyle == rhs.defaultPaperStyle && lhs.defaultCoverStyle == rhs.defaultCoverStyle && lhs.defaultPaperColor == rhs.defaultPaperColor && lhs.defaultPaperOrientation == rhs.defaultPaperOrientation && lhs.vaultDivisionPoints == rhs.vaultDivisionPoints && lhs.vaultMaps == rhs.vaultMaps && lhs.goals == rhs.goals && lhs.trophies == rhs.trophies && lhs.vaults == rhs.vaults && lhs.shelves == rhs.shelves && lhs.books == rhs.books{
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

struct VaultMapDec: Codable, Equatable{
    var vault: Double?
    var parentVault: Double?
    var indexInParent: Double?
    var childVaults: [Double]?
    
    init(){}
    
    init(_ storedMap: VaultMap){
        self.vault = storedMap.vault.value
        self.indexInParent = storedMap.indexInParent.value
        self.parentVault = storedMap.parentVault.value
        self.childVaults = []
        for vault in storedMap.cloudChildVaults{
            self.childVaults?.append(vault)
        }
    }
    
}

struct VaultDec: Codable, Equatable{
    var vaultFolderID: String?
    var indexInArray: Double?
    var color: IconColorDec?
    var birthName: String?
    var name: String?
    var pathVaults: [String]?
    var termSets: [TermSetDec]?
    var notes: [NoteDec]?
    
    init(){}
    
    init(storedVault: Vault){
        vaultFolderID = storedVault.vaultFolderID
        birthName = storedVault.birthName
        name = storedVault.name
        color = IconColorDec(storedVault.color!)
        termSets = []
        for set in storedVault.termSets{
            termSets?.append(TermSetDec(storedSet: set))
        }
        notes = []
        for note in storedVault.notes{
            notes?.append(NoteDec(storedNote: note))
        }
        pathVaults = []
        for component in storedVault.pathVaults{
            pathVaults?.append(component)
        }
    }
}

struct NoteDec: Codable, Equatable{
    var id: String?
    var title: String?
    var lastUpdated: Date?
    var coverStyle: String?
    var sheetStyleGroup: [String]?
    var sheetIndexInGroup: [Double]?
    
    init(){}
    
    init(storedNote: Note){
        self.id = storedNote.id
        self.title = storedNote.name
        self.lastUpdated = storedNote.lastUpdated
        self.coverStyle = storedNote.coverStyle
        self.sheetStyleGroup = []
        self.sheetIndexInGroup = []
        for style in storedNote.sheetStyleGroup{
            self.sheetStyleGroup?.append(style)
        }
        for index in storedNote.sheetIndexInGroup{
            self.sheetIndexInGroup?.append(index)
        }
    }
}

struct TermSetDec: Codable, Equatable{
    var birthName: String?
    var name: String?
    var color: IconColorDec?
    var terms: [TermDec]?
    
    init() {}
    
    init(storedSet: TermSet){
        birthName = storedSet.birthName
        name = storedSet.name
        terms = []
        color = IconColorDec(storedSet.color!)
        for term in storedSet.terms{
            terms?.append(TermDec(storedTerm: term))
        }
    }
}

struct TermDec: Codable, Equatable{
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

struct IconColorDec: Codable, Equatable{
    var red: Double?
    var green: Double?
    var blue: Double?
    var colorName: String?
    
    init(){}
    
    init(_ storedIcon: IconColor){
        red = storedIcon.red.value
        green = storedIcon.green.value
        blue = storedIcon.blue.value
        colorName = storedIcon.colorName
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

