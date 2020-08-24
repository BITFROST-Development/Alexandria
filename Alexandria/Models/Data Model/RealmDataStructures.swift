//
//  RealmDataStructure.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/7/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import UIKit
import RealmSwift

class AlexandriaData: Object, RealmOptionalType{
    @objc dynamic var rootFolderID: String?
    @objc dynamic var booksFolderID: String?
    var goals = RealmSwift.List<Goal>()
    var trophies = RealmSwift.List<Trophy>()
    var shelves = RealmSwift.List<Shelf>()
    var localShelves = RealmSwift.List<Shelf>()
    var vaults = RealmSwift.List<Vault>()
    var localVaults = RealmSwift.List<Vault>()
    var cloudBooks = RealmSwift.List<Book>()
    var localBooks = RealmSwift.List<Book>()
    
    static func == (lhs: AlexandriaData, rhs: AlexandriaData) -> Bool {
        if lhs.rootFolderID == rhs.rootFolderID && lhs.booksFolderID == rhs.booksFolderID && lhs.goals == rhs.goals && lhs.trophies == rhs.trophies && lhs.shelves == rhs.shelves && lhs.localShelves == rhs.localShelves && lhs.vaults == rhs.vaults && lhs.cloudBooks == rhs.cloudBooks && lhs.localBooks == rhs.localBooks{
            return true
        }
        
        return false
    }
    
    static func ^ (lhs: AlexandriaData, rhs: AlexandriaDataDec){
        
        lhs.rootFolderID = rhs.rootFolderID
        lhs.booksFolderID = rhs.booksFolderID
        
        if lhs.goals.count != 0 {
            lhs.goals.removeAll()
        }
        
        for index in 0..<(rhs.goals?.count ?? 0){
            lhs.goals.append(Goal())
            lhs.goals[index].birthName = rhs.goals![index].birthName
            lhs.goals[index].name = rhs.goals![index].name
            lhs.goals[index].achieved = rhs.goals![index].achieved
            lhs.goals[index].progress.value = rhs.goals![index].progress
            lhs.goals[index].theme = rhs.goals![index].theme
        }
        
        if lhs.trophies.count != 0{
            lhs.trophies.removeAll()
        }
        
        for index in 0..<(rhs.trophies?.count ?? 0){
            lhs.trophies.append(Trophy())
            lhs.trophies[index].name = rhs.trophies![index].name
            lhs.trophies[index].earned = rhs.trophies![index].earned
            lhs.trophies[index].progress.value = rhs.trophies![index].progress
            lhs.trophies[index].theme = rhs.trophies![index].theme
        }
        
        if lhs.cloudBooks.count != 0 {
            lhs.cloudBooks.removeAll()
        }
        
        for index in 0..<(rhs.books?.count ?? 0){
            lhs.cloudBooks.append(Book())
            lhs.cloudBooks[index] ^ rhs.books![index]
        }

        
        if lhs.shelves.count != 0 {
            lhs.shelves.removeAll()
        }
        
        for index in 0..<(rhs.shelves?.count ?? 0){
            lhs.shelves.append(Shelf())
            lhs.shelves[index].birthName = rhs.shelves![index].birthName
            lhs.shelves[index].name = rhs.shelves![index].name
            
            if lhs.shelves[index].books.count != 0 {
                lhs.shelves[index].books.removeAll()
            }
            
            for kindex in 0..<(rhs.shelves![index].books?.count ?? 0){
                lhs.shelves[index].books.append(rhs.shelves![index].books![kindex])
            }
        }
        
        if lhs.vaults.count != 0{
            lhs.vaults.removeAll()
        }
        
        for index in 0..<(rhs.vaults?.count ?? 0){
            lhs.vaults.append(Vault())
            lhs.vaults[index].birthName = rhs.vaults![index].birthName
            lhs.vaults[index].name = rhs.vaults![index].name
            
            if lhs.vaults[index].sets.count != 0 {
                lhs.vaults[index].sets.removeAll()
            }
            
            for kindex in 0..<(rhs.vaults![index].sets?.count ?? 0){
                lhs.vaults[index].sets.append(TermSet())
                lhs.vaults[index].sets[kindex] ^ rhs.vaults![index].sets![kindex]
            }
        }
    }
    
