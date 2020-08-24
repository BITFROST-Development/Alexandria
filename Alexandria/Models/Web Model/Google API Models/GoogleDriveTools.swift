//
//  GoogleGeneralTools.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/8/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import GoogleAPIClientForREST

class GoogleDriveTools {
    static let service = GTLRDriveService()
    
    static func uploadFileToDrive(name: String, fileURL: URL, mimeType: String, parent: String, service: GTLRDriveService) {
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [parent]
        
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            let realm = try! Realm(configuration: AppDelegate.realmConfig)
            let books = realm.objects(Book.self)
            for book in books {
                if book.title! == name {
                    do{
                        try realm.write(){
                            book.id = (result as? GTLRDrive_File)?.identifier
                        }
                    } catch {
                        print("couldn't add id")
                    }
                    break
                }
            }
        }
    }
    
    static func uploadFileToDrive(fileName: String, bookTitle: String, fileURL: URL, mimeType: String, parent: String, service: GTLRDriveService, completion: @escaping(Bool) -> Void) {
        let file = GTLRDrive_File()
        file.name = fileName
        file.parents = [parent]
        
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            let realm = try! Realm(configuration: AppDelegate.realmConfig)
            let books = realm.objects(Book.self)
            for book in books {
                if book.title! == bookTitle {
                    do{
                        try realm.write(){
                            book.id = (result as? GTLRDrive_File)?.identifier
                        }
                        completion(true)
                    } catch {
                        print("couldn't add id")
                        completion(false)
                    }
                    break
                }
            }
        }
    }
    
    static func retrieveBookFromDrive(id: String, name: String, service: GTLRDriveService, completion: @escaping(Bool) -> Void){
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: id)
        
        service.executeQuery(query){ (_, file, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            if let data = (file as? GTLRDataObject)?.data {
                if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books"){
                    if !FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books/\(name)"){
                        completion(FileManager.default.createFile(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books/\(name)", contents: data, attributes: nil))
                        
                    } else {
                        do {
                            try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books/\(name)")
                            completion(FileManager.default.createFile(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books/\(name)", contents: data, attributes: nil))
                        } catch{
                            print("file couldn't be deleted")
                        }
                    }
                } else {
                    do{
                        try FileManager.default.createDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books", withIntermediateDirectories: true, attributes: nil)
                        completion(FileManager.default.createFile(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/Books/\(name)", contents: data, attributes: nil))
                    } catch let error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            } else {
                print("unable to retrieve data at the moment")
            }
        }
    }
    
    static func retrieveFileData(id: String, mimeType: String, service: GTLRDriveService, completion: @escaping(Data?) -> Void){
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: id)
        
        service.executeQuery(query){ (_, file, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            if let data = (file as? GTLRDataObject)?.data {
                completion(data)
            } else {
                print("unable to retrieve data at the moment")
                completion(nil)
            }
        }
    }
    
    static func nonLocalFileChange(name: String, bookTitle: String, fileData: Data, mimeType: String, parent: String, service: GTLRDriveService, completion: @escaping(Bool) -> Void){
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [parent]
        
        let uploadParameters = GTLRUploadParameters(data: fileData, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            let realm = try! Realm(configuration: AppDelegate.realmConfig)
            let books = realm.objects(Book.self)
            for book in books {
                if book.title! == bookTitle {
                    do{
                        try realm.write(){
                            book.id = (result as? GTLRDrive_File)?.identifier
                        }
                        completion(true)
                    } catch {
                        print("couldn't add id")
                        completion(false)
                    }
                    break
                }
            }
        }
    }
    
    static func updateFile(name: String, bookTitle: String,id: String, fileURL: URL?, mimeType: String, parent: String, service: GTLRDriveService, completion: @escaping(Bool) -> Void){
        if fileURL == nil {
            GoogleDriveTools.retrieveFileData(id: id, mimeType: mimeType, service: GoogleDriveTools.service){ data in
                deleteFile(service: service, id: id, local: false){ success in
                    nonLocalFileChange(name: name, bookTitle: bookTitle, fileData: data!, mimeType: mimeType, parent: parent, service: service){ success in
                        completion(success)
                    }
                }
            }
        } else {
            deleteFile(service: service, id: id, local: false){ success in
                if success {
                    uploadFileToDrive(fileName: name, bookTitle: bookTitle ,fileURL: fileURL!, mimeType: mimeType, parent: parent, service: service){ success in
                        completion(success)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func deleteFile(service: GTLRDriveService, id: String, local: Bool){
        let file = GTLRDrive_File()
        file.identifier = id
        
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: id)
        service.executeQuery(query){ (_, deletedFile, error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            
            let realm = try! Realm(configuration: AppDelegate.realmConfig)
            let books = realm.objects(Book.self)
            for book in books {
                if book.id == id {
                    if !local {
                        do{
                            try realm.write(){
                                book.id = nil
                            }
                        } catch {
                            print("couldn't remove id")
                        }
                        break
                    } else {
                        do{
                            try realm.write(){
                                realm.delete(book)
                            }
                        } catch {
                            print("couldn't remove id")
                        }
                        break
                    }
                }
            }
        }
    }

    static func deleteFile(service: GTLRDriveService, id: String, local: Bool, completion: @escaping(Bool) -> Void){
        let file = GTLRDrive_File()
        file.identifier = id
        
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: id)
        service.executeQuery(query){ (_, deletedFile, error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            
            let realm = try! Realm(configuration: AppDelegate.realmConfig)
            let books = realm.objects(Book.self)
            for book in books {
                if book.id == id {
                    if !local {
                        do{
                            try realm.write(){
                                book.id = nil
                            }
                            completion(true)
                        } catch {
                            print("couldn't remove id")
                        }
                        break
                    } else {
                        do{
                            try realm.write(){
                                realm.delete(book)
                            }
                            completion(true)
                        } catch {
                            print("couldn't remove id")
                        }
                        break
                    }
                }
            }
        }
    }
    
    static func findExistingFolder(parents: String, name: String, service: GTLRDriveService, user: GoogleUser, completion: @escaping(String?) -> Void ){
        let query = GTLRDriveQuery_FilesList.query()
        query.spaces = "drive"
        query.corpora = "user"
        
        
        let withName = "name = '\(name)'" // Case insensitive!
        let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
        let parent = "'\(parents)' in parents"
        let ownedByUser = "'\(user.email!)' in owners"
        query.q = "\(withName) and \(foldersOnly) and \(ownedByUser) and \(parent)"
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
                                     
            let folderList = result as! GTLRDrive_FileList
            completion(folderList.files?.first?.identifier)
        }
    }
    
    static func createFolder(parent: String, name: String, service: GTLRService, completion: @escaping(String) -> Void ){
        let seekedFolder = GTLRDrive_File()
        seekedFolder.mimeType = "application/vnd.google-apps.folder"
        seekedFolder.name = name
        seekedFolder.parents = [parent]
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: seekedFolder, uploadParameters: nil)
        service.executeQuery(query){ (_, file, error) in
            guard error == nil
            else {
                fatalError(error!.localizedDescription)
            }
            
            let folder = file as! GTLRDrive_File
            completion(folder.identifier!)
        }
    }
    
    static func createFolderForClient(parent: String, name: String, completion: @escaping(String) -> Void){
        findExistingFolder(parents: parent, name: name, service: GoogleDriveTools.service, user: GoogleSignIn.sharedInstance()) { folderID in
            
            if folderID == nil{
                self.createFolder(parent: parent, name: name, service: GoogleDriveTools.service){ folder in
                    completion(folder)
                }
            } else {
                completion(folderID!)
            }
        }
    }
}
