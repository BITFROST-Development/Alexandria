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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var googleSuccess = false
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    var loggedIn = false
    var registerLogin: RegisterLoginViewController? = nil
    var myProfile: MyProfileViewController? = nil
    var persistLog = false
    var cloudUser:Results<CloudUser>!
    var offlineUser:Results<UnloggedUser>!
    var writtingToolLastSelection = [3, 6]
    var writtingToolLastColors: [UIColor]! = [UIColor(cgColor: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)), UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1)),UIColor(cgColor: CGColor(srgbRed: 51/255, green: 175/255, blue: 218/255, alpha: 1))]
    var eraserToolLastSelection = 4
    var highlighterToolLastSelection = [3, 6]
    var highlighterToolLastColors: [UIColor]! = [UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 0.6)), UIColor(cgColor: CGColor(srgbRed: 51/255, green: 175/255, blue: 218/255, alpha: 0.6)), UIColor(cgColor: CGColor(srgbRed: 67/255, green: 233/255, blue: 71/255, alpha: 0.6))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(cgColor: CGColor(srgbRed: 207/255, green: 223/255, blue: 229/255, alpha: 0.7))
        cloudUser = realm.objects(CloudUser.self)
        offlineUser = realm.objects(UnloggedUser.self)
        if cloudUser.count != 0 {
            let alexandria = cloudUser[0].alexandriaData!
            writtingToolLastColors = [UIColor(red: CGFloat(alexandria.defaultWritingToolColor01!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor01!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor01!.blue.value!), alpha: 1), UIColor(red: CGFloat(alexandria.defaultWritingToolColor02!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor02!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor02!.blue.value!), alpha: 1), UIColor(red: CGFloat(alexandria.defaultWritingToolColor03!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor03!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor03!.blue.value!), alpha: 1)]
            persistLog = true
            loggedIn = true
            RegisterLoginViewController.loggedIn = true
            GoogleSignIn.sharedInstance().restoreSignIn()
            GoogleSignIn.sharedInstance().email = cloudUser[0].googleAccountEmail
            let socket = Socket.sharedInstance
            socket.connectWithUsername(username: cloudUser[0].username)
            socket.establishConnection()
        } else if offlineUser.count == 0{
            persistLog = true
            loggedIn = false
            
            let newUnloggedUser = UnloggedUser()
            newUnloggedUser.alexandriaData!.defaultCoverStyle = "notebookPlain01"
            newUnloggedUser.alexandriaData!.defaultPaperStyle = "notebookPaperBlank01"
            newUnloggedUser.alexandriaData!.defaultPaperColor = "Yellow"
            newUnloggedUser.alexandriaData!.defaultPaperOrientation = "Portrait"
            newUnloggedUser.alexandriaData!.defaultWritingToolThickness03.value = 0.3
            newUnloggedUser.alexandriaData!.defaultWritingToolThickness02.value = 0.7
            newUnloggedUser.alexandriaData!.defaultWritingToolThickness01.value = 1.5
            newUnloggedUser.alexandriaData!.defaultWritingToolColor03 = IconColor(red: 0, green: 0, blue: 0, name: "#000000")
            newUnloggedUser.alexandriaData!.defaultWritingToolColor02 = IconColor(red: 192/255, green: 53/255, blue: 41/255, name: "#C03629")
            newUnloggedUser.alexandriaData!.defaultWritingToolColor01 = IconColor(red: 51/255, green: 175/255, blue: 218/255, name: "#33B0DA")
            
            let newBookHash = BookToListMap()
            
            do {
                try realm.write(){
                    realm.add(newUnloggedUser)
                    realm.add(newBookHash)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func profileButton(_ sender: UIBarButtonItem) {
        
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
            registerLogin?.controller = self
        } else if segue.identifier == "toMyProfile" {
            myProfile = segue.destination as? MyProfileViewController
            myProfile?.controller = self
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
