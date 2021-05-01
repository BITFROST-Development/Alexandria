//
//  RealmTermSets.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class TermSet: Object, FileItem, InlinePickerItem{
    @objc dynamic var personalID: String?
    var collectionIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var parentID: String?
    @objc dynamic var lastModified: Date?
    @objc dynamic var name: String?
    @objc dynamic var author: String?
    @objc dynamic var year: String?
    @objc dynamic var lastOpened: Date?
    @objc dynamic var color: IconColor?
    var terms = RealmSwift.List<Term>()
    var trackerIDs = RealmSwift.List<ItemIDWrapper>()
    var sharingIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var personalCollectionID: String?
    @objc dynamic var isFavorite: String?
    var cloudVar = RealmOptional<Bool>()
    
    convenience init(_ toCloud: Bool?){
        self.init()
        personalID = generateID(toCloud)
        let newPersonalCollection = FileCollection(nil, [personalID!], currentItemIDs: [personalID!], IconColorDec(), false)
        personalCollectionID = newPersonalCollection.personalID
    }
    
    convenience init(_ setCollectionIDs: [String]?, _ setParentID: String?, _ setLastModified: Date?, _ setName: String?, _ setAuthor: String?, _ setYear: String?, _ setLastOpened: Date?, _ setColor: IconColorDec?, _ setTerms: [TermDec]?, _ setTrackerIDs: [String]?, _ setSharingIDs: [String]?, _ setPersonalCollectionID: String?, _ setIsFavorite: String?, _ toCloud: Bool?){
        self.init()
        personalID = generateID(toCloud)
        for id in setCollectionIDs ?? []{
            collectionIDs.append(ItemIDWrapper(id))
        }
        lastModified = setLastModified
        name = setName
        author = setAuthor
        year = setYear
        lastOpened = setLastOpened
        color = IconColor(from: setColor!)
        for term in setTerms ?? []{
            terms.append(Term(term))
        }
        for id in setTrackerIDs ?? []{
            trackerIDs.append(ItemIDWrapper(id))
        }
        
        for id in setSharingIDs ?? []{
            sharingIDs.append(ItemIDWrapper(id))
        }
        personalCollectionID = setPersonalCollectionID
        isFavorite = setIsFavorite
        cloudVar.value = toCloud
    }
    
    convenience init(_ decSet: TermSetDec){
        self.init()
        personalID = decSet.personalID
        for id in decSet.collectionIDs ?? []{
            collectionIDs.append(ItemIDWrapper(id))
        }
        lastModified = decSet.lastModified
        name = decSet.name
        author = decSet.author
        year = decSet.year
        lastOpened = decSet.lastOpened
        color = IconColor(from: decSet.color!)
        for term in decSet.terms ?? []{
            terms.append(Term(term))
        }
        for id in decSet.trackerIDs ?? []{
            trackerIDs.append(ItemIDWrapper(id))
        }
        
        for id in decSet.sharingIDs ?? []{
            sharingIDs.append(ItemIDWrapper(id))
        }
        personalCollectionID = decSet.personalCollectionID
        isFavorite = decSet.isFavorite
        cloudVar.value = true
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
    
    static func equals (_ lhs: TermSet, _ rhs: TermSetDec) -> Bool {
        if lhs.personalID != rhs.personalID || lhs.collectionIDs.count != rhs.collectionIDs!.count || lhs.parentID != rhs.parentID || lhs.lastModified != rhs.lastModified || lhs.name != rhs.name || lhs.author != rhs.author || lhs.year != rhs.year || lhs.isFavorite != rhs.isFavorite || lhs.lastOpened != rhs.lastOpened || lhs.trackerIDs.count != rhs.trackerIDs?.count || lhs.sharingIDs.count != rhs.sharingIDs?.count || lhs.personalCollectionID != rhs.personalCollectionID || lhs.terms.count != rhs.terms?.count || !IconColor.equals(lhs.color, rhs.color){
            return false
        } else{
            for index in 0..<(rhs.collectionIDs?.count ?? 0){
                if lhs.collectionIDs[index].value != rhs.collectionIDs![index]{
                    return false
                }
            }
            
            for index in 0..<(rhs.trackerIDs?.count ?? 0){
                if lhs.trackerIDs[index].value != rhs.trackerIDs![index]{
                    return false
                }
            }
            
            for index in 0..<(rhs.sharingIDs?.count ?? 0){
                if lhs.sharingIDs[index].value != rhs.sharingIDs![index]{
                    return false
                }
            }
            
            for index in 0..<(rhs.terms?.count ?? 0){
                if !Term.equals(lhs.terms[index], rhs.terms![index]){
                    return false
                }
            }
            
            return true
        }
    }
    
    static func ^ (_ lhs: TermSet, _ rhs: TermSetDec){
        lhs.personalID = rhs.personalID
        lhs.parentID = rhs.parentID
        lhs.lastModified = rhs.lastModified
        lhs.name = rhs.name
        lhs.author = rhs.author
        lhs.year = rhs.year
        lhs.isFavorite = rhs.isFavorite
        lhs.cloudVar.value = true
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
        lhs.personalCollectionID = rhs.personalCollectionID
        if lhs.terms.count != 0 {
            let termList = Array(lhs.terms)
            lhs.terms.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in termList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        if lhs.collectionIDs.count != 0 {
            let collectionIDList = Array(lhs.collectionIDs)
            lhs.collectionIDs.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in collectionIDList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        if lhs.trackerIDs.count != 0 {
            let trackerIDList = Array(lhs.trackerIDs)
            lhs.trackerIDs.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in trackerIDList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        if lhs.sharingIDs.count != 0 {
            let sharingIDList = Array(lhs.sharingIDs)
            lhs.sharingIDs.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in sharingIDList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        for collection in rhs.collectionIDs ?? []{
            lhs.collectionIDs.append(ItemIDWrapper(collection))
        }
        
        for tracker in rhs.trackerIDs ?? []{
            lhs.trackerIDs.append(ItemIDWrapper(tracker))
        }
        
        for sharer in rhs.sharingIDs ?? []{
            lhs.sharingIDs.append(ItemIDWrapper(sharer))
        }
        
        for index in 0..<(rhs.terms?.count ?? 0){
            lhs.terms.append(Term())
            lhs.terms[index] ^ rhs.terms![index]
        }
    }
}

class Term: Object{
    @objc dynamic var value: String?
    @objc dynamic var definition: String?
    
    required override init() {
        super.init()
    }
    
    required init(_ decTerm: TermDec){
        value = decTerm.value
        definition = decTerm.definition
    }
    
    static func equals(_ lhs: Term,_ rhs: TermDec) -> Bool{
        if lhs.value != rhs.value || lhs.definition != rhs.definition {
            return false
        }
        return true
    }
    
    static func ^ (_ lhs: Term, _ rhs: TermDec){
        lhs.value = rhs.value
        lhs.definition = rhs.definition
    }
    
}
