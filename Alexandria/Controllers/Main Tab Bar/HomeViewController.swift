//
//  HomeViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/9/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

/**
 
# Related Classes:
    * AuthenticationSource **(parent class)**
 
 
# Description:
    View controller for the homescreen view of the app. All methods related to the view are stored here, no functionality
    methods are seen here, for them view:

    * HomeViewManager.swift
 
 
# Methods:
 
 viewDidLoad()
 
 preferredStatusBarStyle()

 
# Navigation Buttons:
    * profileButton:
        * Button triggers the MyProfileViewController or the RegisterLoginViewController
    * addButton:
        * Button triggers the add new file view
    * editViewButton:
        * Button triggers the Home View's editing state
    * preferencesButton:
        * Button triggers the SettingsViewController
 
# Subviews:
    * addItemView:
        * UITableView that displays options to create different files
    * fileDisplayCollection:
        * UICollectionView that displays all
    * darkeningScreen:
        * UIView that darkens screen when another subview must appear on top

# ViewController properties:
    * preferredStatusBarStyle
        * Sets the color of the status bar to white
 
*/
class HomeViewController: AuthenticationSource, GoalDisplayableControllerDelegate, TeamDisplayableControllerDelegate, FileDisplayableControllerDelegate {
    
    // Navigation Buttons
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editViewButton: UIBarButtonItem!
    @IBOutlet weak var preferencesButton: UIBarButtonItem!
    
    // Subviews
    @IBOutlet weak var displayingTable: UITableView!
    
    // Instance Variables
    var cellsToDisplay: RealmSwift.List<HomeItem>{
        get{
            return realm.objects(AlexandriaData.self)[0].home
        }
    }
    var finishedDragging = DispatchGroup()
    
    // ViewController properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        let newTapOutside = UITapGestureRecognizer(target: self, action: #selector(dismissOverlayingViews(_:)))
        newTapOutside.delegate = self
        self.view.addGestureRecognizer(newTapOutside)
    }
    
    @objc override func dismissOverlayingViews(_ gesture: UITapGestureRecognizer?){
        for cell in displayingTable.visibleCells{
            if let fileCell = cell as? HomeFileDisplayableTableViewCell{
                UIView.animate(withDuration: 0.3, animations: {
                    fileCell.sortingTable.alpha = 0
                    self.darkeningScreen.alpha = 0
                    self.addItemView.alpha = 0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.darkeningScreen.alpha = 0
                    self.addItemView.alpha = 0
                })
            }
        }
        
    }
    
    override func addButton(_ sender: Any) {
        pinClue = true
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if !(addItemKindSelected == "newFolder" || addItemKindSelected == "newCollection" || addItemKindSelected == "newGoal" || addItemKindSelected == "newTeam"){
            pinClue = true
        }
        
        if segue.identifier == "toAddItemView"{
            let destination = segue.destination as? AddItemViewController
            destination?.controller = self
        }
    }
	
	override func refreshView(){
		displayingTable.reloadData()
	}

}
