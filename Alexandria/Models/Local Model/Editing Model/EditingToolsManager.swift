//
//  EditingToolsManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/28/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PencilKit
import RealmSwift
import CoreBluetooth
import PDFKit

extension EditingViewController{
    @IBAction func writingToolSelected(_ sender: Any){
        if lastSelectedTool != writingToolButton {
            lastSelectedTool.isSelected = false
            switch lastSelectedTool {
            case eraserToolButton:
                notebookView.removeGestureRecognizer(eraserToolPan)
            case highlighterToolButton:
                notebookView.removeGestureRecognizer(highlighterToolPan)
            case linkToolButton:
                notebookView.removeGestureRecognizer(linkToolPan)
            case lassoToolButton:
                notebookView.removeGestureRecognizer(lassoToolPan)
            case storeToolButton:
                notebookView.removeGestureRecognizer(storeToolPan)
            default:
                print("no previous pan")
            }
            if currentWrittingTool == "fountain"{
                writingToolButton.setImage(UIImage(named: "fountain.pen.fill"), for: .selected)
            } else if currentWrittingTool == "pen"{
                writingToolButton.setImage(UIImage(named: "pen.fill"), for: .selected)
            } else {
                writingToolButton.setImage(UIImage(named: "pencil.fill"), for: .selected)
            }
            let alexandria = realm.objects(AlexandriaData.self)[0]
            preferenceButton01.alpha = 1
            preferenceButton01BackgroundImage.alpha = 1
            preferenceButton01BackgroundImage.image = UIImage(systemName: "circle.fill")
            preferenceButton01BackgroundImage.layer.frame.size.height = CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835 * 3.527
            let toolBar = preferenceButton01BackgroundImage.superview
            preferenceButton01BackgroundImage.layer.frame.origin.y = (toolBar!.layer.frame.size.height - CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835 * 4.232) / 2
            if lastSelectedWritingPreferences[0] == 1{
                preferenceButton01BackgroundImage.tintColor = .black
            } else {
                preferenceButton01BackgroundImage.tintColor = .gray
            }
            preferenceButton02.alpha = 1
            preferenceButton02BackgroundImage.alpha = 1
            preferenceButton02BackgroundImage.image = UIImage(systemName: "circle.fill")
            preferenceButton02BackgroundImage.layer.frame.size.height = CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835 * 3.527
            preferenceButton02BackgroundImage.layer.frame.origin.y = (toolBar!.layer.frame.size.height - CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835 * 4.232) / 2
            if lastSelectedWritingPreferences[0] == 2{
                preferenceButton02BackgroundImage.tintColor = .black
            } else {
                preferenceButton02BackgroundImage.tintColor = .gray
            }
            preferenceButton03.alpha = 1
            preferenceButton03BackgroundImage.alpha = 1
            preferenceButton03BackgroundImage.image = UIImage(systemName: "circle.fill")
            preferenceButton03BackgroundImage.layer.frame.size.height = CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835 * 3.537
            preferenceButton03BackgroundImage.layer.frame.origin.y = (toolBar!.layer.frame.size.height - CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835 * 4.232) / 2
            view.layoutIfNeeded()
            if lastSelectedWritingPreferences[0] == 3{
                preferenceButton03BackgroundImage.tintColor = .black
            } else {
                preferenceButton03BackgroundImage.tintColor = .gray
            }
            preferenceButton04.alpha = 1
            preferenceButton04.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            preferenceButton04.tintColor = UIColor(red: CGFloat(alexandria.defaultWritingToolColor01!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor01!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor01!.blue.value!), alpha: 1)
            if lastSelectedWritingPreferences[1] == 4{
                preferenceButton04CircleShadow.alpha = 1
            } else {
                preferenceButton04CircleShadow.alpha = 0
            }
            preferenceButton05.alpha = 1
            preferenceButton05.tintColor = UIColor(red: CGFloat(alexandria.defaultWritingToolColor02!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor02!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor02!.blue.value!), alpha: 1)
            if lastSelectedWritingPreferences[1] == 5{
                preferenceButton05CircleShadow.alpha = 1
            } else {
                preferenceButton05CircleShadow.alpha = 0
            }
            preferenceButton06.alpha = 1
            preferenceButton06.tintColor = UIColor(red: CGFloat(alexandria.defaultWritingToolColor01!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor03!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor03!.blue.value!), alpha: 1)
            if lastSelectedWritingPreferences[1] == 6{
                preferenceButton06CircleShadow.alpha = 1
            } else {
                preferenceButton06CircleShadow.alpha = 0
            }
            notebookView.addGestureRecognizer(writingToolPan)
            writingToolButton.isSelected = true
            lastSelectedTool = writingToolButton
        }
    }
    
