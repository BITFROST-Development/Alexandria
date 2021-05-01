//
//  EditorFileToolBox.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

@IBDesignable
class EditorFileToolBox: UIView{
	var controller: EditingViewController?{
		get{
			return editingViewController
		} set (newController){
			editingViewController = newController
			setup()
			drawToolBar()
		}
	}
	private var editingViewController: EditingViewController?
	var toolCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
	var toolManager: EditorFileToolBoxToolManager!
	var preferencesCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
	var preferencesManager: EditorFileToolBoxPreferencesManager!
	var lastPreferencesPicked: [PreferencesTracker] {
		get{
			return controller?.latestPreferences ?? []
		} set (newPreferences){
			controller?.latestPreferences = newPreferences
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		drawToolBar()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
		drawToolBar()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
		drawToolBar()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setup()
		drawToolBar()
	}
	
	private func setup(){
		toolManager = EditorFileToolBoxToolManager()
		toolManager.controller = self
		preferencesManager = EditorFileToolBoxPreferencesManager()
		preferencesManager.controller = self
		var tools: [EditorTool] = []
		var pickedPreferences: [PreferencesTracker] = []
		for toolID in AppDelegate.realm.objects(AlexandriaData.self)[0].editorTools{
			if let inkTool = AppDelegate.realm.objects(InkTool.self).filter({$0.toolID == toolID.value}).first{
				tools.append(inkTool)
				pickedPreferences.append(PreferencesTracker([0,3]))
			} else if let textTool = AppDelegate.realm.objects(TextTool.self).filter({$0.toolID == toolID.value}).first{
				tools.append(textTool)
				pickedPreferences.append(PreferencesTracker())
			} else if let imageTool = AppDelegate.realm.objects(ImageTool.self).filter({$0.toolID == toolID.value}).first{
				tools.append(imageTool)
				pickedPreferences.append(PreferencesTracker())
			} else if let staticTool = AppDelegate.realm.objects(StaticTool.self).filter({$0.toolID == toolID.value}).first{
				tools.append(staticTool)
				pickedPreferences.append(PreferencesTracker())
			}
		}
		if lastPreferencesPicked.count != tools.count {
			lastPreferencesPicked = pickedPreferences
		}
		let toolBoxFlow = UICollectionViewFlowLayout()
		toolBoxFlow.scrollDirection = .horizontal
		toolBoxFlow.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
		toolBoxFlow.estimatedItemSize.width = 31
		toolBoxFlow.itemSize.height = 29
		let preferencesFlow = UICollectionViewFlowLayout()
		preferencesFlow.scrollDirection = .horizontal
		preferencesFlow.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
		preferencesFlow.estimatedItemSize.width = 35
		preferencesFlow.itemSize.height = 35
		toolManager.tools = tools
		preferencesManager.tools = tools
		preferencesCollection.register(UINib(nibName: "EditorToolColorPreferenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolColorPreferenceCollectionViewCell.identifier)
		preferencesCollection.register(UINib(nibName: "EditorToolThicknessPreferenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolThicknessPreferenceCollectionViewCell.identifier)
		preferencesCollection.register(UINib(nibName: "EditorToolPickerPreferenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolPickerPreferenceCollectionViewCell.identifier)
		preferencesCollection.register(UINib(nibName: "EditorToolButtonPreferenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolButtonPreferenceCollectionViewCell.identifier)
		preferencesCollection.register(UINib(nibName: "EditorToolTogglePreferenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolTogglePreferenceCollectionViewCell.identifier)
		preferencesCollection.delegate = preferencesManager
		preferencesCollection.dataSource = preferencesManager
		toolCollection.delegate = toolManager
		toolCollection.dataSource = toolManager
		toolCollection.register(UINib(nibName: "EditorToolCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorToolCollectionViewCell.identifier)
		preferencesCollection.collectionViewLayout = preferencesFlow
		toolCollection.collectionViewLayout = toolBoxFlow
	}
	
	private func drawToolBar(){
		self.backgroundColor = .white
		let separatorView = UIView()
		separatorView.backgroundColor = .black
		separatorView.alpha = 0.1
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		preferencesCollection.translatesAutoresizingMaskIntoConstraints = false
		toolCollection.translatesAutoresizingMaskIntoConstraints = false
		preferencesCollection.backgroundColor = .clear
		toolCollection.backgroundColor = .clear
		self.addSubview(separatorView)
		self.addSubview(preferencesCollection)
		self.addSubview(toolCollection)
		
		toolCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
		toolCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		toolCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
		separatorView.leadingAnchor.constraint(equalTo: toolCollection.trailingAnchor, constant: 0).isActive = true
		let sepWidth = separatorView.widthAnchor.constraint(equalToConstant: 1.5)
		sepWidth.isActive = true
		separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
		
		self.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5).isActive = true
		self.trailingAnchor.constraint(equalTo: preferencesCollection.trailingAnchor, constant: 0).isActive = true
		preferencesCollection.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 0).isActive = true
		preferencesCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		preferencesCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
		if preferencesManager.tools.count > 0{
			if preferencesManager.tools[controller?.currentTool ?? 0] as? InkTool != nil{
				if (preferencesManager.tools[controller?.currentTool ?? 0] as! InkTool).kind != "eraser"{
					self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 280).isActive = true
				} else {
					self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 140).isActive = true
				}
			} else if preferencesManager.tools[controller?.currentTool ?? 0] as? TextTool != nil{
				self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 300).isActive = true
			} else if preferencesManager.tools[controller?.currentTool ?? 0] as? ImageTool != nil{
				self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 120).isActive = true
			} else if preferencesManager.tools[controller?.currentTool ?? 0] as? StaticTool != nil{
				if (preferencesManager.tools[controller?.currentTool ?? 0] as! StaticTool).kind != "link"{
					self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 0).isActive = true
					sepWidth.isActive = false
					sepWidth.constant = 0
					sepWidth.isActive = true
				} else {
					self.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 60).isActive = true
				}
			}
		}
	}
}




class EditorFileToolBoxToolManager: UIActivity, UICollectionViewDelegate, UICollectionViewDataSource{
	var controller: EditorFileToolBox!
	var tools: [EditorTool] = []
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tools.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolCollectionViewCell.identifier, for: indexPath) as! EditorToolCollectionViewCell
		cell.controller = controller.controller
		cell.collection = controller
		cell.chosen = false
		cell.index = indexPath.row
		if let inkTool = tools[indexPath.row] as? InkTool{
			cell.kind = inkTool.kind
			switch inkTool.kind {
			case "fountain":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "fountain.pen.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "fountain.pen")
					cell.chosen = false
				}
				break
			case "pencil":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "pencil.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "pencil")
					cell.chosen = false
				}
				break
			case "pen":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "pen.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "pen")
					cell.chosen = false
				}
				break
			case "highlighter":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "highlighter.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "highlighter")
					cell.chosen = false
				}
				break
			case "eraser":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "eraser.fill")
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "eraser")
					cell.chosen = false
				}
				break
			default:
				print("something went wrong displaying ink tool")
			}
		} else if let textTool = tools[indexPath.row] as? TextTool{
			if textTool.kind == "line"{
				cell.kind = "line"
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(systemName: "textbox.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(systemName: "textbox")
				}
			} else {
				cell.kind = "box"
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "textbox.fill")?.withTintColor(controller.controller?.currentColor ?? .black, renderingMode: .alwaysTemplate)
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "textbox")
				}
			}
		} else if tools[indexPath.row] as? ImageTool != nil{
			cell.kind = "image"
			if controller.controller?.currentTool == indexPath.row{
				cell.toolIcon.image = UIImage(systemName: "camera.on.rectangle.fill")?.withTintColor(.black, renderingMode: .alwaysTemplate)
				cell.chosen = true
			} else {
				cell.toolIcon.image = UIImage(systemName: "camera.on.rectangle")
			}
		} else if let staticTool = tools[indexPath.row] as? StaticTool {
			cell.kind = staticTool.kind
			switch staticTool.kind {
			case "link":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "link.fill")
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "link")
				}
				break
			case "lasso":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "lasso.fill")
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "lasso")
				}
				break
			case "drag":
				if controller.controller?.currentTool == indexPath.row{
					cell.toolIcon.image = UIImage(named: "drag.fill")
					cell.chosen = true
				} else {
					cell.toolIcon.image = UIImage(named: "drag")
				}
				break
			default:
				print("something went wrong in static tool display")
			}
		}
		return cell
	}
}



