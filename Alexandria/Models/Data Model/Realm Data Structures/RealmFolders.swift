//
//  RealmFolders.swift
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
    Folder of  files within the app.
 
 # Methods
    init()
    init(folderParentID, folderChildrenIDs, folderColor, folderName, toCloud)
    generateID(cloud)
    randomString()
 
 # Static Methods
    ^
 
 # Instance Variables
    * personalID:
        * BITFROST generated ID to keep track of folder
    * parentID:
        * ID of immediate parent to the folder
    * childrenIDs:
        * List of IDs of files belonging to the folder
    * color:
        * Color of the folder
    * name:
        * Name of the collection
    * cloudVar:
        * Signals whether the folder is synced with the cloud
 */
class Folder: Object, FolderItem, InlinePickerItem{
    @objc dynamic var personalID: String?
    @objc dynamic var parentID: String?
    var childrenIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var color: IconColor?
    @objc dynamic var lastModified: Date?
    @objc dynamic var name: String?
    @objc dynamic var isFavorite: String?
    var sharingIDs = RealmSwift.List<ItemIDWrapper>()
    var cloudVar = RealmOptional<Bool>()
    
    
    convenience init(_ folderParentID: String?, _ folderLastModified: Date?, _ folderChildrenIDs: [String]?, _ folderColor: IconColorDec?, folderName: String?, _ folderIsFavorite: String?, _ folderSharingIDs: [String]?, _ toCloud: Bool?){
        self.init()
        self.personalID = generateID(toCloud)
        self.parentID = folderParentID
        for child in folderChildrenIDs ?? []{
            self.childrenIDs.append(ItemIDWrapper(child))
        }
        if folderColor != nil {
            self.color = IconColor(from: folderColor!)
        }
        self.name = folderName
        self.isFavorite = folderIsFavorite
        self.lastModified = folderLastModified
        self.cloudVar.value = toCloud
        
        for id in folderSharingIDs ?? []{
            self.sharingIDs.append(ItemIDWrapper(id))
        }
    }
    
    convenience init(_ decFolder: FolderDec) {
        self.init()
        self.personalID = decFolder.personalID
        self.parentID = decFolder.parentID
        for child in decFolder.childrenIDs ?? []{
            self.childrenIDs.append(ItemIDWrapper(child))
        }
        if decFolder.color != nil {
            self.color = IconColor(from: decFolder.color!)
        }
        self.name = decFolder.name
        self.isFavorite = decFolder.isFavorite
        self.lastModified = decFolder.lastModified
        self.cloudVar.value = true
        
        for id in decFolder.sharingIDs ?? []{
            self.sharingIDs.append(ItemIDWrapper(id))
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
    
    static func != (lhs: Folder, rhs: FolderDec) -> Bool{
        if lhs.personalID != rhs.personalID || lhs.lastModified != rhs.lastModified || lhs.parentID != rhs.parentID || lhs.name != rhs.name || lhs.childrenIDs.count != rhs.childrenIDs?.count || !IconColor.equals(lhs.color, rhs.color){
            return true
        }
        
        for index in 0..<(rhs.childrenIDs?.count ?? 0){
            if lhs.childrenIDs[index].value != rhs.childrenIDs![index] {
                return true
            }
        }
        
        return false
    }
    
    static func ^ (lhs: Folder, rhs: FolderDec){
        lhs.personalID = rhs.personalID
        lhs.parentID = rhs.parentID
        let childrenToDelete = Array(lhs.childrenIDs)
        lhs.childrenIDs.removeAll()
        lhs.lastModified = rhs.lastModified
        for child in rhs.childrenIDs ?? []{
            lhs.childrenIDs.append(ItemIDWrapper(child))
        }
        if lhs.color != nil && rhs.color != nil{
            lhs.color! ^ rhs.color!
        } else if rhs.color != nil{
            lhs.color = IconColor(from: rhs.color!)
        }
        
        lhs.name = rhs.name
        lhs.isFavorite = rhs.isFavorite
        do{
            try AppDelegate.realm.write({
                for child in childrenToDelete{
                    AppDelegate.realm.delete(child)
                }
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