    @IBAction func draggingToolSelected(_ sender: Any){
        switch lastSelectedTool {
        case writingToolButton:
            notebookView.removeGestureRecognizer(writingToolPan)
        case eraserToolButton:
            notebookView.removeGestureRecognizer(eraserToolPan)
        case highlighterToolButton:
            notebookView.removeGestureRecognizer(highlighterToolPan)
        case linkToolButton:
            notebookView.removeGestureRecognizer(linkToolPan)
        case lassoToolButton:
            notebookView.removeGestureRecognizer(lassoToolPan)
        case storeToolButton:
            notebookView.removeGestureRecognizer(storeToolPan)
        default:
            print("no previous pan")
        }
        preferenceButton01.alpha = 0
        preferenceButton01BackgroundImage.alpha = 0
        preferenceButton02.alpha = 0
        preferenceButton02BackgroundImage.alpha = 0
        preferenceButton03.alpha = 0
        preferenceButton03BackgroundImage.alpha = 0
        preferenceButton04.alpha = 0
        preferenceButton05.alpha = 0
        preferenceButton06.alpha = 0
        preferenceButton04CircleShadow.alpha = 0
        preferenceButton05CircleShadow.alpha = 0
        preferenceButton06CircleShadow.alpha = 0
        lastSelectedTool.isSelected = false
        moveToolButton.isSelected = true
        lastSelectedTool = moveToolButton
    }
    
    @objc func drawingGesture(_ gesture: ToolPanGestureRecognizer){
        if gesture.touchPencil{
            drawForUser(gesture, from: "Writing Tool")
        } else {
            if UIDevice.current.userInterfaceIdiom != .pad{
                drawForUser(gesture, from: "Writing Tool")
            } else if !CBCentralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")]).contains(where: isApplePencil){
                drawForUser(gesture, from: "Writing Tool")
            }
        }
    }
    
    @objc func drawForUser(_ gesture: ToolPanGestureRecognizer, from source: String){
        let alexandria = realm.objects(AlexandriaData.self)[0]
        if gesture.state == .began{
            let currentPage = notebookView.currentPage!
            let convertedPoint = notebookView.convert(gesture.currentPoint, to: currentPage)
            drawingPath = UIBezierPath()
            drawingPath.move(to: convertedPoint)
        } else if gesture.state == .changed{
            let currentPage = notebookView.currentPage!
            let convertedPoint = notebookView.convert(gesture.currentPoint, to: currentPage)
            let tempPoint = drawingPath.currentPoint
            drawingPath = UIBezierPath()
            drawingPath.move(to: tempPoint)
            drawingPath.addLine(to: convertedPoint)
            drawingPath.move(to: convertedPoint)
            let pressure = gesture.currentForce - 0.333
            let firstPreference = lastSelectedWritingPreferences[0]
            switch firstPreference {
            case 1:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + 0
                }
            case 2:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + 0
                }
            case 3:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + 0
                }
            default:
                print("error")
            }
            drawAnnotation(gesture, from: source, adding: false, pressure: pressure, asimuth: 0)
        } else if gesture.state == .ended {
            let currentPage = notebookView.currentPage!
            let convertedPoint = notebookView.convert(gesture.currentPoint, to: currentPage)
//            drawingPath.addQuadCurve(to: convertedPoint, controlPoint: drawingPath.currentPoint)
            let tempPoint = drawingPath.currentPoint
            drawingPath = UIBezierPath()
            drawingPath.move(to: tempPoint)
            drawingPath.addLine(to: convertedPoint)
            drawingPath.move(to: convertedPoint)
//            drawingPath.
            let pressure = gesture.currentForce - 0.333
            print(pressure)
            let firstPreference = lastSelectedWritingPreferences[0]
            switch firstPreference {
            case 1:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + 0
                }
            case 2:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + 0
                }
            case 3:
                if currentWrittingTool != "pencil"{
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + pressure
                } else {
                    drawingPath.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + 0
                }
            default:
                print("error")
            }
            drawAnnotation(gesture, from: source, adding: true, pressure: pressure, asimuth: 0)
        } else if gesture.state == .cancelled{
            
        }
    }
    
    @objc private func drawAnnotation(_ gesture: ToolPanGestureRecognizer, from source: String, adding shouldAdd: Bool, pressure: CGFloat, asimuth: CGFloat){
        let border = PDFBorder()
        let alexandria = realm.objects(AlexandriaData.self)[0]
        if source == "Writing Tool"{
            let firstPreference = lastSelectedWritingPreferences[0]
            let secondPreference = lastSelectedWritingPreferences[1]
            
            switch firstPreference {
            case 1:
                if currentWrittingTool != "pencil"{
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + pressure
                } else {
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness01.value!) * 2.835) + asimuth
                }
            case 2:
                if currentWrittingTool != "pencil"{
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + pressure
                } else {
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness02.value!) * 2.835) + asimuth
                }
            case 3:
                if currentWrittingTool != "pencil"{
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + pressure
                } else {
                    border.lineWidth = (CGFloat(alexandria.defaultWritingToolThickness03.value!) * 2.835) + asimuth
                }
            default:
                print("error")
            }
            if annotation == nil {
                annotation = DrawingAnnotation(bounds: notebookView.currentPage!.bounds(for: notebookView.displayBox), forType: .line, withProperties: nil)
                annotation.controller = self
            }
            
            switch secondPreference {
            case 4:
                if currentWrittingTool != "pencil"{
                    annotation.color = UIColor(red: CGFloat(alexandria.defaultWritingToolColor01!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor01!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor01!.blue.value!), alpha: 1)
                } else {
                    annotation.color = UIColor(patternImage: UIImage(named: "pencilTexture")!.withTintColor(UIColor(red: CGFloat(alexandria.defaultWritingToolColor01!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor01!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor01!.blue.value!), alpha: 0.7 + pressure)))
                }
            case 5:
                if currentWrittingTool != "pencil"{
                    annotation.color = UIColor(red: CGFloat(alexandria.defaultWritingToolColor02!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor02!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor02!.blue.value!), alpha: 1)
                } else {
                    annotation.color = UIColor(patternImage: UIImage(named: "pencilTexture")!.withTintColor(UIColor(red: CGFloat(alexandria.defaultWritingToolColor02!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor02!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor02!.blue.value!), alpha: 0.7 + pressure)))
                }
            case 6:
                if currentWrittingTool != "pencil"{
                    annotation.color = UIColor(red: CGFloat(alexandria.defaultWritingToolColor03!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor03!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor03!.blue.value!), alpha: 1)
                } else {
                    annotation.color = UIColor(patternImage: UIImage(named: "pencilTexture")!.withTintColor(UIColor(red: CGFloat(alexandria.defaultWritingToolColor03!.red.value!), green: CGFloat(alexandria.defaultWritingToolColor03!.green.value!), blue: CGFloat(alexandria.defaultWritingToolColor03!.blue.value!), alpha: 0.7 + pressure)))
                }
            default:
                print("error")
            }
