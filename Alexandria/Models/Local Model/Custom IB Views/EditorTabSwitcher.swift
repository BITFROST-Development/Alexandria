//
//  EditorTabSwitcher.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/14/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

@IBDesignable
class EditorTabSwitcher: UIView {
	var controller: EditingViewController?{
		get{
			return editingController
		} set (newController){
			editingController = newController
			setup()
		}
	}
	private var editingController: EditingViewController?
	var openTabs: [EditingFile]{
		get{
			return controller?.openElements ?? []
		}
	}
	var tabCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		drawTabSwitcher()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
		drawTabSwitcher()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
		drawTabSwitcher()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setup()
		drawTabSwitcher()
	}
	
	private func setup(){
		let preferencesFlow = UICollectionViewFlowLayout()
		preferencesFlow.scrollDirection = .horizontal
		preferencesFlow.minimumInteritemSpacing = 0
		preferencesFlow.minimumLineSpacing = 0
		preferencesFlow.sectionInset = .zero
		preferencesFlow.sectionInsetReference = .fromContentInset
		preferencesFlow.itemSize.height = 30
		if self.frame.width / CGFloat(openTabs.count)  < 200{
			preferencesFlow.itemSize.width = self.frame.width / CGFloat(openTabs.count)
		} else {
			preferencesFlow.itemSize.width = 200
		}
		self.backgroundColor = .white
		tabCollection.collectionViewLayout = preferencesFlow
		tabCollection.delegate = self
		tabCollection.dataSource = self
		tabCollection.backgroundColor = .clear
		tabCollection.contentInset = .zero
		tabCollection.register(UINib(nibName: "EditorTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditorTabCollectionViewCell.identifier)
	}
	
	private func drawTabSwitcher(){
		tabCollection.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(tabCollection)
		tabCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
		tabCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
		tabCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		tabCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
	}
	
	func reloadView(){
		let preferencesFlow = UICollectionViewFlowLayout()
		preferencesFlow.scrollDirection = .horizontal
		preferencesFlow.minimumInteritemSpacing = 0
		preferencesFlow.minimumLineSpacing = 0
		preferencesFlow.sectionInset = .zero
		preferencesFlow.sectionInsetReference = .fromContentInset
		preferencesFlow.itemSize.height = 30
		if (self.frame.width / CGFloat(openTabs.count)) >= 200{
			preferencesFlow.itemSize.width = self.frame.width / CGFloat(openTabs.count)
		} else {
			preferencesFlow.itemSize.width = 200
		}
		tabCollection.collectionViewLayout = preferencesFlow
		tabCollection.reloadData()
	}
}

extension EditorTabSwitcher: UICollectionViewDelegate{
	
}

extension EditorTabSwitcher: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if openTabs.count > 1{
			return openTabs.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorTabCollectionViewCell.identifier, for: indexPath) as! EditorTabCollectionViewCell
		cell.controller = controller
		cell.tabName.text = openTabs[indexPath.row].item.name
		cell.index = indexPath.row
		if openTabs[indexPath.row].item == controller!.currentlyOpen.item{
			cell.tabName.textColor = .white
			cell.closeImage.tintColor = .white
			cell.selectedView.backgroundColor = AlexandriaConstants.alexandriaRed
		} else {
			cell.tabName.textColor = .black
			cell.closeImage.tintColor = .black
			cell.selectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
		}
		
		return cell
	}
	
	
}