    static func equals(_ localAlexandria: AlexandriaData, _ decodedAlexandria: AlexandriaDataDec) -> Bool {
        if localAlexandria.rootFolderID != decodedAlexandria.rootFolderID || localAlexandria.booksFolderID != decodedAlexandria.booksFolderID{
            return false
        } else if localAlexandria.goals.count != decodedAlexandria.goals?.count {
            return false
        } else if localAlexandria.trophies.count != decodedAlexandria.trophies?.count {
            return false
        } else if localAlexandria.shelves.count != decodedAlexandria.shelves?.count {
            return false
        } else if localAlexandria.cloudBooks.count != decodedAlexandria.books?.count {
            return false
        }else {
            for index in 0..<(decodedAlexandria.goals?.count ?? 0){
                if localAlexandria.goals[index].birthName != decodedAlexandria.goals![index].birthName ||
                localAlexandria.goals[index].name != decodedAlexandria.goals![index].name ||
                localAlexandria.goals[index].achieved != decodedAlexandria.goals![index].achieved ||
                localAlexandria.goals[index].progress.value != decodedAlexandria.goals![index].progress ||
                    localAlexandria.goals[index].theme != decodedAlexandria.goals![index].theme {
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.trophies?.count ?? 0){
                if localAlexandria.trophies[index].name != decodedAlexandria.trophies![index].name ||
                localAlexandria.trophies[index].earned != decodedAlexandria.trophies![index].earned ||
                localAlexandria.trophies[index].progress.value != decodedAlexandria.trophies![index].progress ||
                    localAlexandria.trophies[index].theme != decodedAlexandria.trophies![index].theme{
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.shelves?.count ?? 0){
                if localAlexandria.shelves[index].birthName != decodedAlexandria.shelves![index].birthName ||
                localAlexandria.shelves[index].name != decodedAlexandria.shelves![index].name{
                    return false
                } else {
                    for kindex in 0..<(decodedAlexandria.shelves![index].books?.count ?? 0){
                        if localAlexandria.shelves[index].books[kindex] != decodedAlexandria.shelves![index].books![kindex]{
                            return false
                        }
                    }
                }
            }
            
            for index in 0..<(decodedAlexandria.books?.count ?? 0){
                if !Book.equals(lhs: localAlexandria.cloudBooks[index], rhs: decodedAlexandria.books![index]){
                    return false
                }
            }
            
            return true
        }
    }
    
    func isEmpty() -> Bool{
        if self.goals.count == 0 && self.trophies.count == 0 && self.shelves.count == 0 && self.vaults.count == 0 && self.cloudBooks.count == 0 && self.localShelves.count == 0 && self.localBooks.count == 0{
            return true
        }
        
        return false
        
    }
}

class Goal: Object{
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    @objc dynamic var achieved: String?
    var progress = RealmOptional<Double>()
    @objc dynamic var theme: String?
    
    static func equals(rhs: RealmSwift.List<Goal>?, lhs: [GoalDec]?)->Bool{
        if rhs?.count != lhs?.count{
            return false
        } else{
            for index in 0..<(rhs?.count ?? 0){
                if rhs?[index].birthName != lhs?[index].birthName || rhs?[index].name != lhs?[index].name || rhs?[index].achieved != lhs?[index].achieved || rhs?[index].progress.value != lhs?[index].progress || rhs?[index].theme != lhs?[index].theme{
                    return false
                }
            }
            
            return true
        }
    }
    
    static func equals(rhs: Goal?, lhs: GoalDec?)->Bool{
        
            if rhs?.birthName != lhs?.birthName || rhs?.name != lhs?.name || rhs?.achieved != lhs?.achieved || rhs?.progress.value != lhs?.progress || rhs?.theme != lhs?.theme{
                return false
            }
            
            return true
    }
    
    static func ^ (rhs: Goal, lhs: GoalDec){
        rhs.birthName = lhs.birthName
        rhs.name = lhs.name
        rhs.achieved = lhs.achieved
        rhs.progress.value = lhs.progress
        rhs.theme = lhs.theme
    }
    
    static func assign (rhs: RealmSwift.List<Goal>?, lhs: [GoalDec]?){
        rhs?.removeAll()
        
        for index in 0..<(lhs?.count ?? 0){
            
            rhs?.append(Goal())
            
            rhs?[index].birthName = lhs?[index].birthName
            rhs?[index].name = lhs?[index].name
            rhs?[index].achieved = lhs?[index].achieved
            rhs?[index].progress.value = lhs?[index].progress
            rhs?[index].theme = lhs?[index].theme
        }
    }
}

class Trophy: Object{
    @objc dynamic var name: String?
    @objc dynamic var earned: String?
    var progress = RealmOptional<Double>()
    @objc dynamic var theme: String?
    
    static func equals(rhs: RealmSwift.List<Trophy>?, lhs: [TrophyDec]?)->Bool{
        if rhs?.count != lhs?.count{
            return false
        } else{
            for index in 0..<(rhs?.count ?? 0){
                if rhs?[index].name != lhs?[index].name || rhs?[index].earned != lhs?[index].earned || rhs?[index].progress.value != lhs?[index].progress || rhs?[index].theme != lhs?[index].theme{
                    return false
                }
            }
            
            return true
        }
    }
    
    static func equals(rhs: Trophy?, lhs: TrophyDec?)->Bool{
        
            if rhs?.name != lhs?.name || rhs?.earned != lhs?.earned || rhs?.progress.value != lhs?.progress || rhs?.theme != lhs?.theme{
                return false
            }
            
            return true
    }
    
    static func ^ (rhs: Trophy, lhs: TrophyDec){
        rhs.name = lhs.name
        rhs.earned = lhs.earned
        rhs.progress.value = lhs.progress
        rhs.theme = lhs.theme
    }
    
    static func assign (rhs: RealmSwift.List<Trophy>?, lhs: [TrophyDec]?){
        rhs?.removeAll()
        
        for index in 0..<(lhs?.count ?? 0){
            rhs?.append(Trophy())
            rhs?[index].name = lhs?[index].name
            rhs?[index].earned = lhs?[index].earned
            rhs?[index].progress.value = lhs?[index].progress
            rhs?[index].theme = lhs?[index].theme
        }
    }
}

class Shelf: Object{
    var cloudVar = RealmOptional<Bool>()
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    var books = RealmSwift.List<Double>()
    var oppositeBooks = RealmSwift.List<Double>()
    
    required init(){
        cloudVar.value = true
    }
    
    func findBookIndex(book: Double, in array: String) -> Int?{
        if array == "books"{
            var checkingIndex = self.books.count / 2
            var upperBound = self.books.count - 1
            var lowerBound = 0
            while checkingIndex < self.books.count {
                if checkingIndex == 0 && checkingIndex != Int(book){
                    return nil
                } else if checkingIndex > Int(book){
                    upperBound = checkingIndex
                    checkingIndex = (upperBound - lowerBound) / 2
                } else if  checkingIndex < Int(book){
                    lowerBound = checkingIndex
                    checkingIndex = ((upperBound - lowerBound) / 2) + lowerBound
                } else {
                    return checkingIndex
                }
            }
        } else {
            var checkingIndex = self.oppositeBooks.count / 2
            var upperBound = self.oppositeBooks.count - 1
            var lowerBound = 0
            while checkingIndex < self.oppositeBooks.count {
                if checkingIndex == 0 && checkingIndex != Int(book){
                    return nil
                } else if checkingIndex > Int(book){
                    upperBound = checkingIndex
                    checkingIndex = (upperBound - lowerBound) / 2
                } else if  checkingIndex < Int(book){
                    lowerBound = checkingIndex
                    checkingIndex = ((upperBound - lowerBound) / 2) + lowerBound
                } else {
                    return checkingIndex
                }
            }
        }
        return nil
    }
    
    static func equals(lhs: RealmSwift.List<Shelf>?, rhs: [ShelfDec]?)->Bool{
        if rhs?.count != lhs?.count{
            return false
        } else{
            for index in 0..<(lhs?.count ?? 0){
                if rhs != nil{
                    
                    if rhs?[index].birthName != lhs?[index].birthName || rhs?[index].name != lhs?[index].name || lhs?[index].books.count != rhs?[index].books?.count{
                        return false
                    }
                    
                    for kindex in 0..<(lhs?[index].books.count ?? 0){
                        if lhs![index].books[kindex] != rhs![index].books![kindex]{
                            return false
                        }
                    }
                    
                }
            }
            
            return true
        }
    }
    
    static func equals(lhs: Shelf?, rhs: ShelfDec?)->Bool{
        
            if lhs != nil{
                if lhs?.birthName != rhs?.birthName || lhs?.name != rhs?.name || lhs?.books.count != rhs?.books?.count{
                    return false
                } else {
                    for index in 0..<(lhs?.books.count ?? 0) {
                        if lhs!.books[index] != rhs?.books?[index]{
                            return false
                        }
                    }
                }
            }
            
            return true
    }
    
    static func ^ (lhs: Shelf, rhs: ShelfDec){
        lhs.birthName = rhs.birthName
        lhs.name = rhs.name
        lhs.cloudVar.value = true
        lhs.books.removeAll()
        
        for index in 0..<(rhs.books?.count ?? 0){
            lhs.books.append(rhs.books![index])
        }
    }
    
    static func equals(_ lhs: Shelf, _ rhs: Shelf) -> Bool{
        if lhs.birthName != rhs.birthName || lhs.name != rhs.name || lhs.books.count != rhs.books.count || lhs.oppositeBooks.count != rhs.oppositeBooks.count{
            return false
        } else {
            for index in 0..<lhs.books.count{
                if lhs.books[index] != rhs.books[index]{
                    return false
                }
            }
            for index in 0..<lhs.oppositeBooks.count{
                if lhs.oppositeBooks[index] != rhs.oppositeBooks[index]{
                    return false
                }
            }
        }
        return true
    }
    
    static func compare(lhs: Shelf, rhs: Shelf, presentingView: UIViewController, completion: @escaping(Bool) -> Void){
        if Shelf.equals(lhs, rhs) {
            completion(false)
        } else {
            if lhs.birthName == rhs.birthName{
                let alert = UIAlertController(title: "Warning: Merging", message: "\(lhs.name!) and \(rhs.name!) may have conflicting information, please choose one of the following!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Keep Both", style: .cancel){_ in
                    completion(true)
                })
                alert.addAction(UIAlertAction(title: "Don't Import Shelf", style: .default){_ in
                    completion(false)
                })
                alert.addAction(UIAlertAction(title: "Delete Local Shelf", style: .destructive){_ in
                    do{
                        try AppDelegate.realm.write({
                            AppDelegate.realm.delete(lhs)
                        })
                        completion(true)
                    } catch {
                        print("Could not delete element")
                    }
                    
                })
                presentingView.present(alert, animated: true)
            }
        }
        completion(true)
    }
    
    static func assign (lhs: RealmSwift.List<Shelf>?, rhs: [ShelfDec]?){
        
        for index in 0..<(lhs?.count ?? 0){
            
            lhs?[index].books.removeAll()
            
        }
        
        lhs?.removeAll()
        
        for index in 0..<(rhs?.count ?? 0){
            
            lhs?.append(Shelf())
            
            lhs?[index].birthName = rhs?[index].birthName
            
            lhs?[index].name = rhs?[index].name
            lhs?[index].cloudVar.value = true
            
            for kindex in 0..<(rhs?[index].books?.count ?? 0){
                
                lhs?[index].books.append(rhs![index].books![kindex])
            
            }
        }
    }
}

class Vault: Object, VaultDisplayable{
    @objc dynamic var vaultFolderID: String?
    @objc dynamic var parentFolderID: String?
    var childrenFolderIDs = RealmSwift.List<String>()
    var localChildrenFolderIDs = RealmSwift.List<String>()
    var vaultPathComponents = RealmSwift.List<String>()
    @objc dynamic var color: IconColor?
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    @objc dynamic var localAddress: String?
    var cloudVar = RealmOptional<Bool>()
    var sets = RealmSwift.List<TermSet>()
    var localSets = RealmSwift.List<TermSet>()
    var notes = RealmSwift.List<Note>()
    var localNotes = RealmSwift.List<Note>()
    