//            annotation.borders.append(border)
            annotation.pathsToDraw.append(drawingPath)
            if shouldAdd{
                notebookView.currentPage!.removeAnnotation(annotation)
                let finalAnnotation = createFinalAnnotation(paths: annotation.pathsToDraw, page: notebookView.currentPage!, width: annotation.border!.lineWidth, color: annotation.color)
                annotationLayers.append(finalAnnotation)
                annotation = nil
            } else {
                forceRedraw(annotation: annotation!, onPage: notebookView.currentPage!)
            }
        }
    }
    
    private func forceRedraw(annotation: PDFAnnotation, onPage: PDFPage) {
        onPage.removeAnnotation(annotation)
        onPage.addAnnotation(annotation)
    }
    
    private func createFinalAnnotation(paths: [UIBezierPath], page: PDFPage, width: CGFloat, color: UIColor) -> PDFAnnotation {
        var originX: CGFloat = paths.first!.bounds.origin.x - 5
        var originY: CGFloat = paths.first!.bounds.origin.y - 5
        var pathWidth: CGFloat! = 0
        var pathHeight: CGFloat! = 0
        for path in paths{
            if path.bounds.origin.x - 5 >= (notebookView.currentPage?.bounds(for: .mediaBox).origin.x)! && path.bounds.origin.y - 5 >= (notebookView.currentPage?.bounds(for: .mediaBox).origin.y)!{
                if path.bounds.origin.x - 5 < originX {
                    originX = path.bounds.origin.x - 5
                } else if path.bounds.origin.x - originX + 5 > pathWidth{
                    pathWidth = path.bounds.origin.x - originX + 5
                }
                
                if path.bounds.origin.y - 5 < originY {
                    originY = path.bounds.origin.y - 5
                } else if path.bounds.origin.y - originY + 5 > pathHeight{
                    pathHeight = path.bounds.origin.y - originY + 5
                }
            }
        }
        
        let bounds = CGRect(x: originX, y: originY, width: pathWidth, height: pathHeight)
//        CGRect(x: path.bounds.origin.x - 5,
//                            y: path.bounds.origin.y - 5,
//                            width: path.bounds.size.width + 10,
//                            height: path.bounds.size.height + 10)
        var signingPathsCentered: [UIBezierPath] = []
        for path in paths{
            let signingPathCentered = UIBezierPath()
            signingPathCentered.cgPath = path.cgPath
            signingPathCentered.moveCenter(to: bounds.center)
            signingPathsCentered.append(signingPathCentered)
        }
        
        let finalAnnotation = DrawingAnnotation(bounds: bounds, forType: .ink, withProperties: nil)
        finalAnnotation.color = color
        finalAnnotation.pathsToDraw = signingPathsCentered
        page.addAnnotation(annotation)
        notebookView.document?.write(to: URL(fileURLWithPath: currentNotebook.localAddress!))
        return annotation
    }
    
    func setupToolDelegates(){
        toolPanDelegate.controller = self
        writingToolPan = ToolPanGestureRecognizer()
        toolPanDelegate.pdfView = notebookView
        writingToolPan.delegate = toolPanDelegate
        
    }
    
    func isApplePencil(peripheral: CBPeripheral) -> Bool{
        return peripheral.name == "Apple Pencil"
    }
    
    @IBAction func preferencesButton01Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[0] {
            case 2:
                preferenceButton02BackgroundImage.tintColor = .gray
            case 3:
                preferenceButton03BackgroundImage.tintColor = .gray
            default:
                print("same selected")
            }
            preferenceButton01BackgroundImage.tintColor = .black
            lastSelectedWritingPreferences[0] = 1
        }
    }
    
    @IBAction func preferencesButton02Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[0] {
            case 1:
                preferenceButton01BackgroundImage.tintColor = .gray
            case 3:
                preferenceButton03BackgroundImage.tintColor = .gray
            default:
                print("same selected")
            }
            preferenceButton02BackgroundImage.tintColor = .black
            lastSelectedWritingPreferences[0] = 2
        }
    }
    
    @IBAction func preferencesButton03Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[0] {
            case 1:
                preferenceButton01BackgroundImage.tintColor = .gray
            case 2:
                preferenceButton02BackgroundImage.tintColor = .gray
            default:
                print("same selected")
            }
            preferenceButton03BackgroundImage.tintColor = .black
            lastSelectedWritingPreferences[0] = 3
        }
    }
    
    @IBAction func preferencesButton04Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[1] {
            case 5:
                preferenceButton05CircleShadow.alpha = 0
            case 6:
                preferenceButton06CircleShadow.alpha = 0
            default:
                print("same selected")
            }
            preferenceButton04CircleShadow.alpha = 1
            lastSelectedWritingPreferences[1] = 4
        }
    }
    
    @IBAction func preferencesButton05Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[1] {
            case 4:
                preferenceButton04CircleShadow.alpha = 0
            case 6:
                preferenceButton06CircleShadow.alpha = 0
            default:
                print("same selected")
            }
            preferenceButton05CircleShadow.alpha = 1
            lastSelectedWritingPreferences[1] = 5
        }
    }
    
    @IBAction func preferencesButton06Pressed(_ sender: Any){
        if lastSelectedTool == writingToolButton{
            switch lastSelectedWritingPreferences[1] {
            case 4:
                preferenceButton04CircleShadow.alpha = 0
            case 5:
                preferenceButton05CircleShadow.alpha = 0
            default:
                print("same selected")
            }
            preferenceButton06CircleShadow.alpha = 1
            lastSelectedWritingPreferences[1] = 6
        }
    }
    
    @objc func scrollBegan(_ gesture: UIPanGestureRecognizer){
//        var previousScrollPossition = notebookView.scrollView!.contentOffset
//        var newPosition: CGPoint?
//        while previousScrollPossition != newPosition{
//            previousScrollPossition = notebookView.scrollView!.contentOffset
//            for annotation in notebookView.currentPage!.annotations{
//                if let drawing = annotation as? DrawingAnnotation{
//                    notebookView.currentPage?.removeAnnotation(drawing)
//                    notebookView.currentPage?.addAnnotation(drawing)
//                }
//            }
//            newPosition = notebookView.scrollView!.contentOffset
//        }
//        currentlyScrolling = false
    }
    
}

