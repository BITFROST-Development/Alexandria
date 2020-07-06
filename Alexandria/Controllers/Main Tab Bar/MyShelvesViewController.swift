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
    let manager = MyShelvesManager()
    let sem = DispatchSemaphore.init(value: 0)
    @IBOutlet weak var shelfName: UIButton!
    @IBOutlet weak var shelfCollectionView: UICollectionView!
    @IBOutlet weak var addNewElementTableView: UITableView!
    @IBOutlet weak var opacityFilter: UIView!
    @IBOutlet weak var shelvesList: MyShelvesTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.viewController = self
        shelfName.setTitle("All my books", for: .normal)
        opacityFilter.alpha = 0.0
        prepareAddItemTableView()
        prepareShelvesLists()
        shelvesList.controller = self
        let swipeToDismiss = UIPanGestureRecognizer(target: shelvesList, action: #selector(shelvesList.swipeDismiss(_:)))
        let dismissControll = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dismissControll.numberOfTapsRequired = 1
        dismissControll.numberOfTouchesRequired = 1
        dismissControll.delegate = self
        manager.loggedIn = loggedIn
        self.view.addGestureRecognizer(dismissControll)
        swipeToDismiss.delegate = shelvesList
        shelvesList.addGestureRecognizer(swipeToDismiss)
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
            return cell
        } else {
            let cell = addNewElementTableView.dequeueReusableCell(withIdentifier: "addItemCell", for: indexPath) as! AddItemCell
            cell.itemName.setTitle("Add new shelf", for: .normal)
            cell.itemName.setImage(UIImage(systemName: "rectangle.stack.fill.badge.plus"), for: .normal)
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