    required init() {
        cloudVar.value = false
    }
    
    static func equals(_ lhs: Vault, _ rhs: VaultDec) -> Bool{
        if lhs.parentFolderID != rhs.parentFolderID || lhs.childrenFolderIDs.count != rhs.childrenFolderIDs?.count || lhs.vaultFolderID != rhs.vaultFolderID || lhs.birthName != rhs.birthName || lhs.name != rhs.name || lhs.sets.count != rhs.sets?.count || lhs.notes.count != rhs.notes?.count || IconColor.equals(lhs.color, rhs.color){
            return false
        }
        
        for index in 0..<(rhs.sets?.count ?? 0){
            if !TermSet.equals(lhs.sets[index], rhs.sets![index]){
                return false
            }
        }
        
        for index in 0..<(rhs.notes?.count ?? 0){
            if lhs.notes[index] != rhs.notes![index] {
                return false
            }
        }
        
        for index in 0..<(rhs.childrenFolderIDs?.count ?? 0){
            if lhs.childrenFolderIDs[index] != rhs.childrenFolderIDs![index]{
                return false
            }
        }
        
        return true
    }
    
    static func equals(lhs: RealmSwift.List<Vault>?, rhs: [VaultDec]?) -> Bool{
        
        if lhs?.count != rhs?.count{
            return false
        } else {
            for index in 0..<(rhs?.count ?? 0){
                if lhs?[index].parentFolderID != rhs?[index].parentFolderID || lhs?[index].vaultFolderID != rhs?[index].vaultFolderID || lhs?[index].birthName != rhs?[index].birthName || lhs?[index].name != rhs?[index].name{
                    return false
                } else {
                    if lhs?[index].sets.count != rhs?[index].sets?.count || lhs?[index].childrenFolderIDs.count != rhs?[index].childrenFolderIDs?.count || lhs?[index].notes.count != rhs?[index].notes?.count || IconColor.equals(lhs?[index].color, rhs?[index].color){
                        return false
                    } else {
                        for kindex in 0..<(rhs![index].sets?.count ?? 0){
                            if !TermSet.equals(lhs![index].sets[kindex], rhs![index].sets![kindex]){
                                return false
                            }
                        }
                        
                        for kindex in 0..<(rhs![index].notes?.count ?? 0){
                            if lhs![kindex].notes[kindex] != rhs![index].notes![kindex]{
                                return false
                            }
                        }
                        
                        for kindex in 0..<(rhs![index].childrenFolderIDs?.count ?? 0){
                            if lhs![index].childrenFolderIDs[kindex] != rhs![index].childrenFolderIDs![kindex]{
                                return false
                            }
                        }
                    }
                }
            }
            return true
        }
    }
    
