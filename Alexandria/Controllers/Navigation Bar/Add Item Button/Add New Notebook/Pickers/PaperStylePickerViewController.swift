////
////  PaperStylePickerViewController.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/25/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class PaperStylePickerViewController: UIViewController, NewNotebookPickerDelegate, NotebookImageStyle {
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    var controller: ItemChangerDelegate!
//    var selectedCellImage: Int!
//    var selectedCell: ClassCollectionViewCell?
//    var selectedColor: String!
//    var selectedOrientation: String!
//    var selectedGroup: String!
//    var blankArray: [UIImage]!
//    var blankArrayNames: [String]!
//    var squaredArray: [UIImage]!
//    var squaredArrayNames: [String]!
//    var ruledArray: [UIImage]!
//    var ruledArrayNames: [String]!
//    var dotedArray: [UIImage]!
//    var dotedArrayNamed: [String]!
//    var specialArray: [UIImage]!
//    var specialArrayNames: [String]!
//    
//    @IBOutlet weak var styleTable: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        styleTable.register(UINib(nibName: "ClassTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ClassTitleTableViewCell.identifier)
//        styleTable.register(UINib(nibName: "ClassCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: ClassCollectionTableViewCell.identifier)
//        styleTable.delegate = self
//        styleTable.dataSource = self
//        
//        blankArray = [UIImage(named: "notebookPaperBlank01/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperBlank02/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperBlank03/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperBlank04/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperBlank05/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperBlank06/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!]
//        blankArrayNames = ["Blank", "Cornell Full Blank", "Cornell Title Blank", "Cornell Basic Blank", "Cornell End Blank", "Legal Blank"]
//        
//        squaredArray = [UIImage(named: "notebookPaperSquared01/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared02/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared03/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared04/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared05/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared06/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared07/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSquared08/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!]
//        squaredArrayNames = ["Large Squared", "Medium Squared", "Small Squared", "Cornell Full Squared", "Cornell Title Squared", "Cornell Basic Squared", "Cornell End Squared", "Legal Squared"]
//        
//        ruledArray = [UIImage(named: "notebookPaperRuled01/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled02/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled03/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled04/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled05/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled06/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled07/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled08/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled09/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled10/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled11/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled12/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperRuled13/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!]
//        ruledArrayNames = ["Large Ruled", "Memium Ruled", "Small Ruled", "Cornell Full Ruled", "Cornell Title Ruled", "Cornell Basic Ruled", "Cornell End Ruled", "Legal Ruled", "Three Columns", "Uneven Left", "Uneven Right", "Two Columns", "Box"]
//        
//        dotedArray = [UIImage(named: "notebookPaperDoted01/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted02/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted03/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted04/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted05/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted06/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted07/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperDoted08/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!]
//        dotedArrayNamed = ["Large Doted", "Medium Large Doted", "Medium Small Doted", "Small Doted", "Cornell Full Doted", "Cornell Title Doted", "Cornell Basic Doted", "Cornell End Doted"]
//        
//        specialArray = [UIImage(named: "notebookPaperSpecial01/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!, UIImage(named: "notebookPaperSpecial02/\(selectedOrientation ?? "")/\(selectedColor ?? "")")!]
//        specialArrayNames = ["Monthly Planner", "Accounting"]
//    }
//    
//    @IBAction func dismissView(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func donePicking(_ sender: Any){
//        var newSelection = ""
//        var newImage: UIImage!
//        switch selectedGroup {
//        case "Blank":
//            newImage = blankArray[selectedCellImage]
//            if selectedCellImage < 9 {
//                newSelection = "notebookPaperBlank0\(String(selectedCellImage + 1))"
//            } else {
//                newSelection = "notebookPaperBlank\(String(selectedCellImage + 1))"
//            }
//        case "Squared":
//            newImage = squaredArray[selectedCellImage]
//            if selectedCellImage < 9 {
//                newSelection = "notebookPaperSquared0\(String(selectedCellImage + 1))"
//            } else {
//                newSelection = "notebookPaperSquared\(String(selectedCellImage + 1))"
//            }
//        case "Ruled":
//            newImage = ruledArray[selectedCellImage]
//            if selectedCellImage < 9 {
//                newSelection = "notebookPaperRuled0\(String(selectedCellImage + 1))"
//            } else {
//                newSelection = "notebookPaperRuled\(String(selectedCellImage + 1))"
//            }
//        case "Doted":
//            newImage = dotedArray[selectedCellImage]
//            if selectedCellImage < 9 {
//                newSelection = "notebookPaperDoted0\(String(selectedCellImage + 1))"
//            } else {
//                newSelection = "notebookPaperDoted\(String(selectedCellImage + 1))"
//            }
//        case "Special":
//            newImage = specialArray[selectedCellImage]
//            if selectedCellImage < 9 {
//                newSelection = "notebookPaperSpecial0\(String(selectedCellImage + 1))"
//            } else {
//                newSelection = "notebookPaperSpecial\(String(selectedCellImage + 1))"
//            }
//        default:
//            print("error")
//        }
//        if let newController = controller as? NewNotebookViewController{
//            newController.selectedPaperName = newSelection
//            newController.tableView.beginUpdates()
//            (newController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewNotebookThumbnail).filePaperStyle.image = newImage
//            newController.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//            newController.tableView.endUpdates()
//            dismiss(animated: true, completion: nil)
//        } else if let newController = controller as? NotebookPreferencesViewController{
//            newController.selectedPaperName = newSelection
//            newController.tableView.beginUpdates()
//            (newController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewNotebookThumbnail).filePaperStyle.image = newImage
//            newController.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//            newController.tableView.endUpdates()
//            dismiss(animated: true, completion: nil)
//        }
//        
//    }
//    
//}
//
//extension PaperStylePickerViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row % 2 == 0{
//            return UITableView.automaticDimension
//        } else {
//            if selectedOrientation == "Portrait"{
//                return 215
//            } else {
//                return 180
//            }
//        }
//    }
//}
//
//extension PaperStylePickerViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row % 2 == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
//            cell.bottomConstraint.constant = 10
//            cell.topConstraint.constant = 35
//            cell.separatorView.alpha = 0
//            cell.goToChevron.alpha = 0
//            cell.goToLabel.alpha = 0
//            if indexPath.row == 0{
//                cell.sectionTitle.text = "Blank"
//            } else if indexPath.row == 2 {
//                cell.sectionTitle.text = "Squared"
//            } else if indexPath.row == 4 {
//                cell.sectionTitle.text = "Ruled"
//            } else if indexPath.row == 6 {
//                cell.sectionTitle.text = "Doted"
//            } else {
//                cell.sectionTitle.text = "Special"
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: ClassCollectionTableViewCell.identifier) as! ClassCollectionTableViewCell
//            cell.controller = self
//            cell.selectedOrientation = selectedOrientation
//            if indexPath.row == 1{
//                cell.imagesToDisplay = blankArray
//                cell.namesToDisplay = blankArrayNames
//                cell.currentGroup = "Blank"
//            } else if indexPath.row == 3{
//                cell.imagesToDisplay = squaredArray
//                cell.namesToDisplay = squaredArrayNames
//                cell.currentGroup = "Squared"
//            } else if indexPath.row == 5{
//                cell.imagesToDisplay = ruledArray
//                cell.namesToDisplay = ruledArrayNames
//                cell.currentGroup = "Ruled"
//            } else if indexPath.row == 7{
//                cell.imagesToDisplay = dotedArray
//                cell.namesToDisplay = dotedArrayNamed
//                cell.currentGroup = "Doted"
//            } else if indexPath.row == 9 {
//                cell.imagesToDisplay = specialArray
//                cell.namesToDisplay = specialArrayNames
//                cell.currentGroup = "Special"
//            }
//            return cell
//        }
//    }
//    
//    
//}
