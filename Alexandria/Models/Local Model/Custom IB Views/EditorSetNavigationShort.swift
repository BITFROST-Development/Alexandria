//
//  EditorSetNavigation.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/7/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

@IBDesignable
class EditorSetNavigationShort: UIView{
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
		fileTitle.text = fileTitleText
		fileTitle.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
		fileTitle.textColor = .white
		fileTitle.textAlignment = .right
		more.setTitle("more", for: .normal)
		more.titleLabel?.font = more.titleLabel?.font.withSize(15)
		more.setTitleColor(.white, for: .normal)
		more.backgroundColor = AlexandriaConstants.alexandriaBlue
		more.widthAnchor.constraint(equalToConstant: 50).isActive = true
		more.heightAnchor.constraint(equalToConstant: 20).isActive = true
		more.layer.cornerRadius = 3
		more.addTarget(controller, action: #selector(controller?.editCurrentFile), for: .touchUpInside)
		uncollapsedHeight = self.heightAnchor.constraint(equalToConstant: 115)
		uncollapsedHeight.isActive = true
		collapsedHeight = self.heightAnchor.constraint(equalToConstant: 50)
		let separator = UIBarButtonItem()
		separator.width = 5
		let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.exitEditingMode(_:)))
		let collapseButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.arrowtriangle.2.outward")?.withTintColor(.white), style: .plain, target: self, action: #selector(expandLargeTitle))
		let newItemButton = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: controller, action: #selector(controller?.presentAddView))
		let openFileButton = UIBarButtonItem(image: UIImage(systemName: "square.stack")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.toPicker))
		let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.shareFile))
		let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.startSearch))
		let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.undoAction))
		let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.right")?.withTintColor(.white), style: .plain, target: controller, action: #selector(controller?.redoAction))
		backButton.tintColor = .white
		collapseButton.tintColor = .white
		newItemButton.tintColor = .white
		openFileButton.tintColor = .white
		shareButton.tintColor = .white
		searchButton.tintColor = .white
		undoButton.tintColor = .white
		redoButton.tintColor = .white
		toolbar.isTranslucent = false
		toolbar.items = [backButton, separator, collapseButton, separator, newItemButton, separator, openFileButton, separator, searchButton, separator, shareButton, separator, undoButton, separator, redoButton]
		toolbar.barTintColor = AlexandriaConstants.alexandriaRed
		fileTitle.sizeToFit()
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		more.translatesAutoresizingMaskIntoConstraints = false
	}
	
	@objc func expandLargeTitle(){
		
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
		self.addSubview(fileTitle)
		self.addSubview(more)
		self.addSubview(relatedView)
		self.addSubview(separatorView)
		self.addSubview(toolbar)
		toolbar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
		toolbar.widthAnchor.constraint(lessThanOrEqualToConstant: 310).isActive = true
		toolbar.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 0).isActive = true
		toolbar.heightAnchor.constraint(equalToConstant: 45).isActive = true
		separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
		separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
		separatorView.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
		more.heightAnchor.constraint(equalToConstant: 20).isActive = true
		more.widthAnchor.constraint(equalToConstant: 50).isActive = true
		more.firstBaselineAnchor.constraint(equalTo: fileTitle.firstBaselineAnchor, constant: -5).isActive = true
		more.leadingAnchor.constraint(equalTo: fileTitle.trailingAnchor, constant: 12.5).isActive = true
		more.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -15).isActive = true
		if fileTitle.frame.width + 77.7 > self.frame.width / 2{
			fileTitle.frame.size.width = (self.frame.width / 2) - 77.7
		}
		fileTitle.frame.origin = CGPoint(x: self.frame.width - 77.7 - fileTitle.frame.width, y: 3)
	}
	
	func refreshView(){
		self.setup()
		self.layoutSubviews()
	}
}
