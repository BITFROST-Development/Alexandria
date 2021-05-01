//
//  RealmBooks.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class Book: Object, FileItem, InlinePickerItem {
    @objc dynamic var personalID: String?
    var collectionIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var parentID: String?
    @objc dynamic var driveID: String?
    @objc dynamic var lastModified: Date?
    @objc dynamic var name: String?
    @objc dynamic var author: String?
    @objc dynamic var year: String?
    @objc dynamic var lastOpened: Date?
    @objc dynamic var thumbnail: StoredFile?
    var trackerIDs = RealmSwift.List<ItemIDWrapper>()
    var sharingIDs = RealmSwift.List<ItemIDWrapper>()
    @objc dynamic var personalCollectionID: String?
    var currentPage = RealmOptional<Double>()
    @objc dynamic var isFavorite: String?
    var cloudVar = RealmOptional<Bool>()
    @objc dynamic var localAddress: String? = nil
	var bookmarkedPages = RealmSwift.List<ListWrapperForDouble>()
    
    convenience init(toCloud: Bool) {
        self.init()
        personalID = generateID(toCloud)
        lastModified = Date()
        let newPersonalCollection = FileCollection(nil, [personalID!], currentItemIDs: [personalID!], IconColorDec(), toCloud)
        personalCollectionID = newPersonalCollection.personalID
        isFavorite = "False"
        cloudVar.value = toCloud
    }
    
	convenience init(_ bookParentID: String, _ bookCollectionIDs: [String]?, _ bookDriveID: String?, _ bookName: String?,_ bookAuthor: String?,_ bookYear: String?, _ bookThumbnail: StoredFileDec?, _ bookTrackerIDs: RealmSwift.List<ItemIDWrapper>?, _ bookSharingIDs: RealmSwift.List<ItemIDWrapper>?, bookPersonalCollectionID: String?, _ bookIsFavorite: String?, _ bookCloudVar: Bool?, _ bookLocalAddress: String?){
        self.init()
        personalID = generateID(bookCloudVar)
		for id in bookCollectionIDs ?? []{
			collectionIDs.append(ItemIDWrapper(id))
		}
        parentID = bookParentID
        driveID = bookDriveID
        lastModified = Date()
        name = bookName
        author = bookAuthor
        year = bookYear
        thumbnail = StoredFile(bookThumbnail)
        isFavorite = bookIsFavorite
        if bookTrackerIDs != nil{
            trackerIDs.append(objectsIn: bookTrackerIDs!)
        }
        
        if bookSharingIDs != nil {
            sharingIDs.append(objectsIn: bookSharingIDs!)
        }
        personalCollectionID = bookPersonalCollectionID
        cloudVar.value = bookCloudVar
        localAddress = bookLocalAddress
    }
    
    convenience init(_ bookParentID: String, _ bookCollectionIDs: [String]?, _ bookDriveID: String?, _ bookName: String?, _ bookAuthor: String?, _ bookYear: String?, _ bookThumbnail: StoredFileDec?, _ bookTrackerIDs: RealmSwift.List<ItemIDWrapper>?, _ bookSharingIDs: RealmSwift.List<ItemIDWrapper>?, bookPersonalCollectionID: String?, _ bookIsFavorite: String?, _ bookCloudVar: Bool?, _ bookLocalAddress: String?, _ bookLastModified: Date?, _ bookLastOpened: Date?){
        self.init()
        personalID = generateID(bookCloudVar)
		for id in bookCollectionIDs ?? []{
			collectionIDs.append(ItemIDWrapper(id))
		}
        parentID = bookParentID
        driveID = bookDriveID
        lastModified = bookLastModified
        lastOpened = bookLastOpened
        name = bookName
        author = bookAuthor
        year = bookYear
        thumbnail = StoredFile(bookThumbnail)
        isFavorite = bookIsFavorite
        if bookTrackerIDs != nil{
            trackerIDs.append(objectsIn: bookTrackerIDs!)
        }
        
        if bookSharingIDs != nil {
            sharingIDs.append(objectsIn: bookSharingIDs!)
        }
        personalCollectionID = bookPersonalCollectionID
        cloudVar.value = bookCloudVar
        localAddress = bookLocalAddress
    }
    
    convenience init(_ decBook: BookDec){
        self.init()
        personalID = decBook.personalID
        parentID = decBook.parentID
        driveID = decBook.driveID
        lastModified = decBook.lastModified
        lastOpened = decBook.lastOpened
        name = decBook.name
        author = decBook.author
        year = decBook.year
        thumbnail = StoredFile(decBook.thumbnail)
        isFavorite = decBook.isFavorite
        for id in decBook.trackerIDs ?? []{
            trackerIDs.append(ItemIDWrapper(id))
        }
        
        for id in decBook.sharingIDs ?? []{
            sharingIDs.append(ItemIDWrapper(id))
        }
		
		for page in decBook.bookmarkedPages ?? []{
			self.bookmarkedPages.append(ListWrapperForDouble(page))
		}
        personalCollectionID = decBook.personalCollectionID
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
    
    func deleteInformation(){
        do{
            if localAddress != nil{
                try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(localAddress!).path)
                localAddress = nil
            }
        } catch {
            print("Could not delete file")
        }
    }
    
    static func equals (lhs: Book, rhs: BookDec) -> Bool{
        if lhs.personalID != rhs.personalID || lhs.collectionIDs.count != (rhs.collectionIDs?.count ?? 0) || lhs.parentID != rhs.parentID || lhs.driveID != rhs.driveID || lhs.lastModified != rhs.lastModified || lhs.name != rhs.name || lhs.author != rhs.author || lhs.year != rhs.year || lhs.lastOpened != rhs.lastOpened || !StoredFile.equals(lhs: lhs.thumbnail!, rhs: rhs.thumbnail!) || lhs.trackerIDs.count != (rhs.trackerIDs?.count ?? 0) || lhs.sharingIDs.count != (rhs.sharingIDs?.count ?? 0) || lhs.personalCollectionID != rhs.personalCollectionID || lhs.currentPage.value != rhs.currentPage || lhs.isFavorite != rhs.isFavorite{
            return false
        }
        
        for index in 0..<lhs.collectionIDs.count{
            if lhs.collectionIDs[index].value! != rhs.collectionIDs![index]{
                return false
            }
        }
        
        for index in 0..<lhs.trackerIDs.count{
            if lhs.trackerIDs[index].value! != rhs.trackerIDs![index]{
                return false
            }
        }
        
        for index in 0..<lhs.sharingIDs.count{
            if lhs.sharingIDs[index].value! != rhs.sharingIDs![index]{
                return false
            }
        }
        
        return true
    }
    
    static func equals(lhs: Book, rhs: Book) -> Bool{
        if lhs.personalID != rhs.personalID || lhs.collectionIDs.count != rhs.collectionIDs.count || lhs.parentID != rhs.parentID || lhs.driveID != rhs.driveID || lhs.lastModified != rhs.lastModified || lhs.name != rhs.name || lhs.author != rhs.author || lhs.year != rhs.year || lhs.lastOpened != rhs.lastOpened || !StoredFile.equals(lhs: lhs.thumbnail!, rhs: rhs.thumbnail!) || lhs.trackerIDs.count != rhs.trackerIDs.count || lhs.sharingIDs.count != rhs.sharingIDs.count || lhs.personalCollectionID != rhs.personalCollectionID || lhs.currentPage.value != rhs.currentPage.value || lhs.isFavorite != rhs.isFavorite{
            return false
        }
        
        for index in 0..<lhs.collectionIDs.count{
            if lhs.collectionIDs[index].value! != rhs.collectionIDs[index].value{
                return false
            }
        }
        
        for index in 0..<lhs.trackerIDs.count{
            if lhs.trackerIDs[index].value! != rhs.trackerIDs[index].value{
                return false
            }
        }
        
        for index in 0..<lhs.sharingIDs.count{
            if lhs.sharingIDs[index].value! != rhs.sharingIDs[index].value{
                return false
            }
        }
        
        return true
    }
    
    static func ^ (lhs: Book, rhs: BookDec){
        lhs.personalID = rhs.personalID
        lhs.parentID = rhs.parentID
        lhs.driveID = rhs.driveID
        lhs.lastModified = rhs.lastModified
        lhs.name = rhs.name
        lhs.author = rhs.author
        lhs.year = rhs.year
        lhs.lastOpened = rhs.lastOpened
        lhs.cloudVar.value = true
        lhs.personalCollectionID = rhs.personalCollectionID
        lhs.currentPage.value = rhs.currentPage
        lhs.thumbnail = StoredFile(rhs.thumbnail!)
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
        
        for index in 0..<(rhs.collectionIDs?.count ?? 0){
            lhs.collectionIDs.append(ItemIDWrapper(rhs.collectionIDs![index]))
        }
        
        for index in 0..<(rhs.trackerIDs?.count ?? 0){
            lhs.trackerIDs.append(ItemIDWrapper(rhs.trackerIDs![index]))
        }
        
        for index in 0..<(rhs.sharingIDs?.count ?? 0){
            lhs.sharingIDs.append(ItemIDWrapper(rhs.sharingIDs![index]))
        }
        
    }
    
    static func compare(lhs: Book, rhs: RealmSwift.List<Book>, presentingView: UIViewController, completion: @escaping(Bool) -> Void){
        for book in rhs {
            if Book.equals(lhs: lhs, rhs: book) {
                completion(false)
            } else if lhs.personalID == book.personalID {
                let alert = UIAlertController(title: "Warning: Merging", message: "\(lhs.name!) and \(book.name!) may have conflicting information, please choose one of the following!", preferredStyle: .alert)
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
