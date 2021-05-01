//
//  RealmGoals.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class Goal: Object, NonDocumentItem, InlinePickerItem{
    @objc dynamic var personalID: String?
    @objc dynamic var name: String?
    @objc dynamic var achieved: String?
    var valueToHit = RealmOptional<Double>()
    var progressList = RealmSwift.List<GoalContributor>()
    var trophyIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var type: String?
    @objc dynamic var endDate: Date?
	@objc dynamic var period: String?
    var cloudVar = RealmOptional<Bool>()
    
    convenience init(_ toCloud: Bool?) {
        self.init()
        personalID = generateID(toCloud)
        
    }
    
	convenience init(_ goalName: String, _ goalType: String, _ goalValue: Double, _ goalEndDate: Date, _ goalPeriod: String, _ goalContributors: RealmSwift.List<GoalContributor>, _ toCloud: Bool?) {
		self.init()
		personalID = generateID(toCloud)
		name = goalName
		achieved = "False"
		type = goalType
		valueToHit.value = goalValue
		endDate = goalEndDate
		period = goalPeriod
		cloudVar.value = toCloud
		progressList = goalContributors
	}
	
    convenience init(_ cloudGoal: GoalDec){
        self.init()
        personalID = cloudGoal.personalID
        name = cloudGoal.name
        achieved = cloudGoal.achieved
        type = cloudGoal.type
        valueToHit.value = cloudGoal.valueToHit
        endDate = cloudGoal.endDate
		period = cloudGoal.period
        cloudVar.value = true
        for contribution in cloudGoal.progressList ?? []{
            progressList.append(GoalContributor(contribution))
        }
        for trophy in cloudGoal.trophyIDs ?? []{
            trophyIDs.append(ItemIDWrapper(trophy))
        }
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
    
    static func equals(lhs: RealmSwift.List<Goal>?, rhs: [GoalDec]?)->Bool{
        if lhs?.count != rhs?.count{
            return false
        } else{
            for index in 0..<(rhs?.count ?? 0){
                if lhs?[index].personalID != rhs?[index].personalID || lhs?[index].valueToHit.value != rhs?[index].valueToHit || lhs?[index].name != rhs?[index].name || rhs?[index].achieved != lhs?[index].achieved || lhs?[index].endDate != rhs?[index].endDate || lhs?[index].progressList.count != rhs?[index].progressList?.count || lhs?[index].trophyIDs.count != rhs?[index].trophyIDs?.count || lhs?[index].type != rhs?[index].type{
                    return false
                } else {
                    for kindex in 0..<(rhs?[index].progressList?.count ?? 0){
                        if GoalContributor.equals(lhs?[index].progressList[kindex], rhs?[index].progressList?[kindex]){
                            return false
                        }
                    }
                    for kindex in 0..<(rhs?[index].trophyIDs?.count ?? 0){
                        if lhs?[index].trophyIDs[kindex].value != rhs?[index].trophyIDs?[kindex]{
                            return false
                        }
                    }
                }
            }
            
            return true
        }
    }
    
    static func equals(lhs: Goal?, rhs: GoalDec?)->Bool{
        
		if lhs?.personalID != rhs?.personalID || lhs?.valueToHit.value != rhs?.valueToHit || lhs?.name != rhs?.name || lhs?.achieved != rhs?.achieved || lhs?.endDate != rhs?.endDate || lhs?.period != rhs?.period || lhs?.progressList.count != rhs?.progressList?.count || lhs?.trophyIDs.count != rhs?.trophyIDs?.count || lhs?.type != rhs?.type{
            return false
        }
        for index in 0..<(rhs?.progressList?.count ?? 0){
            if GoalContributor.equals(lhs?.progressList[index], rhs?.progressList?[index]){
                return false
            }
        }
        for index in 0..<(rhs?.trophyIDs?.count ?? 0){
            if lhs?.trophyIDs[index].value != rhs?.trophyIDs?[index]{
                return false
            }
        }
            
        return true
    }
    
    static func ^ (lhs: Goal, rhs: GoalDec){
        lhs.personalID = rhs.personalID
        lhs.name = rhs.name
        lhs.achieved = rhs.achieved
        lhs.valueToHit.value = rhs.valueToHit
        lhs.cloudVar.value = true
        lhs.endDate = rhs.endDate
		lhs.period = rhs.period
        if lhs.progressList.count != 0 {
            let progressArray = Array(lhs.progressList)
            lhs.progressList.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in progressArray {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        for contribution in rhs.progressList ?? []{
            lhs.progressList.append(GoalContributor(contribution))
        }
        lhs.type = rhs.type
        if lhs.trophyIDs.count != 0 {
            let trophyList = Array(lhs.trophyIDs)
            lhs.trophyIDs.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in trophyList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        for trophy in rhs.trophyIDs ?? []{
            lhs.trophyIDs.append(ItemIDWrapper(trophy))
        }
    }
    
    static func assign (lhs: RealmSwift.List<Goal>?, rhs: [GoalDec]?){
        
        for index in 0..<(lhs?.count ?? 0){
            if lhs?[index].progressList.count != 0 {
                let progressArray = Array(lhs![index].progressList)
                lhs?[index].progressList.removeAll()
                do{
                    try AppDelegate.realm.write({
                        for item in progressArray {
                            AppDelegate.realm.delete(item)
                        }
                    })
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
            if lhs?[index].trophyIDs.count != 0 {
                let trophyList = Array(lhs![index].trophyIDs)
                lhs?[index].trophyIDs.removeAll()
                do{
                    try AppDelegate.realm.write({
                        for item in trophyList {
                            AppDelegate.realm.delete(item)
                        }
                    })
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        lhs?.removeAll()
        
        for goal in rhs ?? []{
            
            lhs?.append(Goal(goal))
        }
    }
}

class GoalContributor: Object {
    @objc dynamic var contributor: String?
    var progress = RealmOptional<Double>()
    
    required override init(){
        super.init()
    }
    
    required init(_ cloudContribution: GoalContributorDec){
        super.init()
        contributor = cloudContribution.contributor
        progress.value = cloudContribution.progress
    }
    
    static func equals(_ lhs: GoalContributor?, _ rhs: GoalContributorDec?) -> Bool{
        if lhs?.contributor != rhs?.contributor || lhs?.progress.value != rhs?.progress{
            return false
        }
        return true
    }
}
