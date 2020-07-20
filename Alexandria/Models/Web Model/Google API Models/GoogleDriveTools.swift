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
                if book.title == name {
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
    
    static func retrieveFileFromDrive(id: String, name: String, service: GTLRDriveService){
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: id)
        
        service.executeQuery(query){ (_, file, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            if let data = (file as? GTLRDataObject)?.data {
                if !FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books/\(name)"){
                    FileManager.default.createFile(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books\(name)", contents: data, attributes: nil)
                } else {
                    do {
                        try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books/\(name)")
                        FileManager.default.createFile(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/Books\(name)", contents: data, attributes: nil)
                    } catch{
                        print("file couldn't be deleted")
                    }
                }
            } else {
                print("unable to retrieve data at the moment")
            }
        }
    }
    
    static func updateFile(name: String, id: String, fileURL: URL, mimeType: String, parent: String, service: GTLRDriveService){
        deleteFile(service: service, id: id, local: false)
        uploadFileToDrive(name: name, fileURL: fileURL, mimeType: mimeType, parent: parent, service: service)
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
}
