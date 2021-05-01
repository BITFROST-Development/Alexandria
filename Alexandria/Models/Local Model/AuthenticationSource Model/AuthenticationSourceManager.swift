//
//  AuthenticationSourceManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/25/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import MobileCoreServices

extension AuthenticationSource{
    func loadCloudUser(_ cloudUser: Results<CloudUser>){
        persistLog = true
        loggedIn = true
        RegisterLoginViewController.loggedIn = true
        GoogleSignIn.sharedInstance().restoreSignIn()
        GoogleSignIn.sharedInstance().email = cloudUser[0].googleAccountEmail
        let socket = Socket.sharedInstance
        socket.connectWithUsername(username: cloudUser[0].username)
        socket.establishConnection()
    }
    
    func loadLocalUser(_ unloggedUser: Results<UnloggedUser>){
        persistLog = true
        loggedIn = false
    }
    
    func loadStartingUser(){
        persistLog = true
        loggedIn = false
        
        let newUnloggedUser = UnloggedUser()
        newUnloggedUser.alexandria!.home.append(HomeItem("Documents", "Favorites", "Last Modified"))
        newUnloggedUser.alexandria!.defaultCoverStyle = "notebookPlain01"
        newUnloggedUser.alexandria!.defaultPaperStyle = "notebookPaperBlank01"
        newUnloggedUser.alexandria!.defaultPaperColor = "Yellow"
        newUnloggedUser.alexandria!.defaultPaperOrientation = "Portrait"
		var standardColors = [IconColorDec(), IconColorDec(), IconColorDec()]
		var redContainer: CGFloat = 0
		var greenContainer: CGFloat = 0
		var blueContainer: CGFloat = 0
		standardColors[0].red = 0
		standardColors[0].green = 0
		standardColors[0].blue = 0
		standardColors[0].colorName = "black"
		AlexandriaConstants.alexandriaRed.getRed(&redContainer, green: &greenContainer, blue: &blueContainer, alpha: nil)
		standardColors[1].red = Double(redContainer)
		standardColors[1].green = Double(greenContainer)
		standardColors[1].blue = Double(blueContainer)
		standardColors[1].colorName = "alexRed"
		AlexandriaConstants.alexandriaBlue.getRed(&redContainer, green: &greenContainer, blue: &blueContainer, alpha: nil)
		standardColors[2].red = Double(redContainer)
		standardColors[2].green = Double(greenContainer)
		standardColors[2].blue = Double(blueContainer)
		standardColors[2].colorName = "alexBlue"
		
		do{
			try realm.write({
				let pen = InkTool("pen", standardColors, [0.3, 0.5, 1.0])
				realm.add(pen)
				let fountainPen = InkTool("fountain", standardColors, [0.3, 0.5, 1.0])
				realm.add(fountainPen)
				let pencil = InkTool("pencil", standardColors, [0.3, 0.5, 1.0])
				realm.add(pencil)
				let highlighter = InkTool("highlighter", standardColors, [0.3, 0.5, 1.0])
				realm.add(highlighter)
				let eraser = InkTool("eraser", [], [0.3, 0.5, 1.0])
				realm.add(eraser)
				let inlineText = TextTool("line", "Arial", 12, "", textAlignment: 0, 1, IconColor(red: 0, green: 0, blue: 0, name: "black"))
				realm.add(inlineText)
				let textBox = TextTool("box", "Arial", 12, "", textAlignment: 0, 1, IconColor(red: 0, green: 0, blue: 0, name: "black"))
				realm.add(textBox)
				let image = ImageTool("Inline", [0,0,0])
				realm.add(image)
				let link  = StaticTool("link")
				realm.add(link)
				let lasso = StaticTool("lasso")
				realm.add(lasso)
				let drag = StaticTool("drag")
				realm.add(drag)
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(fountainPen.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(pen.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(pencil.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(highlighter.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(eraser.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(link.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(lasso.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(inlineText.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(textBox.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(image.toolID ?? ""))
				newUnloggedUser.alexandria!.editorTools.append(ItemIDWrapper(drag.toolID ?? ""))
				realm.add(newUnloggedUser)
			})
		} catch let error {
			print(error.localizedDescription)
		}
    }
    
    func loadAddItemView(){
        addItemView.register(UINib(nibName: "AddItemOptionTableViewCell", bundle: nil), forCellReuseIdentifier: AddItemOptionTableViewCell.identifier)
        tableManager = AuthenticationSourceTableManager()
        tableManager.controller = self
        addItemView.delegate = tableManager
        addItemView.dataSource = tableManager
        addItemView.alpha = 0
        addItemView.layer.cornerRadius = 10
    }
}

class AuthenticationSourceTableManager: UIView, UITableViewDelegate{
    var controller: AuthenticationSource!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller.dismissOverlayingViews(nil)
        controller.isEditingClue = false
        if indexPath.row == 0{
            controller.addItemKindSelected = "newFile"
            let documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypePDF as String), "public.bitfrost.alexandria"], in: .import)
            documentPicker.delegate = controller
            documentPicker.allowsMultipleSelection = false
            controller.present(documentPicker, animated: true)
        } else if indexPath.row == 1{
            controller.addItemKindSelected = "newNote"
			controller.itemYearClue = String(Calendar.current.component(.year, from: Date()))
			controller.selectedCoverName = controller.realm.objects(AlexandriaData.self)[0].defaultCoverStyle
			controller.selectedPaperName = controller.realm.objects(AlexandriaData.self)[0].defaultPaperStyle
			controller.displayedPaperColor = controller.realm.objects(AlexandriaData.self)[0].defaultPaperColor
			controller.displayedOrientation = controller.realm.objects(AlexandriaData.self)[0].defaultPaperOrientation
			controller.itemImageClue = [UIImage(named:  controller.selectedCoverName)!, UIImage(named: "\(controller.selectedPaperName ?? "")/\(controller.displayedOrientation ?? "")/\(controller.displayedPaperColor ?? "")")!]
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else if indexPath.row == 2{
            controller.addItemKindSelected = "newSet"
			controller.itemYearClue = String(Calendar.current.component(.year, from: Date()))
			controller.itemImageClue = [UIImage(named: "cardBlue")!]
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else if indexPath.row == 3{
            controller.addItemKindSelected = "newFolder"
			controller.itemImageClue = [UIImage(named: "folderIconBlue")!]
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else if indexPath.row == 4{
            controller.addItemKindSelected = "newCollection"
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else if indexPath.row == 5{
            controller.addItemKindSelected = "newGoal"
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else if indexPath.row == 6{
            controller.addItemKindSelected = "newTeam"
            controller.performSegue(withIdentifier: "toAddItemView", sender: controller)
        }
        UIView.animate(withDuration: 0.3, animations: {
            tableView.deselectRow(at: indexPath, animated: true)
        })  
    }
}

extension AuthenticationSourceTableManager: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemOptionTableViewCell.identifier, for: indexPath) as! AddItemOptionTableViewCell
		cell.contentView.backgroundColor = AlexandriaConstants.alexandriaRed
		cell.firstLevel = true
        if indexPath.row == 0{
            cell.addItemLabel.text = "New pdf file"
            cell.addItemIcon.image = UIImage(systemName: "book.fill")
            cell.separator.alpha = 1
        } else if indexPath.row == 1{
            cell.addItemLabel.text = "New notebook"
            cell.addItemIcon.image = UIImage(systemName: "doc.fill")
            cell.separator.alpha = 1
        } else if indexPath.row == 2{
            cell.addItemLabel.text = "New flashcard set"
            cell.addItemIcon.image = UIImage(systemName: "rectangle.stack.fill")
            cell.separator.alpha = 1
        } else if indexPath.row == 3{
            cell.addItemLabel.text = "New folder"
            cell.addItemIcon.image = UIImage(systemName: "folder.fill")
            cell.separator.alpha = 1
        } else if indexPath.row == 4{
            cell.addItemLabel.text = "New collection"
            cell.addItemIcon.image = UIImage(systemName: "archivebox.fill")
            cell.separator.alpha = 1
        } else if indexPath.row == 5{
            cell.addItemLabel.text = "New goal"
            cell.addItemIcon.image = UIImage(systemName: "gauge")
            cell.separator.alpha = 1
        } else if indexPath.row == 6{
            cell.addItemLabel.text = "New team"
            cell.addItemIcon.image = UIImage(systemName: "person.and.person.fill")
            cell.separator.alpha = 0
        }
        return cell
    }
}
