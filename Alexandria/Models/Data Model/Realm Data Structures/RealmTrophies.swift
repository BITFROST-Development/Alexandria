//
//  RealmTrophies.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class Trophy: Object, NonDocumentItem{
    @objc dynamic var personalID: String?
    @objc dynamic var name: String?
    @objc dynamic var earned: String?
    var progress = RealmOptional<Double>()
    @objc dynamic var type: String?
    
//    required override init() {
//        super.init()
//        personalID = generateID(true)
//    }
    
    convenience init(_ trophyName: String?, _ trophyEarned: String?, _ trophyProgress: Double?, trophyType: String?) {
        self.init()
        personalID = generateID(true)
        name = trophyName
        earned = trophyEarned
        progress.value = trophyProgress
        type = trophyType
    }
    
    convenience init(_ decTrophy: TrophyDec) {
        self.init()
        personalID = decTrophy.personalID
        name = decTrophy.name
        earned = decTrophy.earned
        progress.value = decTrophy.progress
        type = decTrophy.type
    }
    
    private func generateID(_ cloud: Bool?) -> String{
        var newIDValue = ""
        if cloud ?? false {
            newIDValue = "C" + randomString(length: 16)
        } else {
            newIDValue = "L" + randomString(length: 16)
        }
        while((realm?.objects(Book.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Notebook.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(TermSet.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Folder.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(FileCollection.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Trophy.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Goal.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0){
            if cloud ?? false {
                newIDValue = "C" + randomString(length: 16)
            } else {
                newIDValue = "L" + randomString(length: 16)
            }
        }
        return newIDValue
    }
    
    private func generateID(_ excluding: [String], _ cloud: Bool?) -> String{
        var newIDValue = ""
        if cloud ?? false {
            newIDValue = "C" + randomString(length: 16)
        } else {
            newIDValue = "L" + randomString(length: 16)
        }
        while((realm?.objects(Book.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Notebook.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(TermSet.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Folder.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(FileCollection.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Trophy.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(Goal.self).filter("personalID == '\(newIDValue)'").count ?? 0) > 0) || (excluding.contains(newIDValue)){
            if cloud ?? false {
                newIDValue = "C" + randomString(length: 16)
            } else {
                newIDValue = "L" + randomString(length: 16)
            }
        }
        return newIDValue
    }

    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func equals(lhs: RealmSwift.List<Trophy>?, rhs: [TrophyDec]?)->Bool{
        if lhs?.count != rhs?.count{
            return false
        } else{
            for index in 0..<(lhs?.count ?? 0){
                if lhs?[index].personalID != rhs?[index].personalID || lhs?[index].name != rhs?[index].name || lhs?[index].earned != rhs?[index].earned || lhs?[index].progress.value != rhs?[index].progress || lhs?[index].type != rhs?[index].type{
                    return false
                }
            }
            
            return true
        }
    }
    
    static func equals(lhs: Trophy?, rhs: TrophyDec?)->Bool{
        
            if lhs?.personalID != rhs?.personalID || lhs?.name != rhs?.name || lhs?.earned != rhs?.earned || lhs?.progress.value != rhs?.progress || lhs?.type != rhs?.type{
                return false
            }
            
            return true
    }
    
    static func ^ (lhs: Trophy, rhs: TrophyDec){
        lhs.personalID = rhs.personalID
        lhs.name = rhs.name
        lhs.earned = rhs.earned
        lhs.progress.value = rhs.progress
        lhs.type = rhs.type
    }
    
    static func assign (lhs: RealmSwift.List<Trophy>?, rhs: [TrophyDec]?){
        lhs?.removeAll()
        
        for index in 0..<(rhs?.count ?? 0){
            lhs?.append(Trophy())
            lhs?[index].personalID = rhs?[index].personalID
            lhs?[index].name = rhs?[index].name
            lhs?[index].earned = rhs?[index].earned
            lhs?[index].progress.value = rhs?[index].progress
            lhs?[index].type = rhs?[index].type
        }
    }
}
