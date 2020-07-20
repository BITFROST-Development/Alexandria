//
//  RegisterUserManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/7/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import GoogleAPIClientForREST
import GTMSessionFetcher

extension RegisterViewController {
    func signInGoogle(){
        GoogleSignIn.sharedInstance().presentingViewController = self
        GoogleSignIn.sharedInstance().signIn()
//        while AuthenticationSource.googleSuccess != true {
//            print("waiting for authentication")
//        }
    }
    
    func findExistingFolder(parents: String, name: String, service: GTLRDriveService, user: GoogleUser, completion: @escaping(String?) -> Void ){
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
    
    func createFolder(parent: String, name: String, service: GTLRService, completion: @escaping(String) -> Void ){
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
    
    func createFolderForClient(parent: String, name: String, completion: @escaping(String) -> Void){
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

extension AppDelegate: GoogleUserDelegate{
    func signedIn(didSignInFor user: GoogleUser!, withError error: Error!) {
        if let _ = error {
            AuthenticationSource.googleSuccess = false
            RegisterViewController.sharedInstance.googleFailed()
            
        } else {
            if AppDelegate.source == "register" {
                RegisterViewController.toGoogle = false
                AuthenticationSource.googleSuccess = true
                GoogleDriveTools.service.authorizer = user.authentication
                RegisterViewController.sharedInstance.registerUser(self)
            } else {
                AuthenticationSource.googleSuccess = true
                GoogleDriveTools.service.authorizer = user.authentication
            }
        }
    }
    
    func signedOut(didSignOutFor user: GoogleUser!, withError error: Error!) {
        GoogleSignIn.removeInstance()
    }
    
}
