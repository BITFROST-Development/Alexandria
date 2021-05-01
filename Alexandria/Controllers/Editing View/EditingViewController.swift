//
//  EditingViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/18/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit
import RealmSwift
import CoreBluetooth
import ZIPFoundation

class EditingViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let realm = AppDelegate.realm!
    var controller: AuthenticationSource!
	var initialIndex: Int!
    var currentlyScrolling = false
	var currentlyOpen: EditingFile!
	var openElements: [EditingFile]{
		get{
			return controller.lastOpenElements
		} set (newElements){
			controller.lastOpenElements = newElements
		}
	}
	
	//Navigation
	@IBOutlet weak var editorFileNavigationViewLarge: EditorFileNavigationBarLarge!
	@IBOutlet weak var editorFileNavigationViewLargeHeight: NSLayoutConstraint!
	@IBOutlet weak var editorFileNavigationViewShort: EditorFileNavigationShort!
	@IBOutlet weak var editorSetNavigationViewLarge: EditorSetNavigationBarLarge!
	@IBOutlet weak var editorSetNavigationViewLargeHeight: NSLayoutConstraint!
	@IBOutlet weak var editorSetNavigationViewShort: EditorSetNavigationShort!
	
	// File View
	@IBOutlet weak var tabSwitcher: EditorTabSwitcher!
	@IBOutlet weak var tabSwitcherHeight: NSLayoutConstraint!
	@IBOutlet weak var tabSwitcherDistanceToTop: NSLayoutConstraint!
    @IBOutlet weak var termSetView: UITableView!
	var fileView: EditorView!
    
    /// Toolbar row
	
	// Toolbar Setup
	@IBOutlet weak var toolBox: EditorFileToolBox!
	@IBOutlet weak var toolBoxDistanceToTop: NSLayoutConstraint!
	var currentTool: Int{
		get{
			controller.lastSelectedTool
		} set (newtool){
			controller.lastSelectedTool = newtool
		}
	}
	var latestPreferences: [PreferencesTracker]{
		get{
			controller.latestPreferences
		} set (newPreferences){
			controller.latestPreferences = newPreferences
		}
	}
	var currentColor: UIColor!
	
	// Gesture Recognizers
	var inkToolPan: ToolPanGestureRecognizer!
	var linkToolPan: ToolPanGestureRecognizer!
	var lassoToolPan: ToolPanGestureRecognizer!
	var textToolPan: ToolPanGestureRecognizer!
	
	// Tool helpers
    var currentWrittingTool = "fountain"
    var touchesComingFromPencil = false
	let toolPanDelegate = ToolPanDelegate()
	let scrollingDelegate = PDFScrollGestureDelegate()
	var drawingPath: UIBezierPath!
	var currentLayer: CAShapeLayer!
	var currentGroup: InkGroup!
	var removableDrawings: [CALayer]! = []
	
    //Page Symbols
    @IBOutlet weak var pageNumber: UILabel!
    var shouldAddPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        } else {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        }
    }
    
	private func setup(){
		(UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
		fileView = EditorView(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		self.addChild(fileView)
		self.view.addSubview(fileView.view)
		fileView.didMove(toParent: self)
		addFileViewConstraints()
		fileView.view.alpha = 0
		fileView.controller = self
		fileView.delegate = self
		fileView.dataSource = self
		termSetView.alpha = 0
		editorSetNavigationViewShort.alpha = 0
		editorSetNavigationViewLarge.alpha = 0
		editorFileNavigationViewShort.alpha = 0
		editorFileNavigationViewLarge.alpha = 0
		pageNumber.layer.cornerRadius = 10
		setupToolDelegates()
		if controller.selectedFileItem as? TermSet == nil{
			if openElements.contains(where: {$0.item.personalID == controller.selectedFileItem.personalID}){
				currentlyOpen = openElements.first(where: {$0.item.personalID == controller.selectedFileItem.personalID})
				fileView.setDocument(currentlyOpen! as! EditorFileInfo, 0, 0)
			} else {
				let newFile = EditorFileInfo(fileView, controller.selectedFileItem)
				currentlyOpen = newFile
				openElements.append(newFile)
				fileView.setDocument(newFile, openElements.count - 1, openElements.count - 1)
			}
			editorFileNavigationViewLarge.alpha = 1
			toolBox.alpha = 1
			fileView.view.alpha = 1
		}
		toolBox.controller = self
		tabSwitcher.controller = self
		if openElements.count > 1{
			tabSwitcherHeight.constant = 30
			toolBoxDistanceToTop.constant = 145
			self.view.layoutIfNeeded()
			tabSwitcher.reloadView()
		} else {
			tabSwitcher.backgroundColor = .black
			tabSwitcherHeight.constant = 0
			toolBoxDistanceToTop.constant = 115
			self.view.layoutIfNeeded()
		}
		editorSetNavigationViewShort.controller = self
		editorSetNavigationViewLarge.controller = self
		editorFileNavigationViewShort.controller = self
		editorFileNavigationViewLarge.controller = self
		
	}
	
	private func addFileViewConstraints(){
		fileView.view.translatesAutoresizingMaskIntoConstraints = false
		fileView.view.topAnchor.constraint(equalTo: toolBox.bottomAnchor, constant: 0).isActive = true
		fileView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
		fileView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
		fileView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
	}
	
	
}

extension EditingViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if notebookView.currentPage == notebookView.document?.page(at: notebookView.document!.pageCount - 1) && lastSelectedTool == moveToolButton{
//            return true
//        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension EditingViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentlyScrolling == false{
//            scrollBegan(UIPanGestureRecognizer())
        }
    }
}

