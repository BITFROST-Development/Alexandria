//
//  RealmNotebooks.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class Notebook: Object, FileItem, InlinePickerItem{
    @objc dynamic var personalID: String?
    var collectionIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var parentID: String?
    @objc dynamic var driveID: String?
    @objc dynamic var lastModified: Date?
    @objc dynamic var name: String?
    @objc dynamic var author: String?
    @objc dynamic var year: String?
    @objc dynamic var lastOpened: Date?
    @objc dynamic var coverStyle: String?
    @objc dynamic var sheetDefaultStyle: String?
    @objc dynamic var sheetDefaultColor: String?
    @objc dynamic var sheetDefaultOrientation: String?
    var sheetStyleGroup = RealmSwift.List<ListWrapperForString>()
    var sheetIndexInStyleGroup = RealmSwift.List<ListWrapperForDouble>()
    var trackerIDs = RealmSwift.List<ItemIDWrapper>()
    var sharingIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var personalCollectionID: String?
    var currentPage = RealmOptional<Double>()
    @objc dynamic var isFavorite: String?
    var cloudVar = RealmOptional<Bool>()
    @objc dynamic var localAddress: String? = nil
	var bookmarkedPages = RealmSwift.List<ListWrapperForDouble>()
    
    convenience init(_ toCloud: Bool?) {
        self.init()
        personalID = generateID(toCloud)
        let newPersonalCollection = FileCollection(nil, [personalID!], currentItemIDs: [personalID!], IconColorDec(), false)
        personalCollectionID = newPersonalCollection.personalID
    }
    
    convenience init(_ noteCollectionIDs: [String]?, _ noteParentID: String?, _ noteDriveID: String?, _ noteLastModified: Date?, _ noteName: String?, _ noteAuthor: String?, _ noteYear: String?, _ noteLastOpened: Date?, _ noteCoverStyle: String?, _ noteSheetDefaultStyle: String?, _ noteSheetDefaultColor: String?, _ noteSheetDefaultOrientation: String?, _ noteSheetStyleGroup: [String]?, _ noteSheetIndexInStyleGroup: [Double]?, _ noteTrackerIDs: [String]?, _ noteSharingIDs: [String]?, _ notePersonalCollectionID: String?, _ noteCurrentPage: Double?, _ noteIsFavorite: String?, _ toCloud: Bool?, _ noteLocalAddress: String?) {
        self.init()
        personalID = generateID(toCloud)
        for id in noteCollectionIDs ?? []{
            collectionIDs.append(ItemIDWrapper(id))
        }
        parentID = noteParentID
        driveID = noteDriveID
        lastModified = noteLastModified
        name = noteName
        author = noteAuthor
        year = noteYear
        lastOpened = noteLastOpened
        coverStyle = noteCoverStyle
        sheetDefaultStyle = noteSheetDefaultStyle
        sheetDefaultColor = noteSheetDefaultColor
        sheetDefaultOrientation = noteSheetDefaultOrientation
        for style in noteSheetStyleGroup ?? []{
            sheetStyleGroup.append(ListWrapperForString(style))
        }
        for index in noteSheetIndexInStyleGroup ?? []{
            sheetIndexInStyleGroup.append(ListWrapperForDouble(index))
        }
        for id in noteTrackerIDs ?? []{
            trackerIDs.append(ItemIDWrapper(id))
        }
        for id in noteSharingIDs ?? []{
            sharingIDs.append(ItemIDWrapper(id))
        }
        personalCollectionID = notePersonalCollectionID
        currentPage.value = noteCurrentPage
        isFavorite = noteIsFavorite
        cloudVar.value = toCloud
        localAddress = noteLocalAddress
    }
    
    convenience init(_ decNote: NotebookDec) {
        self.init()
        personalID = decNote.personalID
        for id in decNote.collectionIDs ?? []{
            collectionIDs.append(ItemIDWrapper(id))
        }
        parentID = decNote.parentID
        driveID = decNote.driveID
        lastModified = decNote.lastModified
        name = decNote.name
        author = decNote.author
        year = decNote.year
        lastOpened = decNote.lastOpened
        coverStyle = decNote.coverStyle
        sheetDefaultStyle = decNote.sheetDefaultStyle
        sheetDefaultColor = decNote.sheetDefaultColor
        sheetDefaultOrientation = decNote.sheetDefaultOrientation
        for style in decNote.sheetStyleGroup ?? []{
            sheetStyleGroup.append(ListWrapperForString(style))
        }
        for index in decNote.sheetIndexInStyleGroup ?? []{
            sheetIndexInStyleGroup.append(ListWrapperForDouble(index))
        }
        for id in decNote.trackerIDs ?? []{
            trackerIDs.append(ItemIDWrapper(id))
        }
        for id in decNote.sharingIDs ?? []{
            sharingIDs.append(ItemIDWrapper(id))
        }
		for page in decNote.bookmarkedPages ?? []{
			self.bookmarkedPages.append(ListWrapperForDouble(page))
		}
        personalCollectionID = decNote.personalCollectionID
        currentPage.value = decNote.currentPage
        isFavorite = decNote.isFavorite
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
    
    static func != (lhs: Notebook, rhs: NotebookDec) -> Bool{
        if lhs.personalID != rhs.personalID || lhs.collectionIDs.count != rhs.collectionIDs!.count || lhs.parentID != rhs.parentID || lhs.driveID != rhs.driveID || lhs.isFavorite != rhs.isFavorite || lhs.name != rhs.name || lhs.author != rhs.author || lhs.year != rhs.year || lhs.lastOpened != rhs.lastOpened || lhs.trackerIDs.count != rhs.trackerIDs!.count || lhs.sharingIDs.count != rhs.sharingIDs!.count || lhs.personalCollectionID != rhs.personalCollectionID || lhs.currentPage.value != rhs.currentPage || lhs.lastModified != rhs.lastModified || lhs.coverStyle != rhs.coverStyle || lhs.sheetDefaultStyle != rhs.sheetDefaultStyle || lhs.sheetDefaultColor != rhs.sheetDefaultColor || lhs.sheetDefaultOrientation != rhs.sheetDefaultOrientation || lhs.sheetStyleGroup.count != rhs.sheetStyleGroup?.count{
            return true
        } else {
            for index in 0..<(rhs.collectionIDs?.count ?? 0){
                if lhs.collectionIDs[index].value != rhs.collectionIDs![index]{
                    return true
                }
            }
            
            for index in 0..<(rhs.trackerIDs?.count ?? 0){
                if lhs.trackerIDs[index].value != rhs.trackerIDs![index]{
                    return true
                }
            }
            
            for index in 0..<(rhs.sharingIDs?.count ?? 0){
                if lhs.sharingIDs[index].value != rhs.sharingIDs![index]{
                    return true
                }
            }
            
            for index in 0..<(rhs.sheetStyleGroup?.count ?? 0){
                if lhs.sheetStyleGroup[index].value != rhs.sheetStyleGroup![index]{
                    return true
                }
            }
            
            for index in 0..<(rhs.sheetIndexInStyleGroup?.count ?? 0){
                if lhs.sheetIndexInStyleGroup[index].value.value != rhs.sheetIndexInStyleGroup![index]{
                    return true
                }
            }
            return false
        }
    }
    
    static func ^ (lhs: Notebook, rhs: NotebookDec){
        lhs.personalID = rhs.personalID
        lhs.parentID = rhs.parentID
        lhs.driveID = rhs.driveID
        lhs.name = rhs.name
        lhs.author = rhs.author
        lhs.year = rhs.year
        lhs.lastModified = rhs.lastModified
        lhs.lastOpened = rhs.lastOpened
        lhs.coverStyle = rhs.coverStyle
        lhs.sheetDefaultStyle = rhs.sheetDefaultStyle
        lhs.sheetDefaultColor = rhs.sheetDefaultColor
        lhs.sheetDefaultOrientation = rhs.sheetDefaultOrientation
        lhs.personalCollectionID = rhs.personalCollectionID
        lhs.currentPage.value = rhs.currentPage
        lhs.cloudVar.value = true
        lhs.isFavorite = rhs.isFavorite
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
        if lhs.sheetStyleGroup.count != 0 {
            let sheetStyleGroupList = Array(lhs.sheetStyleGroup)
            lhs.sheetStyleGroup.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in sheetStyleGroupList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        if lhs.sheetIndexInStyleGroup.count != 0 {
            let sheetIndexInStyleGroupList = Array(lhs.sheetIndexInStyleGroup)
            lhs.sheetIndexInStyleGroup.removeAll()
            do{
                try AppDelegate.realm.write({
                    for item in sheetIndexInStyleGroupList {
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        for index in 0..<(rhs.collectionIDs?.count ?? 0){
            lhs.collectionIDs.append(ItemIDWrapper(rhs.collectionIDs![index]))
        }
        
        for index in 0..<(rhs.trackerIDs?.count ?? 0){
            lhs.trackerIDs.append(ItemIDWrapper(rhs.trackerIDs![index]))
        }
        
        for index in 0..<(rhs.sharingIDs?.count ?? 0){
            lhs.sharingIDs.append(ItemIDWrapper(rhs.sharingIDs![index]))
        }
        
        for index in 0..<(rhs.sheetStyleGroup?.count ?? 0){
            lhs.sheetStyleGroup.append(ListWrapperForString(rhs.sheetStyleGroup![index]))
        }
        for height in rhs.sheetIndexInStyleGroup ?? []{
            lhs.sheetIndexInStyleGroup.append(ListWrapperForDouble(height))
        }
    }
}