    static func ^ (lhs: Vault, rhs: VaultDec){
        lhs.birthName = rhs.birthName
        lhs.name = rhs.name
        lhs.vaultFolderID = rhs.vaultFolderID
        lhs.cloudVar.value = true
        lhs.color! ^ rhs.color!
        lhs.sets.removeAll()
        lhs.notes.removeAll()
        lhs.childrenFolderIDs.removeAll()
        lhs.vaultPathComponents.removeAll()
        
        for index in 0..<(rhs.sets?.count ?? 0){
            lhs.sets.append(TermSet())
            lhs.sets[index] ^ rhs.sets![index]
        }
        
        for index in 0..<(rhs.notes?.count ?? 0){
            lhs.notes.append(Note())
            lhs.notes[index] ^ rhs.notes![index]
        }
        
        for index in 0..<(rhs.childrenFolderIDs?.count ?? 0){
            lhs.childrenFolderIDs.append(rhs.childrenFolderIDs![index])
        }
        
        for index in 0..<(rhs.vaultPathComponents?.count ?? 0){
            lhs.vaultPathComponents.append(rhs.vaultPathComponents![index])
        }
    }
    
    static func assign (_ lhs: RealmSwift.List<Vault>?, _ rhs: [VaultDec]?){
        for index in 0..<(lhs?.count ?? 0){
            lhs![index].sets.removeAll()
        }
        
        for index in 0..<(lhs?.count ?? 0){
            lhs![index].notes.removeAll()
        }
        
        for index in 0..<(lhs?.count ?? 0){
            lhs![index].childrenFolderIDs.removeAll()
        }
        
        for index in 0..<(lhs?.count ?? 0){
            lhs![index].vaultPathComponents.removeAll()
        }
        
        lhs?.removeAll()
        
        for index in 0..<(rhs?.count ?? 0){
            lhs?.append(Vault())
            lhs![index].birthName = rhs![index].birthName
            lhs![index].name = rhs![index].name
            lhs![index].vaultFolderID = rhs![index].vaultFolderID
            lhs![index].cloudVar.value = true
            lhs![index].color! ^ rhs![index].color!
            for kindex in 0..<(rhs![index].sets?.count ?? 0){
                lhs?[index].sets.append(TermSet())
                lhs![index].sets[kindex] ^ rhs![index].sets![kindex]
            }
            
            for kindex in 0..<(rhs![index].notes?.count ?? 0){
                lhs?[index].notes.append(Note())
                lhs![index].notes[kindex] ^ rhs![index].notes![kindex]
            }
            
            for kindex in 0..<(rhs![index].childrenFolderIDs?.count ?? 0){
                lhs?[index].childrenFolderIDs.append(rhs![index].childrenFolderIDs![kindex])
            }
            
            for kindex in 0..<(rhs![index].vaultPathComponents?.count ?? 0){
                lhs?[index].vaultPathComponents.append(rhs![index].vaultPathComponents![kindex])
            }
            
        }
    }
}

class Note: Object, VaultDisplayable{
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var lastUpdated: Date?
    @objc dynamic var localAddress: String? = nil
    var cloudVar = RealmOptional<Bool>()
    @objc dynamic var thumbnail: StoredFile?
    
