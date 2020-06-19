//
//  RealmDataStructure.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/7/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift

class AlexandriaData: Object, RealmOptionalType{
    
    static func == (lhs: AlexandriaData, rhs: AlexandriaData) -> Bool {
        if lhs.goals == rhs.goals && lhs.trophies == rhs.trophies && lhs.shelves == rhs.shelves && lhs.vaults == rhs.vaults{
            return true
        }
        
        return false
    }
    
    static func ^ (lhs: AlexandriaData, rhs: AlexandriaDataDec){
        
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
                lhs.shelves[index].books.append(StoredFile())
                lhs.shelves[index].books[kindex] ^ rhs.shelves![index].books![kindex]
            }
        }
        
        if lhs.vaults.count != 0{
            lhs.vaults.removeAll()
        }
        
        for index in 0..<(rhs.vaults?.count ?? 0){
            lhs.vaults.append(Vault())
            lhs.vaults[index].birthName = rhs.vaults![index].birthName
            lhs.vaults[index].name = rhs.vaults![index].name
            
            if lhs.vaults[index].terms.count != 0 {
                lhs.vaults[index].terms.removeAll()
            }
            
            for kindex in 0..<(rhs.vaults![index].terms?.count ?? 0){
                lhs.vaults[index].terms.append(Term())
                lhs.vaults[index].terms[kindex] ^ rhs.vaults![index].terms![kindex]
            }
        }
        
    }
    
    static func equals(_ localAlexandria: AlexandriaData, _ decodedAlexandria: AlexandriaDataDec) -> Bool {
        if localAlexandria.goals.count != decodedAlexandria.goals?.count {
            return false
        } else if localAlexandria.trophies.count != decodedAlexandria.trophies?.count {
            return false
        } else if localAlexandria.shelves.count != decodedAlexandria.shelves?.count {
            return false
        } else {
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
                        if !StoredFile.equals(lhs: localAlexandria.shelves[index].books[kindex], rhs: decodedAlexandria.shelves![index].books![kindex]){
                            return false
                        }
                    }
                }
            }
            
            return true
        }
    }
    
    func isEmpty() -> Bool{
        if self.goals.count == 0 && self.trophies.count == 0 && self.shelves.count == 0 && self.vaults.count == 0{
            return true
        }
        
        return false
        
    }
    
    var goals = RealmSwift.List<Goal>()
    var trophies = RealmSwift.List<Trophy>()
    var shelves = RealmSwift.List<Shelf>()
    var vaults = RealmSwift.List<Vault>()
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
    
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    var books = RealmSwift.List<StoredFile>()
    
    static func equals(lhs: RealmSwift.List<Shelf>?, rhs: [ShelfDec]?)->Bool{
        if rhs?.count != lhs?.count{
            return false
        } else{
            for index in 0..<(lhs?.count ?? 0){
                if rhs != nil{
                    
                    if rhs?[index].birthName != lhs?[index].birthName || rhs?[index].name != lhs?[index].name{
                        return false
                    }
                    
                    for kindex in 0..<(lhs?[index].books.count ?? 0){
                        if !StoredFile.equals(lhs: lhs![index].books[kindex], rhs: rhs![index].books![kindex]){
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
                if lhs?.birthName != rhs?.birthName || lhs?.name != rhs?.name{
                    return false
                } else {
                    for index in 0..<(lhs?.books.count ?? 0) {
                        if !StoredFile.equals(lhs: (lhs!.books[index]), rhs: (rhs?.books?[index])!){
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
        
        lhs.books.removeAll()
        
        for index in 0..<(rhs.books?.count ?? 0){
            lhs.books.append(StoredFile())
            lhs.books[index] ^ rhs.books![index]
        }
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
            
            for kindex in 0..<(rhs?[index].books?.count ?? 0){
                
                lhs?[index].books.append(StoredFile())
                
                lhs![index].books[kindex] ^ rhs![index].books![kindex]
            
            }
        }
    }
}

class Vault: Object{
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    var terms = RealmSwift.List<Term>()
    
    static func equals(_ lhs: Vault, _ rhs: VaultDec) -> Bool{
        if lhs.birthName != rhs.birthName || lhs.name != rhs.name{
            return false
        }
        
        for index in 0..<(rhs.terms?.count ?? 0){
            if !Term.equals(lhs.terms[index], rhs.terms?[index]){
                return false
            }
        }
        
        return true
    }
    
    static func equals(lhs: RealmSwift.List<Adventure>?, rhs: [AdventureDec]?) -> Bool{
        
        if lhs?.count != rhs?.count{
            return false
        } else {
            for index in 0..<(rhs?.count ?? 0){
                if lhs?[index].restaurant != rhs?[index].restaurant || lhs?[index].classification != rhs?[index].classification || lhs?[index].dateVisited != rhs?[index].dateVisited || lhs?[index].myThoughts != rhs?[index].myThoughts{
                    return false
                } else {
                    for memory in 0..<lhs![index].memories.count{
                        if  !StoredFile.equals(lhs: lhs![index].memories[memory], rhs: rhs![index].memories![memory]){
                            return false
                        }
                    }
                }
            }
            return true
        }
    }
    
    static func ^ (lhs: Adventure, rhs: AdventureDec){
        lhs.restaurant = rhs.restaurant
        lhs.classification = rhs.classification
        lhs.dateVisited = rhs.dateVisited
        lhs.myThoughts = rhs.myThoughts
        for index in 0..<(rhs.memories?.count ?? 0){
            lhs.memories.append(StoredFile())
            lhs.memories[index] ^ rhs.memories![index]
        }
    }
    
    static func assign (_ rhs: RealmSwift.List<Adventure>?, _ lhs: [AdventureDec]?){
        rhs?.removeAll()
        
        for index in 0..<(lhs?.count ?? 0){
            rhs?[index].restaurant = lhs?[index].restaurant
            rhs?[index].classification = lhs?[index].classification
            rhs?[index].dateVisited = lhs?[index].dateVisited
            rhs?[index].myThoughts = lhs?[index].myThoughts
            
            for memory in 0..<(lhs?[index].memories?.count ?? 0){
                rhs?[index].memories.append(StoredFile())
                rhs?[index].memories[memory].initialize(lhs![index].memories![memory].birthName!, lhs![index].memories![memory].name!, lhs![index].memories![memory].data!, lhs![index].memories![memory].contentType!)
            }
        }
    }
}

class Term: Object{
    @objc dynamic var type: String?
    @objc dynamic var content: String?
    @objc dynamic var location: String?
}

class StoredFile: Object{
    
    @objc dynamic var birthName: String?
    @objc dynamic var name: String?
    @objc dynamic var data: Data?
    @objc dynamic var contentType: String?
    
    func initialize (_ birth: String,_ label: String,_ file: Data,_ type: String) {
        birthName = birth
        name = label
        data = file
        contentType = type
    }
    
    static func equals (lhs: StoredFile, rhs: StoredFileDec) -> Bool{
        if lhs.birthName != rhs.birthName || lhs.name != rhs.name || lhs.data != rhs.data || lhs.contentType != rhs.contentType {
            return false
        }
        
        return true
    }
    
    static func ^ (lhs: StoredFile, rhs: StoredFileDec){
        lhs.birthName = rhs.birthName
        lhs.name = rhs.name
        lhs.data = rhs.data
        lhs.contentType = rhs.contentType
    }
}

class GiganticData: Object{
    @objc dynamic var avatar: StoredFile?
}