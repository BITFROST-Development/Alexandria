//
//  RealmCollections.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

/**
 # Related Classes
    Object

 # Related Protocols
    DocumentItem

 # Description
    Collection of related files within the app. Works similarly to tags.
 
 # Instance Methods
    init()
    init(collectionName, items, toCloud)
    init(collectionName, items, currentItemIDs, toCloud)
    generateID(cloud)
    generateID(excluding, cloud)
    randomString()
 
 # Static Methods
    ^
 
 # Instance Variables
    * personalID:
        * BITFROST generated ID to keep track of collection
    * childrenIDs:
        * List of IDs of files belonging to the collection
    * name:
        * Name of the collection
    * cloudVar:
        * Signals whether the collection is synced with the cloud
 */
class FileCollection: Object, DocumentItem, InlinePickerItem{
    @objc dynamic var personalID: String?
    var childrenIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var name: String?
    @objc dynamic var color: IconColor?
    var cloudVar = RealmOptional<Bool>()
    
	convenience init(_ collectionName: String?, _ toCloud: Bool?) {
		self.init()
		personalID = generateID(toCloud)
		name = collectionName
		color = IconColor(from: IconColorDec())
	}
	
    convenience init(_ collectionName: String?, _ items: [String]?, _ collectionColor: IconColorDec?, _ toCloud: Bool?) {
        self.init()
        personalID = generateID(toCloud)
        for id in items ?? []{
            childrenIDs.append(ItemIDWrapper(id))
        }
        color = IconColor(from: collectionColor!)
        name = collectionName
    }
    
    convenience init(_ collectionName: String?, _ items: [String]?, currentItemIDs: [String], _ collectionColor: IconColorDec?, _ toCloud: Bool?) {
        self.init()
        personalID = generateID(currentItemIDs, toCloud)
        for id in items ?? []{
            childrenIDs.append(ItemIDWrapper(id))
        }
        color = IconColor(from: collectionColor!)
        name = collectionName
    }
    
    convenience init(_ decCollection: FileCollectionDec) {
        self.init()
        personalID = decCollection.personalID
        for id in decCollection.childrenIDs ?? []{
            childrenIDs.append(ItemIDWrapper(id))
        }
        name = decCollection.name
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
    
    static func ^ (lhs: FileCollection, rhs: FileCollectionDec){
        lhs.personalID = rhs.personalID
        lhs.name = rhs.name
        lhs.cloudVar.value = true
        if lhs.childrenIDs.count != 0 {
            let childrenIDList = Array(lhs.childrenIDs)
            lhs.childrenIDs.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in childrenIDList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
}