    static func != (lhs: Note, rhs: NoteDec) -> Bool{
        if lhs.id != rhs.id || lhs.name != rhs.title || lhs.lastUpdated != rhs.lastUpdated || !StoredFile.equals(lhs: lhs.thumbnail!, rhs: rhs.thumbnail!){
            return true
        }
        return false
    }
    
    static func ^ (lhs: Note, rhs: NoteDec){
        lhs.id = rhs.id
        lhs.name = rhs.title
        lhs.lastUpdated = rhs.lastUpdated
        lhs.thumbnail = StoredFile(rhs.thumbnail)
    }
}

class TermSet: Object, VaultDisplayable{
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    @objc dynamic var color: IconColor?
    var cloudVar = RealmOptional<Bool>()
    var terms = RealmSwift.List<Term>()
    
    static func equals (_ lhs: TermSet, _ rhs: TermSetDec) -> Bool {
        if lhs.birthName != rhs.birthName || lhs.name != rhs.name || lhs.terms.count != rhs.terms?.count || !IconColor.equals(lhs.color, rhs.color){
            return false
        } else{
            for index in 0..<(rhs.terms?.count ?? 0){
                if !Term.equals(lhs.terms[index], rhs.terms![index]){
                    return false
                }
            }
            
            return true
        }
    }
    
