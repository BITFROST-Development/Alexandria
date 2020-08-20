//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyShelvesViewController: AuthenticationSource {
    
    var addNewElementViewIsPresent = false
    var shelvesListIsPresent = false
    var shelfPrepreferencesIsPresent = false
    var originalBookURL: URL!
    var newBookURL: URL!
    let manager = MyShelvesManager()
    let preferencesManager = MyShelvesPreferencesManager()
    let sem = DispatchSemaphore.init(value: 0)
    var swipeToDismiss: UIPanGestureRecognizer!
    var swipeToPresent: UIScreenEdgePanGestureRecognizer!
    var selectedShelfIndex = -1
    var cloudShelf = false
    var currentBook: Book?
    var currentBookIndex: Int?
    var currentBookCloudStatus: Bool?
    var currentShelf: Shelf?
    @IBOutlet weak var shelfName: UIButton!
    @IBOutlet weak var shelfCollectionView: UICollectionView!
    @IBOutlet weak var addNewElementTableView: UITableView!
    @IBOutlet weak var shelfPrePreferencesTableView: UITableView!
    @IBOutlet weak var opacityFilter: UIView!
    @IBOutlet weak var shelvesList: MyShelvesTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Socket.sharedInstance.delegate = self
        GoogleSignIn.sharedInstance().restoreSignIn()
        manager.viewController = self
        preferencesManager.viewController = self
        shelfName.setTitle("All my books", for: .normal)
        opacityFilter.alpha = 0.0
        prepareAddItemTableView()
        prepareShelfPrePreferencesTableView()
        prepareShelvesLists()
        shelvesList.controller = self
        prepareShelfCollectionView()
        swipeToPresent = UIScreenEdgePanGestureRecognizer(target: shelvesList, action: #selector(shelvesList.swipePresent(_:)))
        swipeToPresent.edges = .left
        swipeToDismiss = UIPanGestureRecognizer(target: shelvesList, action: #selector(shelvesList.swipeDismiss(_:)))
        let dismissControll = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dismissControll.numberOfTapsRequired = 1
        dismissControll.numberOfTouchesRequired = 1
        dismissControll.delegate = self
        manager.loggedIn = loggedIn
        preferencesManager.loggedIn = loggedIn
        self.view.addGestureRecognizer(dismissControll)
        swipeToDismiss.delegate = shelvesList
        swipeToPresent.delegate = shelvesList
        shelvesList.addGestureRecognizer(swipeToDismiss)
        self.view.addGestureRecognizer(swipeToPresent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
    
    @IBAction func shelfPrePreferences(_ sender: Any) {
        if shelfName.currentTitle != "All my books" {
            if !shelfPrepreferencesIsPresent{
                UIView.animate(withDuration: 0.3, animations: {
                    self.shelfPrePreferencesTableView.alpha = 1.0
                    self.opacityFilter.alpha = 1.0
                })
                shelfPrepreferencesIsPresent = true
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.shelfPrePreferencesTableView.alpha = 0.0
                    self.opacityFilter.alpha = 0.0
                })
                shelfPrepreferencesIsPresent = false
            }
            
            if shelvesListIsPresent {
                UIView.animate(withDuration: 0.3, animations: {
                    self.shelvesList.layer.frame.origin.x = 0 - self.shelvesList.layer.frame.width
                })
                shelvesListIsPresent = false
                shelvesList.beginUpdates()
                let cells = shelvesList.visibleCells
                for index in 0..<cells.count{
                    if index > 1{
                        let cell = cells[index] as! ShelfListCell
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.moreButton.layer.frame.origin.x = cell.layer.frame.width
                            cell.deleteButton.layer.frame.origin.x = cell.layer.frame.width
                        })
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.widthConstraint.constant = cell.layer.frame.width - 32
                            cell.layoutIfNeeded()
                        })
                    } else if index == 0 {
                        let cell = cells[index] as! ShelvesListTitleCell
                        UIView.animate(withDuration: 0.2, animations: {
                            cell.editButton.alpha = 1.0
                        })
                        cell.backDoneButton.setTitle("Back", for: .normal)
                        cell.backDoneButton.tintColor = .black
                        cell.isEditMode = false
                    }
                }
                shelvesList.endUpdates()
            }
            
            if addNewElementViewIsPresent{
                UIView.animate(withDuration: 0.3, animations: {
                    self.addNewElementTableView.alpha = 0.0
                })
                addNewElementViewIsPresent = false
            }
        }
        
    }
    
    @IBAction func addNewElement(_ sender: UIBarButtonItem) {
        if !addNewElementViewIsPresent {
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewElementTableView.alpha = 1.0
                self.opacityFilter.alpha = 1.0
            })
            addNewElementViewIsPresent = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewElementTableView.alpha = 0.0
                self.opacityFilter.alpha = 0.0
            })
            addNewElementViewIsPresent = false
        }
        
        if shelvesListIsPresent {
            UIView.animate(withDuration: 0.3, animations: {
                self.shelvesList.layer.frame.origin.x = 0 - self.shelvesList.layer.frame.width
            })
            shelvesListIsPresent = false
            shelvesList.beginUpdates()
            let cells = shelvesList.visibleCells
            for index in 0..<cells.count{
                if index > 1{
                    let cell = cells[index] as! ShelfListCell
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.moreButton.layer.frame.origin.x = cell.layer.frame.width
                        cell.deleteButton.layer.frame.origin.x = cell.layer.frame.width
                    })
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.widthConstraint.constant = cell.layer.frame.width - 32
                        cell.layoutIfNeeded()
                    })
                } else if index == 0 {
                    let cell = cells[index] as! ShelvesListTitleCell
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.editButton.alpha = 1.0
                    })
                    cell.backDoneButton.setTitle("Back", for: .normal)
                    cell.backDoneButton.tintColor = .black
                    cell.isEditMode = false
                }
            }
            shelvesList.endUpdates()
        }
        
        if shelfPrepreferencesIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.shelfPrePreferencesTableView.alpha = 0.0
            })
            shelfPrepreferencesIsPresent = false
        }
        
        if addNewElementViewIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewElementTableView.alpha = 0.0
            })
            addNewElementViewIsPresent = false
        }

    }
    
    @objc func dismissView(){
        if addNewElementViewIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewElementTableView.alpha = 0.0
                self.opacityFilter.alpha = 0.0
            })
            addNewElementViewIsPresent = false
        } else if shelvesListIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.shelvesList.layer.frame.origin.x = 0 - self.shelvesList.layer.frame.width
                self.opacityFilter.alpha = 0.0
            })
            shelvesListIsPresent = false
            shelvesList.beginUpdates()
            let cells = shelvesList.visibleCells
            for index in 0..<cells.count{
                if index > 1{
                    let cell = cells[index] as! ShelfListCell
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.moreButton.layer.frame.origin.x = cell.layer.frame.width
                        cell.deleteButton.layer.frame.origin.x = cell.layer.frame.width
                    })
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.widthConstraint.constant = cell.layer.frame.width - 32
                        cell.layoutIfNeeded()
                    })
                } else if index == 0 {
                    let cell = cells[index] as! ShelvesListTitleCell
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.editButton.alpha = 1.0
                    })
                    cell.backDoneButton.setTitle("Back", for: .normal)
                    cell.backDoneButton.tintColor = .black
                    cell.isEditMode = false
                }
            }
            shelvesList.endUpdates()
        } else if shelfPrepreferencesIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.shelfPrePreferencesTableView.alpha = 0.0
                self.opacityFilter.alpha = 0.0
            })
            shelfPrepreferencesIsPresent = false
        }
    }
    
    @IBAction func showShelves(_ sender: Any) {
        if addNewElementViewIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewElementTableView.alpha = 0.0
                self.opacityFilter.alpha = 0.0
            })
            addNewElementViewIsPresent = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shelvesList.layer.frame.origin.x = 0
            self.opacityFilter.alpha = 1.0
        })
        
        shelvesListIsPresent = true
        
        if shelfPrepreferencesIsPresent{
            UIView.animate(withDuration: 0.3, animations: {
                self.shelfPrePreferencesTableView.alpha = 0.0
            })
            shelfPrepreferencesIsPresent = false
        }
        
        
    }
    
}

extension MyShelvesViewController: UITableViewDelegate{
    
}

extension MyShelvesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = addNewElementTableView.dequeueReusableCell(withIdentifier: "addItemCell", for: indexPath) as! AddItemCell
            cell.itemName.setTitle("Add new file", for: .normal)
            cell.itemName.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
            cell.itemName.imageEdgeInsets.left = 20
            cell.itemName.titleEdgeInsets.left = 30
            cell.controller = self
            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 254/255, green: 224/255, blue: 162/255, alpha: 1))
            return cell
        } else {
            let cell = addNewElementTableView.dequeueReusableCell(withIdentifier: "addItemCell", for: indexPath) as! AddItemCell
            cell.itemName.setTitle("Add new shelf", for: .normal)
            cell.itemName.setImage(UIImage(systemName: "rectangle.stack.fill.badge.plus"), for: .normal)
            cell.controller = self
            cell.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 254/255, green: 224/255, blue: 162/255, alpha: 1))
            cell.separatorView.backgroundColor = .clear
            return cell
        }
    }
    
    
}

extension MyShelvesViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: shelvesList) == true {
            return false
        }
        
        return true
    }
}
