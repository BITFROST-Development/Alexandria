//
//  GoogleSignInTools.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/19/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import GTMAppAuth
import GTMSessionFetcher

class GoogleSignIn {
    
    private static var instance: GoogleUser?
    
    static func sharedInstance() -> GoogleUser{
        if GoogleSignIn.instance == nil{
            GoogleSignIn.instance = GoogleUser()
            return GoogleSignIn.instance!
        } else {
            return GoogleSignIn.instance!
        }
    }
    
    static func removeInstance() {
        instance = nil
    }
}


