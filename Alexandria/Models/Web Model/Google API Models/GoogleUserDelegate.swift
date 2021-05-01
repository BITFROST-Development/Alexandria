//
//  GoogleUserDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/19/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import GTMAppAuth
import GTMSessionFetcher

protocol GoogleUserDelegate {
    func signedIn(didSignInFor user: GoogleUser!, withError error: Error!)
    func signedOut(didSignOutFor user: GoogleUser!, withError error: Error!)
}
