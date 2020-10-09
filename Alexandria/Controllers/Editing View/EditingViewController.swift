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

class EditingViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let realm = AppDelegate.realm!
    var controller: AuthenticationSource!
    var initialIndex: Int!
    var currentlyScrolling = false
    var currentBook: Book!
    var currentNotebook: Note!
    var currentSet: TermSet!
    let toolPanDelegate = ToolPanDelegate()
    let scrollingDelegate = PDFScrollGestureDelegate()
    var lastSelectedBarIndex: Int!
    var lastSelectedWritingPreferences: [Int]!
    var drawingPath: UIBezierPath!
    var annotationLayers: [PDFAnnotation] = []
    var annotation: DrawingAnnotation!
    @IBOutlet weak var bookView: PDFView!
    @IBOutlet weak var notebookView: NotebookView!
    @IBOutlet weak var termSetView: UITableView!
    
    //Upper button row
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var outlineButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var addPageButton: UIButton!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var pickerBar: UISegmentedControl!
    
    //Preferences buttons
    @IBOutlet weak var preferenceButton01BackgroundImage: UIImageView!
    @IBOutlet weak var preferenceButton01: UIButton!
    @IBOutlet weak var preferenceButton02BackgroundImage: UIImageView!
    @IBOutlet weak var preferenceButton02: UIButton!
    @IBOutlet weak var preferenceButton03BackgroundImage: UIImageView!
    @IBOutlet weak var preferenceButton03: UIButton!
    @IBOutlet weak var preferenceButton04: UIButton!
    @IBOutlet weak var preferenceButton04CircleShadow: UIImageView!
    @IBOutlet weak var preferenceButton05: UIButton!
    @IBOutlet weak var preferenceButton05CircleShadow: UIImageView!
    @IBOutlet weak var preferenceButton06: UIButton!
    @IBOutlet weak var preferenceButton06CircleShadow: UIImageView!
    
    
    //Bottom button row
    var lastSelectedTool: UIButton!
    @IBOutlet weak var writingToolButton: UIButton!
    var currentWrittingTool = "fountain"
    var touchesComingFromPencil = false
    var writingToolPan: ToolPanGestureRecognizer!
    @IBOutlet weak var eraserToolButton: UIButton!
    var eraserToolPan:
        ToolPanGestureRecognizer!
    @IBOutlet weak var highlighterToolButton: UIButton!
    var highlighterToolPan: ToolPanGestureRecognizer!
    @IBOutlet weak var linkToolButton: UIButton!
    var linkToolPan: ToolPanGestureRecognizer!
    @IBOutlet weak var lassoToolButton: UIButton!
    var lassoToolPan: ToolPanGestureRecognizer!
    @IBOutlet weak var textboxToolButton: UIButton!
    @IBOutlet weak var storeToolButton: UIButton!
    var storeToolPan: ToolPanGestureRecognizer!
    @IBOutlet weak var moveToolButton: UIButton!
    
    //Page Symbols
    @IBOutlet weak var addPageSymbol: UIImageView!
    @IBOutlet weak var pageNumber: UILabel!
    var shouldAddPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moveToolButton.isSelected = true
        lastSelectedTool = moveToolButton
        lastSelectedWritingPreferences = controller.writtingToolLastSelection
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        bookView.alpha = 0
        bookView.displayDirection = .horizontal
        bookView.displayMode = .singlePage
        bookView.usePageViewController(true, withViewOptions: nil)
        bookView.autoScales = true
        notebookView.alpha = 0
        notebookView.displayDirection = .horizontal
        notebookView.displayMode = .singlePage
        notebookView.usePageViewController(true, withViewOptions: nil)
        notebookView.autoScales = true
        termSetView.alpha = 0
        
        preferenceButton01.alpha = 0
        preferenceButton01BackgroundImage.alpha = 0
        preferenceButton02.alpha = 0
        preferenceButton02BackgroundImage.alpha = 0
        preferenceButton03.alpha = 0
        preferenceButton03BackgroundImage.alpha = 0
        preferenceButton04.alpha = 0
        preferenceButton04CircleShadow.alpha = 0
        preferenceButton05.alpha = 0
        preferenceButton05CircleShadow.alpha = 0
        preferenceButton06.alpha = 0
        preferenceButton06CircleShadow.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePageDisplayed(_:)), name: .PDFViewPageChanged, object: nil)
        setupToolDelegates()
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(shouldAddPage(_:)))
        panGesture.delegate = self
        notebookView.addGestureRecognizer(panGesture)
        
        
        
        let scrollGesture = ScrollingGestureRecognizer(target: self, action: #selector(scrollBegan(_:)))
        scrollingDelegate.controller = self
        scrollGesture.delegate = scrollingDelegate
        notebookView.addGestureRecognizer(scrollGesture)
        
        notebookView.interpolationQuality = .low
        pickerBar.selectedSegmentIndex = initialIndex
        pickerBar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        pickerBar.addTarget(self, action: #selector(pickerChanged(_:)), for: .allEvents)
        lastSelectedBarIndex = initialIndex
        bookView.document = nil
        notebookView.document = nil
        if initialIndex == 0{
            let path = URL(fileURLWithPath: currentBook.localAddress!)
            if let document = PDFDocument(url: path) {
                bookView.document = document
            }
            viewTitle.text = currentBook.title
            bookView.layer.frame.origin.x = 0
            notebookView.layer.frame.origin.x = view.layer.frame.size.width
            termSetView.layer.frame.origin.x = view.layer.frame.size.width
            bookView.alpha = 1
        } else if initialIndex == 1 {
//            let data = try! Data(contentsOf: URL(fileURLWithPath: currentNotebook.localAddress!))
            
            if let document = PDFDocument(url: URL(fileURLWithPath: currentNotebook.localAddress!)){
                notebookView.document = document
            }
            notebookView.maxScaleFactor = 7.5
            notebookView.minScaleFactor = notebookView.scaleFactorForSizeToFit - 5
            bookView.layer.frame.origin.x = 0 - view.layer.frame.size.width
            notebookView.layer.frame.origin.x = 0
            termSetView.layer.frame.origin.x = view.layer.frame.size.width
            viewTitle.text = currentNotebook.name
            notebookView.alpha = 1
        } else {
            viewTitle.text = currentSet.name
            bookView.layer.frame.origin.x = 0 - view.layer.frame.size.width
            notebookView.layer.frame.origin.x = 0 - view.layer.frame.size.width
            termSetView.layer.frame.origin.x = 0
            termSetView.alpha = 1
        }
        notebookView.scrollView!.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        } else {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        }
    }
    
    @IBAction func exitEditingMode(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changePageDisplayed(_ notification: NSNotification){
        pageNumber.text = "Page \((notebookView.document?.index(for: notebookView.currentPage!) ?? 0) + 1) of \(notebookView.document?.pageCount ?? 0)"
        
    }
}