class PDFScrollGestureDelegate: NSObject, UIGestureRecognizerDelegate{
    var controller: EditingViewController!
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class ToolPanDelegate: NSObject, UIGestureRecognizerDelegate{
    
    var controller: EditingViewController!
    weak var pdfView: NotebookView!
    private var path: UIBezierPath?
    private var currentPage: PDFPage?
    let centralManager = CBCentralManager()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        pdfView.annotating = true
        if UIDevice.current.userInterfaceIdiom == .phone{
            return true
        } else if UIDevice.current.userInterfaceIdiom == .pad{
            let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")])
            if peripherals.contains(where: isApplePencil){
                if touch.type == .stylus{
                    controller.touchesComingFromPencil = true
                    return true
                } else {
                    controller.touchesComingFromPencil = false
                    return false
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func isApplePencil(peripheral: CBPeripheral) -> Bool{
        return peripheral.name == "Apple Pencil"
    }
}


class ToolPanGestureRecognizer: UIPanGestureRecognizer{
    var touchPencil = false
    var currentPoint: CGPoint!
    var currentForce: CGFloat!
    var currentAsimuth: CGFloat!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        var checkTouches: [UITouch] = []
        if let coallescedTouches = event.coalescedTouches(for: touches.first!){
            checkTouches = coallescedTouches
        } else {
            checkTouches.append(touches.first!)
        }
        for touch in checkTouches{
            if touch.type == .stylus{
                touchPencil = true
                currentForce = touch.force
                currentAsimuth = touch.azimuthAngle(in: self.view)
            } else {
                touchPencil = false
            }
            currentPoint = touch.location(in: self.view)
            super.touchesBegan(touches, with: event)
            state = .began
            let drawingDelegate = delegate as! ToolPanDelegate
            drawingDelegate.controller.drawingGesture(self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        var checkTouches: [UITouch] = []
        if let coallescedTouches = event.coalescedTouches(for: touches.first!){
            checkTouches = coallescedTouches
        } else {
            checkTouches.append(touches.first!)
        }
        for touch in checkTouches{
            if touch.type == .stylus{
                touchPencil = true
                currentForce = touch.force
                currentAsimuth = touch.azimuthAngle(in: self.view)
            } else {
                touchPencil = false
            }
            currentPoint = touch.location(in: self.view)
            super.touchesMoved(touches, with: event)
            let drawingDelegate = delegate as! ToolPanDelegate
            state = .changed
            drawingDelegate.controller.drawingGesture(self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first{
            if touch.type == .stylus{
                touchPencil = true
                currentForce = touch.force
                currentAsimuth = touch.azimuthAngle(in: self.view)
            } else {
                touchPencil = false
            }
            currentPoint = touch.location(in: self.view)
        }
        super.touchesEnded(touches, with: event)
        let drawingDelegate = delegate as! ToolPanDelegate
        state = .changed
        drawingDelegate.pdfView.annotating = false
        drawingDelegate.controller.drawingGesture(self)
    }
}

class DrawingAnnotation: PDFAnnotation {
    var pathsToDraw = [UIBezierPath]()
    var controller: EditingViewController!
    var visibleRect: CGRect{
        get{
            var origin = controller.notebookView.convert(CGPoint(x: controller.notebookView.frame.origin.x - 5, y: controller.notebookView.frame.height + 5), to: controller.notebookView.currentPage!)
            var size = CGSize(width: controller.notebookView.scrollView!.bounds.size.width + 10, height: controller.notebookView.scrollView!.bounds.size.height + 10)
            origin.x = origin.x / controller.notebookView.scaleFactor + 10
            origin.y = origin.y / controller.notebookView.scaleFactor + 10
            size.width = size.width / controller.notebookView.scrollView!.zoomScale
            size.height = size.height / controller.notebookView.scrollView!.zoomScale
            return CGRect(origin: origin, size: size)
        }
    }
//    var borders = [PDFBorder]()
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        if !controller.notebookView.scrollView!.isZooming{
            UIGraphicsPushContext(context)
    //        context.saveGState()
            context.setShouldAntialias(false)
            print("\n\n\n\n View Bounds \n \(controller.notebookView.bounds)")
            print("\n\n\n\n Document Bounds \n \(controller.notebookView.documentView?.bounds)")
            print("\n\n\n\n View frame \n \(controller.notebookView.frame)")
            print("\n\n\n\n Visible Rect \n \(visibleRect)")
            
                for index in 0..<pathsToDraw.count{
//                    if visibleRect.contains(pathsToDraw[index].bounds){
                        let pathCopy = pathsToDraw[index]
                        color.set()
                        pathCopy.lineJoinStyle = .round
                        pathCopy.lineCapStyle = .round
                        pathCopy.stroke()
//                    }
                }
            
    //        context.restoreGState()
                
            UIGraphicsPopContext()
        }
    }
}