class EditorFileToolBoxPreferencesManager: UIActivity, UICollectionViewDelegate, UICollectionViewDataSource{
	var controller: EditorFileToolBox!
	var tools: [EditorTool] = []
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if tools[controller.controller?.currentTool ?? 0] as? InkTool != nil{
			return 6
		} else if tools[controller.controller?.currentTool ?? 0] as? TextTool != nil{
			return 7
		} else if tools[controller.controller?.currentTool ?? 0] as? ImageTool != nil{
			return 2
		} else if let staticTool = tools[controller.controller?.currentTool ?? 0] as? StaticTool{
			if staticTool.kind == "link"{
				return 1
			}
			return 0
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if tools[controller.controller?.currentTool ?? 0] as? InkTool != nil{
			return setupInkToolPreferences(collectionView, indexPath)
		} else if tools[controller.controller?.currentTool ?? 0] as? TextTool != nil{
			return setupTextToolPreferences(collectionView, indexPath)
		} else if tools[controller.controller?.currentTool ?? 0] as? ImageTool != nil{
			return setupImageToolPreferences(collectionView, indexPath)
		} else if let staticTool = tools[controller.controller?.currentTool ?? 0] as? StaticTool{
			return setupStaticToolPreferences(collectionView, indexPath, staticTool)
		}
		return UICollectionViewCell()
	}
	
