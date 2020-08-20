//
//  GoogleUser.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/19/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import GAppAuth
import GTMAppAuth

class GoogleUser {
    var email: String!
    var accessToken: String!
    var refreshToken: String!
    var presentingViewController: UIViewController!
    var authentication: GTMAppAuthFetcherAuthorization?
    var delegate: GoogleUserDelegate!
    var hint: String!
    var scopes: [String]!{
        get{
            return GAppAuth.shared.retrieveAuthorizationRealms()
        }
        set (scopeList){
            for newScope in scopeList{
                GAppAuth.shared.appendAuthorizationRealm(newScope)
            }
        }
    }
    
    private var authorizer: GTMSessionFetcherServiceProtocol!
    
    func fetchAuthorizer() -> GTMSessionFetcherServiceProtocol{
        return authorizer
    }
    
    func setFetchAuthorizer(_ inputAuthorizer: GTMSessionFetcherServiceProtocol){
        authorizer = inputAuthorizer
    }
    
    func signIn(){
        do {
            if hint == nil {
                try GAppAuth.shared.authorize(in: presentingViewController){ auth in
                    if auth {
                        if GAppAuth.shared.isAuthorized(){
                            let authorization = GAppAuth.shared.getCurrentAuthorization()
                            self.authentication = authorization
                            let token = authorization?.authState.lastTokenResponse
                            self.accessToken = token?.accessToken
                            self.refreshToken = token?.refreshToken
                            self.email = authorization?.userEmail
                            self.delegate.signedIn(didSignInFor: self, withError: nil)
                        }
                    }
                }
            } else {
                try GAppAuth.shared.authorizeHinted(in: presentingViewController, hint: hint){ auth in
                    if auth {
                        if GAppAuth.shared.isAuthorized(){
                            let authorization = GAppAuth.shared.getCurrentAuthorization()
                            self.authentication = authorization
                            let token = authorization?.authState.lastTokenResponse
                            self.accessToken = token?.accessToken
                            self.refreshToken = token?.refreshToken
                            self.email = authorization?.userEmail
                            self.delegate.signedIn(didSignInFor: self, withError: nil)
                        }
                    }
                }
            }
        } catch let error {
            self.delegate.signedIn(didSignInFor: self, withError: error)
        }
    }
    
    func restoreSignIn(){
        GAppAuth.shared.retrieveExistingAuthorizationState()
        GoogleDriveTools.service.authorizer = GAppAuth.shared.getCurrentAuthorization()
    }
    
    func signOut(){
        GAppAuth.shared.resetAuthorizationState()
        self.delegate.signedOut(didSignOutFor: self, withError: nil)
    }
    
}
