//
//  NewNotebookViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class NewNotebookViewController: UIViewController, ItemChangerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var controller: MyVaultsViewController!
    var toDrive: Bool = false
    var fileShouldBeMoved: Bool = true
    var updating: Bool = false
    var finalFileName: String!
    var loggedIn: Bool!
    var parentVault: Vault!
    var currentNotbook: Note!
    var alexandria = AppDelegate.realm.objects(AlexandriaData.self)[0]
    var displayedCoverStyle: String! {
        get{
            print(selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))])
            if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookPlain"{
                return "Plain"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookCircles"{
                return "Circles"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookCubes"{
                return "Cubes"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookFlowers"{
                return "Flowers"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookPatterns"{
                return "Patterns"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookTech"{
                return "Tech"
            } else if selectedCoverName[selectedCoverName.startIndex..<selectedCoverName.index(before: selectedCoverName.index(before: selectedCoverName.endIndex))] == "notebookTextures"{
                return "Textures"
            }
            
            return ""
        }
    }
    var selectedCoverName: String!
    var displayedPaperColor: String!
    var displayedOrientation: String!
    var displayedPaperStyle: String! {
        get{
            if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperBlank"{
                return "Blank"
            } else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperSquared"{
                return "Squared"
            } else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperRuled" {
                return "Ruled"
            } else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperDoted" {
                
            } else if selectedPaperName[selectedPaperName.startIndex..<selectedPaperName.index(before: selectedPaperName.index(before: selectedPaperName.endIndex))] == "notebookPaperSpecial"{
                return "Special"
            }
            
            return ""
        }
    }
    var selectedPaperName: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewNotebookThumbnail", bundle: nil), forCellReuseIdentifier: NewNotebookThumbnail.identifier)
        tableView.register(UINib(nibName: "AddFileViewTitle", bundle: nil), forCellReuseIdentifier: AddFileViewTitle.identifier)
        tableView.register(UINib(nibName: "AddFilePickerTrigger", bundle: nil), forCellReuseIdentifier: AddFilePickerTrigger.identifier)
        tableView.register(UINib(nibName: "NewNotebookColorSwitcher", bundle: nil), forCellReuseIdentifier: NewNotebookColorSwitcher.identifier)
        tableView.register(UINib(nibName: "AddFileCheckBoxes", bundle: nil), forCellReuseIdentifier: AddFileCheckBoxes.identifier)
        tableView.register(UINib(nibName: "NewNotebookDone", bundle: nil), forCellReuseIdentifier: NewNotebookDone.identifier)
        NewNotebookDone.controller = self
        selectedCoverName = alexandria.defaultCoverStyle
        displayedPaperColor = alexandria.defaultPaperColor
        displayedOrientation = alexandria.defaultPaperOrientation
        selectedPaperName = alexandria.defaultPaperStyle
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension NewNotebookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "toCoverPicker", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 3{
            performSegue(withIdentifier: "toPaperPicker", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 4{
            switch displayedPaperColor {
            case "Yellow":
                displayedPaperColor = "Black"
            case "Black":
                displayedPaperColor = "White"
            case "White":
                displayedPaperColor = "Yellow"
            default:
                print("error changing displayedPaperColor")
            }
            let cell = tableView.cellForRow(at: indexPath) as! NewNotebookColorSwitcher
            tableView.beginUpdates()
            cell.fieldDescription.text = displayedPaperColor
            switch displayedPaperColor {
            case "White":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 252/255, green: 252/255, blue: 252/255, alpha: 1))
            case "Yellow":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 250/255, green: 245/255, blue: 225/255, alpha: 1))
            case "Black":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 39/255, green: 29/255, blue: 29/255, alpha: 1))
            default:
                print("error")
            }
            let thumbnail = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewNotebookThumbnail
            thumbnail.filePaperStyle.image = UIImage(named: "\(selectedPaperName ?? "")/\(displayedOrientation ?? "")/\(displayedPaperColor ?? "")")
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 5 {
            if displayedOrientation == "Portrait"{
                displayedOrientation = "Landscape"
            } else {
                displayedOrientation = "Portrait"
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! NewNotebookColorSwitcher
            tableView.beginUpdates()
            cell.fieldDescription.text = displayedOrientation
            let thumbnail = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewNotebookThumbnail
            thumbnail.filePaperStyle.image = UIImage(named: "\(selectedPaperName ?? "")/\(displayedOrientation ?? "")/\(displayedPaperColor ?? "")")
            if displayedOrientation == "Portrait"{
                thumbnail.heightShadow.constant = 201.66
                thumbnail.paperHeight.constant = 200
                thumbnail.widthShadow.constant = 156.4
                thumbnail.paperWidth.constant = 155.5
            } else {
                thumbnail.widthShadow.constant = 201.66
                thumbnail.paperHeight.constant = 155.5
                thumbnail.heightShadow.constant = 156.4
                thumbnail.paperWidth.constant = 200
            }
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 8{
            if view.frame.height < 723{
                print(view.frame.size.height - 578)
                return view.frame.size.height - 578
            } else {
                return view.frame.size.height - 780
            }
        }
        return UITableView.automaticDimension
    }
}

