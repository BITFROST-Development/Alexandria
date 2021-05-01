//
//  EditorFileNavigationBarLarge.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/7/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

@IBDesignable
class EditorFileNavigationBarLarge: UIView{
	var controller: EditingViewController?{
		get{
			return editingViewController
		} set (newController){
			editingViewController = newController
			setup()
			drawNavigation()
		}
	}
	var editingViewController: EditingViewController!
	var relatedCollection: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
	var collectionDisplayables: [FileItem]{
		get{
			var collections = Array(controller?.currentlyOpen.item.collectionIDs ?? RealmSwift.List<ItemIDWrapper>())
			if controller != nil{
				collections.append(ItemIDWrapper(controller!.currentlyOpen.item.personalCollectionID!))
			}
			
			var books = Set<Book>()
			var notebooks = Set<Notebook>()
			var sets = Set<TermSet>()
			
			var finalItems: [FileItem] = []
			
			for collection in collections{
				let currentCollection = controller?.realm.objects(FileCollection.self).filter({$0.personalID == collection.value}).first!
				for item in currentCollection?.childrenIDs ?? RealmSwift.List<ItemIDWrapper>(){
					if let book = controller?.realm.objects(Book.self).filter({$0.personalID == item.value}).first{
						if !books.contains(book){
							finalItems.append(book)
							books.insert(book)
						}
					} else if let notebook = controller?.realm.objects(Notebook.self).filter({$0.personalID == item.value}).first{
						if !notebooks.contains(notebook){
							finalItems.append(notebook)
							notebooks.insert(notebook)
						}
					} else if let set = controller?.realm.objects(TermSet.self).filter({$0.personalID == item.value}).first{
						if !sets.contains(set){
							finalItems.append(set)
							sets.insert(set)
						}
					}
				}
			}
			
			
			finalItems.sort(by: {($0.lastOpened ?? $0.lastModified!) > ($1.lastOpened ?? $1.lastModified!)})
			return finalItems
		}
	}
	var toolbar: UIToolbar = UIToolbar()
	var fileTitle: UILabel = UILabel()
	var fileTitleText: String{
		get{
			return controller?.currentlyOpen.item.name ?? "File Title"
		}
	}
	var more: UIButton = UIButton()
	var uncollapsedHeight: NSLayoutConstraint!
	var collapsedHeight: NSLayoutConstraint!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		drawNavigation()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setup()
		drawNavigation()
	}
	
	private func setup(){
		relatedCollection.delegate = self
//		relatedCollection.dataSource = self
		relatedCollection.backgroundColor = .clear
		fileTitle.text = fileTitleText
		fileTitle.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
		fileTitle.textColor = .white
		more.setTitle("more", for: .normal)
		more.titleLabel?.font = more.titleLabel?.font.withSize(15)
		more.setTitleColor(.white, for: .normal)
		more.backgroundColor = AlexandriaConstants.alexandriaBlue
		more.layer.cornerRadius = 3
		more.addTarget(controller, action: #selector(controller?.editCurrentFile), for: .touchUpInside)
		uncollapsedHeight = self.heightAnchor.constraint(equalToConstant: 115)
		uncollapsedHeight.isActive = true
		collapsedHeight = self.heightAnchor.constraint(equalToConstant: 50)
		let separator = UIBarButtonItem()
		separator.width = 5
		let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.exitEditingMode(_:)))
		let collapseButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.arrowtriangle.2.inward")?.withTintColor(.white), style: .plain, target: self, action: #selector(collapseLargeTitle))
		let newItemButton = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: controller, action: #selector(controller?.presentAddView))
		let openFileButton = UIBarButtonItem(image: UIImage(systemName: "square.stack")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.toPicker))
		let thumbailButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.presentThumbnailView))
		let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.bookmarkPage))
		let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.shareFile))
		let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.startSearch))
		let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.undoAction))
		let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.right")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.redoAction))
		backButton.tintColor = .white
		collapseButton.tintColor = .white
		newItemButton.tintColor = .white
		openFileButton.tintColor = .white
		thumbailButton.tintColor = .white
		bookmarkButton.tintColor = .white
		shareButton.tintColor = .white
		searchButton.tintColor = .white
		undoButton.tintColor = .white
		redoButton.tintColor = .white
		fileTitle.sizeToFit()
		toolbar.isTranslucent = false
		toolbar.items = [backButton, separator, collapseButton, separator, newItemButton, separator, openFileButton, separator, thumbailButton, separator, bookmarkButton, separator, searchButton, separator, shareButton, separator, undoButton, separator, redoButton]
		toolbar.barTintColor = AlexandriaConstants.alexandriaRed
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		more.translatesAutoresizingMaskIntoConstraints = false
		relatedCollection.translatesAutoresizingMaskIntoConstraints = false
		toolbar.backgroundColor = .clear
	}
	
	@objc func collapseLargeTitle(){
		uncollapsedHeight.isActive = false
		collapsedHeight.isActive = true
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			self.controller?.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	private func drawNavigation(){
		backgroundColor = AlexandriaConstants.alexandriaRed
		let separatorView = UIView()
		separatorView.backgroundColor = .white
		separatorView.alpha = 0.6
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		let relatedView = UILabel()
		relatedView.text = "Related:"
		relatedView.font = relatedView.font.withSize(15)
		relatedView.textColor = .white
		relatedView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(relatedCollection)
		self.addSubview(fileTitle)
		self.addSubview(more)
		self.addSubview(relatedView)
		self.addSubview(separatorView)
		self.addSubview(toolbar)
		toolbar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
		toolbar.widthAnchor.constraint(lessThanOrEqualToConstant: 388).isActive = true
		toolbar.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 0).isActive = true
		toolbar.heightAnchor.constraint(equalToConstant: 45).isActive = true
		separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
		separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
		separatorView.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
		relatedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
		relatedView.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 15).isActive = true
		relatedView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
		relatedView.heightAnchor.constraint(equalToConstant: 11).isActive = true
		relatedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
		fileTitle.frame.origin = CGPoint(x: 15, y:60)
		if fileTitle.frame.width > self.frame.width - 174{
			fileTitle.frame.size.width = self.frame.width - 174
		}
		more.heightAnchor.constraint(equalToConstant: 20).isActive = true
		more.widthAnchor.constraint(equalToConstant: 50).isActive = true
		more.firstBaselineAnchor.constraint(equalTo: fileTitle.firstBaselineAnchor, constant: -5).isActive = true
		more.trailingAnchor.constraint(lessThanOrEqualTo: separatorView.leadingAnchor, constant: -15).isActive = true
		more.leadingAnchor.constraint(equalTo: fileTitle.trailingAnchor, constant: 12.5).isActive = true
		relatedCollection.leadingAnchor.constraint(equalTo: relatedView.leadingAnchor).isActive = true
		relatedCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
		relatedCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
		relatedCollection.topAnchor.constraint(equalTo: relatedView.bottomAnchor, constant: 5).isActive = true
		
	}
	
	func refreshView(){
		self.setup()
		self.layoutSubviews()
	}
}

extension EditorFileNavigationBarLarge: UICollectionViewDelegate{
	
}

//extension EditorFileNavigationBarLarge: UICollectionViewDataSource{
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return collectionDisplayables.count
//	}
//
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		return collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//	}
//
//
//}