extension EditingViewController: UIGestureRecognizerDelegate{
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if lastSelectedTool != moveToolButton{
//            let peripherals = CBCentralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")])
//            if touches.count > 1{
//                super.touchesBegan(touches, with: event)
//            } else {
//                let touch = touches.first!
//                if peripherals.contains(where: isApplePencil){
//                    if touch.type != .stylus{
//                        super.touchesBegan(touches, with: event)
//                    }
//                }
//            }
//        } else {
//            super.touchesBegan(touches, with: event)
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if lastSelectedTool != moveToolButton{
//            let peripherals = CBCentralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")])
//            if touches.count > 1{
//                super.touchesMoved(touches, with: event)
//            } else {
//                let touch = touches.first!
//                if peripherals.contains(where: isApplePencil){
//                    if touch.type != .stylus{
//                        super.touchesMoved(touches, with: event)
//                    }
//                }
//            }
//        } else {
//            super.touchesMoved(touches, with: event)
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if lastSelectedTool != moveToolButton{
//            let peripherals = CBCentralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")])
//            if touches.count > 1{
//                super.touchesEnded(touches, with: event)
//            } else {
//                let touch = touches.first!
//                if peripherals.contains(where: isApplePencil){
//                    if touch.type != .stylus{
//                        super.touchesEnded(touches, with: event)
//                    }
//                }
//            }
//        } else {
//            super.touchesEnded(touches, with: event)
//        }
//    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if notebookView.currentPage == notebookView.document?.page(at: notebookView.document!.pageCount - 1) && lastSelectedTool == moveToolButton{
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension EditingViewController: UIScrollViewDelegate{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentlyScrolling = true
////    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        currentlyScrolling = true
//        scrollBegan(UIPanGestureRecognizer())
//    }
////    scrollview
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentlyScrolling == false{
            scrollBegan(UIPanGestureRecognizer())
        }
    }
}

extension EditingViewController: PDFViewDelegate{
    
}
