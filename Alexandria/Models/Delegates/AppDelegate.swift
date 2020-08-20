//
//  AppDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import GoogleAPIClientForREST

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var realm: Realm!
    static var socketShouldAct = true
    static var realmConfig: Realm.Configuration!
    static var source = "logIn"
    static var sharedInstance: AppDelegate!
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GoogleSignIn.sharedInstance().delegate = self
        GoogleSignIn.sharedInstance().restoreSignIn()
        AppDelegate.sharedInstance = self
        
        var config = Realm.Configuration()
        config.fileURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("bundle.realm")
        Realm.Configuration.defaultConfiguration = config
        AppDelegate.realmConfig = config
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        GoogleSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive, OIDScopeEmail]
       
        do{
            AppDelegate.realm = try Realm(configuration: config)
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AppDelegate.socketShouldAct{
            Socket.sharedInstance.establishConnection()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if AppDelegate.socketShouldAct{
            Socket.sharedInstance.closeConnection()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if GAppAuth.shared.continueAuthorization(with: url, callback: nil) {
            return true
        }
        
        return false
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            restrictRotation = .portrait
        } else {
            restrictRotation = .all
        }
        
        return self.restrictRotation
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
                LoginViewController.sharedInstance.toGoogle = false
                LoginViewController.sharedInstance.logMeIn(self)
            }
        }
    }
    
    func signedOut(didSignOutFor user: GoogleUser!, withError error: Error!) {
        GoogleSignIn.removeInstance()
    }
    
}

