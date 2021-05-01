//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth

class LoginViewController: UIViewController {
    
    static var sharedInstance: LoginViewController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var presenter: RegisterLoginViewController!
    var unloggedUser:Results<UnloggedUser>?
    var toGoogle = true
    var toSaveUser: UserData!
    let sem = DispatchSemaphore.init(value: 0)
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LoginViewController.sharedInstance = self
    }
    
    func updatePrevious(){
        presenter.updateUser()
        sem.signal()
    }
    
    @IBAction func signUp(_ sender: Any) {
        AppDelegate.source = "register"
        dismiss(animated: true, completion: {RegisterLoginViewController.redirect("login", self.presenter!)})
            
    }
    
    @IBAction func logMeIn(_ sender: Any) {
        
        let request = RequestManager()
        if toGoogle {
            if let user = username.text, let pass = password.text{
                
                if let incommingUser = request.loginUser(username: user, password: pass){
                    toSaveUser = incommingUser
                    GoogleSignIn.sharedInstance().presentingViewController = self
                    GoogleSignIn.sharedInstance().hint = incommingUser.googleAccountEmail
                    googleSignIn()
                } else {
                    let alert = UIAlertController(title: "Error Loging In", message: "Wrong username or password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            } else {
                let alert = UIAlertController(title: "Error Loging In", message: "You must fill all the fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        } else {
            NewUserManager.createNewCloudUser(username: toSaveUser, presenterView: self) {
                self.updatePrevious()
                self.sem.wait()
                self.presenter.controller.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func googleSignIn(){
        GoogleSignIn.sharedInstance().signIn()
    }
    
}
 
