//
//  AuthenticationSource.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/23/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth

class AuthenticationSource: UIViewController {
    
    static var googleSuccess = false
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var loggedIn = false
    var registerLogin: RegisterLoginViewController? = nil
    var myProfile: MyProfileViewController? = nil
    var persistLog = false
    var cloudUser:Results<CloudUser>!
    var offlineUser:Results<UnloggedUser>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(cgColor: CGColor(srgbRed: 66/255, green: 33/255, blue: 11/255, alpha: 0.4))
        
        cloudUser = realm.objects(CloudUser.self)
        offlineUser = realm.objects(UnloggedUser.self)
        if cloudUser.count != 0 {
            persistLog = true
            loggedIn = true
            RegisterLoginViewController.loggedIn = true
            GoogleSignIn.sharedInstance().restoreSignIn()
            Socket.sharedInstance.establishConnection()
        }
        else if offlineUser.count == 0{
            persistLog = true
            loggedIn = false
            
            let newUnloggedUser = UnloggedUser()
            
            do {
                try realm.write(){
                    realm.add(newUnloggedUser)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func profileButton(_ sender: UIBarButtonItem) {
        
        loggedIn = RegisterLoginViewController.loggedIn
        
        if !loggedIn {
            
            performSegue(withIdentifier: "toRegisterLogin", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "toMyProfile", sender: self)
            
        }
        
    }
    
    
    @IBAction func toSettings(_ sender: Any) {
        
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegisterLogin" {
            print("")
            registerLogin = segue.destination as? RegisterLoginViewController
        
        } else if segue.identifier == "toMyProfile" {
            
            myProfile = segue.destination as? MyProfileViewController
            myProfile!.currentUser = cloudUser[0]
        
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