extension NewNotebookViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: NewNotebookThumbnail.identifier) as! NewNotebookThumbnail
            cell.fileThumbnail.image = UIImage(named: selectedCoverName)
            cell.filePaperStyle.image = UIImage(named: "\(selectedPaperName ?? "")/\(displayedOrientation ?? "")/\(displayedPaperColor ?? "")")
            if displayedOrientation == "Portrait"{
                cell.heightShadow.constant = 201.66
                cell.paperHeight.constant = 200
                cell.widthShadow.constant = 156.4
                cell.paperWidth.constant = 155.5
            } else {
                cell.widthShadow.constant = 201.66
                cell.paperHeight.constant = 155.5
                cell.heightShadow.constant = 156.4
                cell.paperWidth.constant = 200
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileViewTitle.identifier) as! AddFileViewTitle
            cell.fileTitle.text = ""
            cell.clearButton.alpha = 0.0
            AddFileViewTitle.controller = self
            cell.fileTitle.placeholder = "Title"
            return cell
        } else if indexPath.row < 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFilePickerTrigger.identifier) as! AddFilePickerTrigger
            if indexPath.row == 2{
                cell.fieldTitle.text = "Cover"
                cell.fieldDescription.text = displayedCoverStyle
            } else {
                cell.fieldTitle.text = "Paper Style"
                cell.fieldDescription.text = displayedPaperStyle
            }
            return cell
        } else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: NewNotebookColorSwitcher.identifier) as! NewNotebookColorSwitcher
            cell.fieldTitle.text = "Paper Color"
            cell.fieldDescription.text = displayedPaperColor
            switch displayedPaperColor {
            case "White":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 252/255, green: 252/255, blue: 252/255, alpha: 1))
            case "Yellow":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 250/255, green: 245/255, blue: 225/255, alpha: 1))
            case "Black":
                cell.colorIndicator.tintColor = UIColor(cgColor: CGColor(srgbRed: 39/255, green: 29/255, blue: 29/255, alpha: 1))
            default:
                print("error")
            }
            return cell
        } else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: NewNotebookColorSwitcher.identifier) as! NewNotebookColorSwitcher
            cell.fieldTitle.text = "Paper Orientation"
            cell.fieldDescription.text = displayedOrientation
            cell.colorIndicator.alpha = 0
            cell.colorShadow.alpha = 0
            return cell
        } else if indexPath.row < 8{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileCheckBoxes.identifier) as! AddFileCheckBoxes
            if indexPath.row == 6{
                cell.optionName.text = "Store in Cloud"
                cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
                if !loggedIn || Socket.sharedInstance.socket.status != .connected || !(parentVault?.cloudVar.value ?? false) {
                    cell.optionName.alpha = 0.3
                    cell.recommendedLabel.alpha = 0.3
                    cell.checkCircle.alpha = 0.3
                    cell.loggedIn = false
                } else {
                    cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
                    cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
                    toDrive = true
                    cell.isChecked = true
                }
            } else {
                cell.optionName.text = "Store Locally"
                if fileShouldBeMoved {
                    cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
                    cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
                    cell.isChecked = true
                    if !loggedIn || !(parentVault?.cloudVar.value ?? false){
                        cell.optionName.alpha = 0.3
                        cell.recommendedLabel.alpha = 0.3
                        cell.checkCircle.alpha = 0.3
                        cell.loggedIn = false
                    }
                } else {
                    cell.isChecked = false
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewNotebookDone.identifier) as! NewNotebookDone
            
            return cell
        }
    }
    
    
}
