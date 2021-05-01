////
////  NewNotebookSet.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/22/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class NewVaultSetViewController: UIViewController, ItemChangerDelegate {
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    var controller: MyVaultsViewController!
//    var toDrive: Bool = false
//    var fileShouldBeMoved: Bool = true
//    var updating: Bool = false
//    var finalFileName: String! = ""
//    var kind: String!
////    var parentVault: Vault?
////    var currentVault: Vault!
//    var currentSet: TermSet!
//    var selectedColor: DisplayedColor!
//    var colorName: String!
//    var loggedIn: Bool!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "AddFileThumbnail", bundle: nil), forCellReuseIdentifier: AddFileThumbnail.identifier)
//        tableView.register(UINib(nibName: "AddFileViewTitle", bundle: nil), forCellReuseIdentifier: AddFileViewTitle.identifier)
//        tableView.register(UINib(nibName: "AddFilePickerTrigger", bundle: nil), forCellReuseIdentifier: AddFilePickerTrigger.identifier)
//        tableView.register(UINib(nibName: "AddFileCheckBoxes", bundle: nil), forCellReuseIdentifier: AddFileCheckBoxes.identifier)
//        tableView.register(UINib(nibName: "NewVaultSetDone", bundle: nil), forCellReuseIdentifier: NewVaultSetDone.identifier)
//        NewVaultSetDone.controller = self
//        selectedColor = DisplayedColor(137, 179, 231, named: "Blue")
//        colorName = "Blue"
//    }
//}
//
//extension NewVaultSetViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 2{
//            performSegue(withIdentifier: "toColorPicker", sender: self)
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if currentVault != nil && indexPath.row == 5{
//            if view.frame.height < 723{
//                return 85
//            } else {
//                return view.frame.size.height - 618
//            }
//        } else if currentSet != nil && indexPath.row == 4{
//            if view.frame.height < 723{
//                print(view.frame.size.height - 578)
//                return view.frame.size.height - 578
//            } else {
//                return view.frame.size.height - 568
//            }
//        }
//        return UITableView.automaticDimension
//    }
//}
//
//extension NewVaultSetViewController: UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if currentVault != nil {
//            return 6
//        } else {
//            return 5
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileThumbnail.identifier) as! AddFileThumbnail
//            cell.fileThumbnail.tintColor = UIColor(cgColor: CGColor(srgbRed: selectedColor.red, green: selectedColor.green, blue: selectedColor.blue, alpha: 1))
//            if kind == "vault"{
//                switch selectedColor.colorName {
//                case "Blue":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconBlue")
//                case "Purple":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconPurple")
//                case "Pink":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconPink")
//                case "Red":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconRed")
//                case "Orange":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconOrange")
//                case "Yellow":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconYellow")
//                case "Green":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconGreen")
//                case "Turquoise":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconTurquoise")
//                case "Grey":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconGrey")
//                case "Black":
//                    cell.fileThumbnail.image = UIImage(named: "vaultIconBlack")
//                default:
//                    print("There was an error displaying")
//                }
//            } else {
//                cell.fileThumbnail.image = UIImage(named: "vaultIconBlue")
//                switch selectedColor.colorName {
//                case "Blue":
//                    cell.fileThumbnail.image = UIImage(named: "cardBlue")
//                case "Purple":
//                    cell.fileThumbnail.image = UIImage(named: "cardPurple")
//                case "Pink":
//                    cell.fileThumbnail.image = UIImage(named: "cardPink")
//                case "Red":
//                    cell.fileThumbnail.image = UIImage(named: "cardRed")
//                case "Orange":
//                    cell.fileThumbnail.image = UIImage(named: "cardOrange")
//                case "Yellow":
//                    cell.fileThumbnail.image = UIImage(named: "cardYellow")
//                case "Green":
//                    cell.fileThumbnail.image = UIImage(named: "cardGreen")
//                case "Turquoise":
//                    cell.fileThumbnail.image = UIImage(named: "cardTurquoise")
//                case "Grey":
//                    cell.fileThumbnail.image = UIImage(named: "cardGrey")
//                case "Black":
//                    cell.fileThumbnail.image = UIImage(named: "cardBlack")
//                default:
//                    print("There was an error displaying")
//                }
//            }
//            
//            return cell
//        } else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileViewTitle.identifier) as! AddFileViewTitle
//            cell.fileTitle.text = finalFileName
//            cell.clearButton.alpha = 0.0
//            AddFileViewTitle.controller = self
//            cell.fileTitle.placeholder = "Title"
//            return cell
//        } else if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier: AddFilePickerTrigger.identifier) as! AddFilePickerTrigger
//            cell.fieldTitle.text = "Color"
//            cell.fieldDescription.text = colorName
//            return cell
//        } else if (currentVault != nil && indexPath.row < 5) || (currentSet != nil && indexPath.row < 4){
//            let cell = tableView.dequeueReusableCell(withIdentifier: AddFileCheckBoxes.identifier) as! AddFileCheckBoxes
//            cell.loggedIn = loggedIn
//            cell.controller = self
//            if indexPath.row == 3 {
//                cell.optionName.text = "Store in Cloud"
//                cell.recommendedLabel.text = "(NEEDED FOR CLOUD SYNC)"
//                if !loggedIn || Socket.sharedInstance.socket.status != .connected || (currentSet != nil && !(parentVault?.cloudVar.value ?? false)) {
//                    cell.optionName.alpha = 0.3
//                    cell.recommendedLabel.alpha = 0.3
//                    cell.checkCircle.alpha = 0.3
//                    cell.loggedIn = false
//                } else {
//                    cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
//                    cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
//                    toDrive = true
//                    cell.isChecked = true
//                }
//            } else {
//                cell.optionName.text = "Store Locally"
//                if fileShouldBeMoved {
//                    cell.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
//                    cell.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 1))
//                    fileShouldBeMoved = true
//                    cell.isChecked = true
//                    if !loggedIn || (currentSet != nil && !(parentVault?.cloudVar.value ?? false)){
//                        cell.optionName.alpha = 0.3
//                        cell.recommendedLabel.alpha = 0.3
//                        cell.checkCircle.alpha = 0.3
//                        cell.loggedIn = false
//                    }
//                } else {
//                    cell.isChecked = false
//                }
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: NewVaultSetDone.identifier) as! NewVaultSetDone
//            return cell
//        }
//    }
//    
//}