    static func ^ (_ lhs: TermSet, _ rhs: TermSetDec){
        lhs.birthName = rhs.birthName
        lhs.name = rhs.name
        if rhs.color != nil {
            if lhs.color != nil {
                lhs.color! ^ rhs.color!
            } else {
                lhs.color = IconColor(from: rhs.color!)
            }
        } else if lhs.color != nil{
            do {
                try AppDelegate.realm.write({
                    AppDelegate.realm.delete(lhs.color!)
                })
            } catch let error {
                print(error.localizedDescription)
            }
        }
        lhs.terms.removeAll()
        
        for index in 0..<(rhs.terms?.count ?? 0){
            lhs.terms.append(Term())
            lhs.terms[index] ^ rhs.terms![index]
        }
    }
}

class Term: Object{
    @objc dynamic var type: String?
    @objc dynamic var content: String?
    @objc dynamic var location: String?
    
    static func equals(_ lhs: Term,_ rhs: TermDec) -> Bool{
        if lhs.type != rhs.type || lhs.content != rhs.content || lhs.location != rhs.location {
            return false
        }
        return true
    }
    
    static func ^ (_ lhs: Term, _ rhs: TermDec){
        lhs.type = rhs.type
        lhs.content = rhs.content
        lhs.location = rhs.location
    }
    
}

class IconColor: Object{
    var red = RealmOptional<Double>()
    var green = RealmOptional<Double>()
    var blue = RealmOptional<Double>()
    @objc dynamic var colorName: String?
    
    required init(){}
    
    required init(from cloud: IconColorDec) {
        self.red.value = cloud.red
        self.green.value = cloud.green
        self.blue.value = cloud.blue
        self.colorName = cloud.colorName
    }
    
    static func equals (_ lhs: IconColor?, _ rhs: IconColorDec?) -> Bool{
        if lhs?.red.value != rhs?.red || lhs?.green.value != rhs?.green || lhs?.blue.value != rhs?.blue || lhs?.colorName != rhs?.colorName{
            return false
        }
        return true
    }
    
    static func ^ (_ lhs: IconColor, _ rhs: IconColorDec) {
        lhs.red.value = rhs.red
        lhs.green.value = rhs.green
        lhs.blue.value = rhs.blue
        lhs.colorName = rhs.colorName
    }
}

class Book: Object {
    @objc dynamic var id: String?
    @objc dynamic var localAddress: String? = nil
    @objc dynamic var title: String?
    @objc dynamic var author: String?
    @objc dynamic var year: String?
    @objc dynamic var thumbnail: StoredFile?
    var cloudVar = RealmOptional<Bool>()
    
    required init() {
        cloudVar.value = false
    }
    
    required init(toCloud: Bool) {
        cloudVar.value = toCloud
    }
    
    required init(_ bookID: String?,_ bookTitle: String?,_ bookAuthor: String?,_ bookYear: String?,_ bookThumbnail: StoredFileDec?, cloudValue: Bool, bookShelves: [Double]){
        id = bookID
        title = bookTitle
        author = bookAuthor
        year = bookYear
        cloudVar.value = cloudValue
        thumbnail = StoredFile(bookThumbnail)
    }
    
    func deleteInformation(){
        do{
            if localAddress != nil{
                try FileManager.default.removeItem(atPath: localAddress!)
                localAddress = nil
            }
        } catch {
            print("Could not delete file")
        }
    }
    
    static func equals (lhs: Book, rhs: BookDec) -> Bool{
        if lhs.id != rhs.driveID || lhs.title != rhs.title || lhs.author != rhs.author || lhs.year != rhs.year || !StoredFile.equals(lhs: lhs.thumbnail!, rhs: rhs.thumbnail!){
            return false
        }
        return true
    }
    
