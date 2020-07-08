//
//  RegisterUserManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/7/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleSignIn

extension AppDelegate: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            AuthenticationSource.googleSuccess = false
        } else {
            AuthenticationSource.googleSuccess = true
        }
    }
    
    
}
