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

class AuthenticationSource: UIViewController, AddItemClueDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var googleSuccess = false
    
    var realm = try! Realm(configuration: AppDelegate.realmConfig)
    var loggedIn = false
    var registerLogin: RegisterLoginViewController? = nil
    var myProfile: MyProfileViewController? = nil
    var persistLog = false
    var tableManager: AuthenticationSourceTableManager!
    var cloudUser:Results<CloudUser>!
    var offlineUser:Results<UnloggedUser>!
    
    var addItemKindSelected: String! = ""
    var itemNameClue: String?
	var itemAuthorClue: String?
	var itemYearClue: String?
    var itemImageClue: [UIImage] = []
    var isEditingClue: Bool = false
    var itemOriginalLocationClue: URL?
    var folderClue: String?
    var collectionClues: [String]?
    var pinClue: Bool?
    var favoriteClue: Bool?
    var goalCategoryClue: String?
	var teamClues: [String]?
	var selectedCoverName: String!
	var selectedPaperName: String!
	var displayedPaperColor: String!
	var displayedOrientation: String!
	
	var latestPreferences: [PreferencesTracker] = []
	var lastSelectedTool = 0
	var selectedFileItem: FileItem!
	var lastOpenElements: [EditingFile] = []
	
    var writtingToolLastSelection = [3, 6]
    var writtingToolLastColors: [UIColor]! = [UIColor(cgColor: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)), UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1)),UIColor(cgColor: CGColor(srgbRed: 51/255, green: 175/255, blue: 218/255, alpha: 1))]
    var eraserToolLastSelection = 4
    var highlighterToolLastSelection = [3, 6]
    var highlighterToolLastColors: [UIColor]! = [UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 0.6)), UIColor(cgColor: CGColor(srgbRed: 51/255, green: 175/255, blue: 218/255, alpha: 0.6)), UIColor(cgColor: CGColor(srgbRed: 67/255, green: 233/255, blue: 71/255, alpha: 0.6))]
    
    
    
    @IBOutlet weak var addItemView: UITableView!
    @IBOutlet weak var darkeningScreen: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkeningScreen.alpha = 0
        loadAddItemView()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(cgColor: CGColor(srgbRed: 207/255, green: 223/255, blue: 229/255, alpha: 0.7))
        cloudUser = realm.objects(CloudUser.self)
        offlineUser = realm.objects(UnloggedUser.self)
        if cloudUser.count != 0 {
            loadCloudUser(cloudUser)
        } else if offlineUser.count > 0{
            loadLocalUser(offlineUser)
        } else if offlineUser.count == 0{
            loadStartingUser()
        }
        self.navigationController?.navigationBar.subviews[0].backgroundColor = UIColor(cgColor: CGColor(red: 192/255, green: 53/255, blue: 41/255, alpha: 1))
    }
    
    
    
    @IBAction func profileButton(_ sender: UIBarButtonItem) {
        
        if !loggedIn {
            
            performSegue(withIdentifier: "toRegisterLogin", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "toMyProfile", sender: self)
            
        }
        
    }
    
    @IBAction func addButton(_ sender: Any){
        pinClue = false
        folderClue = nil
		favoriteClue = favoriteClue != nil ? favoriteClue : false
        goalCategoryClue = nil
        collectionClues = nil
        dismissOverlayingViews(nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.darkeningScreen.alpha = 1
            self.addItemView.alpha = 1
        })
    }
    
    @objc func dismissOverlayingViews(_ gesture: UITapGestureRecognizer?){
        self.darkeningScreen.alpha = 0
        self.addItemView.alpha = 0
    }
    
    @IBAction func toSettings(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
	func refreshView(){
		
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
		} else if segue.identifier == "toEditingView"{
			let destination = segue.destination as? EditingViewController
			destination?.controller = self
		}
    }
    

}


