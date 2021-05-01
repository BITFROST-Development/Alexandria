////
////  ShelvesListTitleCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/5/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class ShelvesListTitleCell: UITableViewCell {
//    
//    static var identifier = "shelvesListTitleCell"
//    
//    var isEditMode = false
//    var controller: MyShelvesViewController!
//    var manager: MyShelvesManager!
//    var constraintsToChange: NSLayoutConstraint?
//    
//    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var backDoneButton: UIButton!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(false, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    @IBAction func goIntoEditMode(_ sender: Any) {
//        controller.shelvesList.beginUpdates()
//        let cells = controller.shelvesList.visibleCells
//        for index in 0..<cells.count {
//            if index > 1 {
//                let cell = cells[index] as! ShelfListCell
//                UIView.animate(withDuration: 0.3, animations: {
//                    cell.widthConstraint.constant = cell.layer.frame.width - 170
//                    self.controller.shelvesList.layoutIfNeeded()
//                })
//                UIView.animate(withDuration: 0.3, animations: {
//                    cell.moreButton.layer.frame.origin.x = cell.layer.frame.width - 150
//                    cell.deleteButton.layer.frame.origin.x = cell.layer.frame.width - 85
//                })
//                
//            }
//        }
//        backDoneButton.setTitle("Done", for: .normal)
//        backDoneButton.tintColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 1))
//        UIView.animate(withDuration: 0.2, animations: {
//            self.editButton.alpha = 0.0
//        })
//        isEditMode = true
//        controller.shelvesList.endUpdates()
//    }
//    
//    @IBAction func dismissDoneButton(_ sender: Any) {
//        if isEditMode {
//            controller.shelvesList.beginUpdates()
//            let cells = controller.shelvesList.visibleCells
//            for index in 0..<cells.count {
//                if index > 1 {
//                    let cell = cells[index] as! ShelfListCell
//                    UIView.animate(withDuration: 0.3, animations: {
//                        cell.moreButton.layer.frame.origin.x = cell.layer.frame.width
//                        cell.deleteButton.layer.frame.origin.x = cell.layer.frame.width
//                    })
//                    UIView.animate(withDuration: 0.3, animations: {
//                        cell.widthConstraint.constant = cell.layer.frame.width - 32
//                        cell.layoutIfNeeded()
//                    })
//                }
//            }
//            controller.shelvesList.endUpdates()
//            
//            backDoneButton.setTitle("Back", for: .normal)
//            backDoneButton.tintColor = .black
//            UIView.animate(withDuration: 0.35, animations: {
//                self.editButton.alpha = 1.0
//            })
//            isEditMode = false
//        } else {
//            controller.dismissView()
//        }
//    }
//    
//}