    static func equals(lhs: Book, rhs: Book) -> Bool{
        if lhs.id != rhs.id || lhs.title != rhs.title || lhs.author != rhs.author || lhs.year != rhs.year || !StoredFile.equals(lhs: lhs.thumbnail!, rhs: rhs.thumbnail!){
            return false
        }
        
        return true
    }
    
    static func ^ (lhs: Book, rhs: BookDec){
        lhs.id = rhs.driveID
        lhs.title = rhs.title
        lhs.author = rhs.author
        lhs.year = rhs.year
        lhs.cloudVar.value = true
        lhs.thumbnail = StoredFile(rhs.thumbnail!)
    }
    
    static func compare(lhs: Book, rhs: RealmSwift.List<Book>, presentingView: UIViewController, completion: @escaping(Bool) -> Void){
        for book in rhs {
            if Book.equals(lhs: lhs, rhs: book) {
                completion(false)
            } else if lhs.id == book.id || lhs.title == book.title {
                let alert = UIAlertController(title: "Warning: Merging", message: "\(lhs.title!) and \(book.title!) may have conflicting information, please choose one of the following!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Keep Both", style: .cancel){_ in
                    completion(true)
                })
                alert.addAction(UIAlertAction(title: "Don't Import File", style: .default){_ in
                    completion(false)
                })
                alert.addAction(UIAlertAction(title: "Delete Local File", style: .destructive){_ in
                    do{
                        try AppDelegate.realm.write({
                            AppDelegate.realm.delete(lhs)
                        })
                        completion(true)
                    } catch {
                        print("Could not delete element")
                    }
                    
                })
                presentingView.present(alert, animated: true)
            }
        }
        completion(true)
    }
}

class StoredFile: Object{
    
    @objc dynamic var name: String?
    @objc dynamic var data: Data?
    @objc dynamic var contentType: String?
    
    func initialize (_ label: String,_ file: Data,_ type: String) {
        name = label
        data = file
        contentType = type
    }
    
    required init (){}
    
    init(_ decodedFile: StoredFileDec?){
        if decodedFile != nil {
            self.name = decodedFile?.name
            self.contentType = decodedFile?.contentType
            self.data = Data(bytes: decodedFile!.data?.data ?? [], count: decodedFile!.data?.data?.count ?? 0)
        }
    }
    
    static func equals (lhs: StoredFile, rhs: StoredFileDec) -> Bool{
        if lhs.name != rhs.name || lhs.data != Data(bytes: rhs.data?.data ?? [], count: rhs.data?.data?.count ?? 0) || lhs.contentType != rhs.contentType {
            return false
        }
        
        return true
    }
    
    static func equals (lhs: StoredFile, rhs: StoredFile) -> Bool {
        if lhs.name != rhs.name || lhs.data != rhs.data || lhs.contentType != rhs.contentType {
            return false
        }
        
        return true
    }
    
    static func ^ (lhs: StoredFile, rhs: StoredFileDec){
        lhs.name = rhs.name
        lhs.data = Data(bytes: rhs.data?.data ?? [], count: rhs.data?.data?.count ?? 0)
        lhs.contentType = rhs.contentType
    }
}

class BookToListMap: Object {
    var keys = RealmSwift.List<BookToListKey>()
    
    func append(key: Double, value: Shelf?, isCloud: Bool) {
        if Int(key) >= keys.count {
            for _ in keys.count...Int(key){
                keys.append(BookToListKey())
            }
        }
        keys[Int(key)].append(value, key, isCloud)
    }
    func append(key: BookToListKey, in index: Int){
        if index >= keys.count {
            for _ in keys.count...index{
                keys.append(BookToListKey())
            }
        } else {
            keys.append(BookToListKey())
            for kindex in index..<keys.count{
                keys[keys.count - kindex - 1] = keys[keys.count - kindex - 2]
            }
        }
        keys[index].append(key: key)
    }
    