	private func setupInkToolPreferences(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell{
		if indexPath.row < 3{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolColorPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolColorPreferenceCollectionViewCell
			cell.controller = controller.controller
			cell.colorView.backgroundColor = (tools[controller.controller?.currentTool ?? 0] as! InkTool).colors[indexPath.row].getColor()
			if controller.lastPreferencesPicked[controller.controller?.currentTool ?? 0].lastPicked.contains(indexPath.row){
				cell.shadowSelectedView.alpha = 1
				cell.moreColorsView.alpha = 1
				controller.controller?.currentColor = cell.colorView.backgroundColor
			} else {
				cell.shadowSelectedView.alpha = 0
				cell.moreColorsView.alpha = 0
			}
//			cell.translatesAutoresizingMaskIntoConstraints = false
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolThicknessPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolThicknessPreferenceCollectionViewCell
			cell.controller = controller.controller
			cell.thickness.constant = CGFloat((tools[controller.controller?.currentTool ?? 0] as! InkTool).thicknesses[indexPath.row - 3].value.value!) * 2.81
			cell.layoutIfNeeded()
			if controller.lastPreferencesPicked[controller.controller?.currentTool ?? 0].lastPicked.contains(indexPath.row){
				cell.shadowSelected.alpha = 1
			}
//			cell.translatesAutoresizingMaskIntoConstraints = false
			return cell
		}
	}
	private func setupTextToolPreferences(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell{
		if indexPath.row < 3{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolPickerPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolPickerPreferenceCollectionViewCell
			cell.controller = controller.controller
			if indexPath.row == 0{
				cell.valueLabel.text = (tools[controller.controller?.currentTool ?? 0] as! TextTool).fontName
				cell.pickerImage.alpha = 0
				cell.pickerIcon.alpha = 1
				cell.pickerKind = "font"
				cell.fontWidth.isActive = true
				cell.layoutIfNeeded()
			} else if indexPath.row == 1{
				cell.valueLabel.text = String((tools[controller.controller?.currentTool ?? 0] as! TextTool).fontSize.value!)
				cell.pickerImage.alpha = 0
				cell.pickerIcon.alpha = 1
				cell.fontWidth.isActive = false
				cell.pickerKind = "fontSize"
			} else if indexPath.row == 2{
				cell.valueLabel.alpha = 0
				cell.pickerIcon.alpha = 0
				cell.pickerImage.alpha = 1
				cell.fontWidth.isActive = false
				cell.pickerKind = "textAlignment"
			}
			return cell
		} else if indexPath.row == 3{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolColorPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolColorPreferenceCollectionViewCell
			cell.controller = controller.controller
			cell.shadowSelectedView.alpha = 1
			cell.colorView.backgroundColor = (tools[controller.controller?.currentTool ?? 0] as! TextTool).color?.getColor()
			controller.controller?.currentColor = cell.colorView.backgroundColor
			cell.moreColorsView.alpha = 1
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolTogglePreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolTogglePreferenceCollectionViewCell
			cell.controller = controller.controller
			if indexPath.row == 4{
				cell.toggleImage.image = UIImage(systemName: "bold")
			} else if indexPath.row == 5{
				cell.toggleImage.image = UIImage(systemName: "italic")
			} else if indexPath.row == 6{
				cell.toggleImage.image = UIImage(systemName: "underline")
			}
			
			if controller.lastPreferencesPicked[controller.controller?.currentTool ?? 0].lastPicked.contains(indexPath.row){
				cell.shadowSelectedView.alpha = 1
			} else {
				cell.shadowSelectedView.alpha = 0
			}
			return cell
		}
	}
	
	private func setupImageToolPreferences(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolButtonPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolButtonPreferenceCollectionViewCell
		if indexPath.row == 0{
			cell.optionButton.setTitle("Take Picture", for: .normal)
			cell.kind = "takePicture"
		} else {
			cell.optionButton.setTitle("Pick from Galery", for: .normal)
			cell.kind = "pickPicture"
		}
		return cell
	}
	
	private func setupStaticToolPreferences(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ tool: StaticTool) -> UICollectionViewCell{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorToolButtonPreferenceCollectionViewCell.identifier, for: indexPath) as! EditorToolButtonPreferenceCollectionViewCell
		cell.controller = controller.controller
		cell.optionButton.setTitle("Break Link", for: .normal)
		cell.kind = "link"
		return cell
	}
}

struct PreferencesTracker{
	var lastPicked: [Int] = []
	
	init() {}
	
	init(_ picked: [Int]) {
		self.lastPicked = picked
	}
}