    func removeObject(in index: Int){
        keys[index].removeObject()
        for kindex in index..<keys.count{
            for jindex in 0..<keys[kindex].values.count{
                if keys[kindex].values[jindex].indexInShelf.value != nil {
                    do {
                        try realm?.write({
                            keys[kindex].values[jindex].indexInShelf.value! -= 1
                        })
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    do {
                        try realm?.write({
                            keys[kindex].values[jindex].oppositeIndexInShelf.value! -= 1
                        })
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

class BookToListKey: Object {
    var values = RealmSwift.List<BookToListValue>()
    
    func append(_ valueToStore: Shelf?, _ bookIndex: Double, _ isCloud: Bool){
        if valueToStore != nil{
            let newValues = List<BookToListValue>()
            var startingIndex = 0
            var shouldContinueChecking = true
            let storedCloudShelves = realm!.objects(AlexandriaData.self)[0].shelves
            let storedLocalShelves = realm!.objects(AlexandriaData.self)[0].localShelves
            for index in 0...values.count{
                if values.count > 0 && Shelf.equals(values[index].value!, valueToStore!) {
                    return
                } else {
                    if (index < values.count) && shouldContinueChecking {
                        let shelf = values[index].value!
                        if valueToStore?.cloudVar.value ?? false{
                            if shelf.cloudVar.value ?? false {
                                for kindex in startingIndex..<storedCloudShelves.count{
                                    if Shelf.equals(storedCloudShelves[kindex], shelf){
                                        startingIndex = kindex
                                        break
                                    } else if Shelf.equals(storedCloudShelves[kindex], valueToStore!) {
                                        newValues.append(BookToListValue(valueToStore!, bookIndex, isCloud))
                                        shouldContinueChecking = false
                                        break
                                    }
                                }
                            } else {
                                newValues.append(BookToListValue(valueToStore!, bookIndex, isCloud))
                                shouldContinueChecking = false
                                break
                            }
                        } else {
                            if !(shelf.cloudVar.value ?? false){
                                for kindex in startingIndex..<storedLocalShelves.count{
                                    if Shelf.equals(storedLocalShelves[kindex], shelf){
                                        startingIndex = kindex
                                        break
                                    } else if Shelf.equals(storedLocalShelves[kindex], valueToStore!) {
                                        newValues.append(BookToListValue(valueToStore!, bookIndex, isCloud))
                                        shouldContinueChecking = false
                                        break
                                    }
                                }
                            }
                        }
                        newValues.append(values[index])
                    } else {
                        newValues.append(BookToListValue(valueToStore!, bookIndex, isCloud))
                    }
                }
            }
            do {
                try realm?.write({
                    values.removeAll()
                    values = newValues
                })
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func append(key: BookToListKey){
        for index in 0..<key.values.count{
            do {
                try realm?.write({
                    if key.values[index].indexInShelf.value != nil {
                        key.values[index].value!.books.remove(at: key.values[index].indexInShelf.value!)
                        key.values[index].value!.oppositeBooks.append(Double(key.values[index].value!.oppositeBooks.count))
                        key.values[index].oppositeIndexInShelf.value = key.values[index].value!.oppositeBooks.count
                        key.values[index].indexInShelf.value = nil
                    } else {
                        key.values[index].value!.oppositeBooks.remove(at: key.values[index].oppositeIndexInShelf.value!)
                        key.values[index].value!.books.append(Double(key.values[index].value!.books.count))
                        key.values[index].indexInShelf.value = key.values[index].value!.books.count
                        key.values[index].oppositeIndexInShelf.value = nil
                    }
                })
            } catch let error{
                print(error.localizedDescription)
            }
        }
        values = key.values
    }
    
    func removeObject(){
        for value in values{
            do{
                try realm?.write({
                    if value.indexInShelf.value != nil {
                        value.value?.books.remove(at: value.indexInShelf.value!)
                        for book in value.indexInShelf.value!..<(value.value?.books.count ?? 0){
                            value.value?.books[book] -= 1.0
                        }
                    } else {
                        value.value?.oppositeBooks.remove(at: value.oppositeIndexInShelf.value!)
                        for book in value.oppositeIndexInShelf.value!..<(value.value?.oppositeBooks.count ?? 0){
                            value.value?.oppositeBooks[book] -= 1.0
                        }
                    }
                    realm?.delete(self)
                })
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

class BookToListValue: Object {
    @objc dynamic var value: Shelf?
    var indexInShelf = RealmOptional<Int>()
    var oppositeIndexInShelf = RealmOptional<Int>()
    required init (){}
    required init (_ valueToStore: Shelf, _ bookIndex: Double, _ isCloud: Bool){
        value = valueToStore
        if (isCloud && (valueToStore.cloudVar.value ?? false)) || (!isCloud && !(valueToStore.cloudVar.value ?? false)){
            for book in 0..<valueToStore.books.count {
                if valueToStore.books[book] == bookIndex{
                    indexInShelf.value = Int(book)
                    break
                }
            }
        } else {
            for book in 0..<valueToStore.oppositeBooks.count{
                if valueToStore.oppositeBooks[book] == bookIndex{
                    oppositeIndexInShelf.value = Int(book)
                    break
                }
            }
        }
    }
}

class GiganticData: Object{
    @objc dynamic var avatar: StoredFile?
}
