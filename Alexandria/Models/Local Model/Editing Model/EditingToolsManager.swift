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
import CoreImage
import CoreBluetooth
import PDFKit

extension EditingViewController{
    
    @objc func drawingGesture(_ gesture: ToolPanGestureRecognizer){
		if toolBox.toolManager.tools[currentTool] as? InkTool != nil{
			if gesture.touchPencil{
				drawInkForUser(gesture)
			} else {
				if UIDevice.current.userInterfaceIdiom != .pad{
					drawInkForUser(gesture)
				} else if !CBCentralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: "180A")]).contains(where: isApplePencil){
					drawInkForUser(gesture)
				}
			}
		}
    }
    
    @objc func drawInkForUser(_ gesture: ToolPanGestureRecognizer){
        if gesture.state == .began{
			let currentPage: PDFPage = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.currentPage!
			let convertedPoint: CGPoint = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.convert(gesture.currentPoint, to: currentPage)
            drawingPath = UIBezierPath()
            drawingPath.move(to: convertedPoint)
			currentGroup = InkGroup(fileView.pageViewControllers[fileView.currentPageViewController]!.pdfPageInfo!.inkData)
			currentGroup.children = []
			fileView.pageViewControllers[fileView.currentPageViewController]?.pdfPageInfo?.layerData.layers.append(LayerObject("ink", fileView.pageViewControllers[fileView.currentPageViewController]!.pdfPageInfo!.inkData.groups.count, fileView.pageViewControllers[fileView.currentPageViewController]!.pdfPageInfo!.layerData))
			fileView.pageViewControllers[fileView.currentPageViewController]?.pdfPageInfo?.inkData.groups.append(currentGroup)
			if currentWrittingTool == "pen"{
				let firstPreference = latestPreferences[currentTool].lastPicked[0]
				let tool = toolBox.toolManager.tools[currentTool] as! InkTool
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835))
			} else if currentWrittingTool == "eraser"{
				let firstPreference = latestPreferences[currentTool].lastPicked[0]
				let tool = toolBox.toolManager.tools[currentTool] as! InkTool
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835))
			}
        } else if gesture.state == .changed{
			let currentPage: PDFPage = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.currentPage!
			let convertedPoint: CGPoint = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.convert(gesture.currentPoint, to: currentPage)
            let tempPoint = drawingPath.currentPoint
            let pressure = (gesture.currentForce ?? 0) - 0.333
			let firstPreference = latestPreferences[currentTool].lastPicked[0]
            let secondPreference = latestPreferences[currentTool].lastPicked[1]
            var color: UIColor!
			let tool = toolBox.toolManager.tools[currentTool] as! InkTool
			if currentWrittingTool == "pencil"{
				drawingPath = UIBezierPath()
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + 0
				color = UIColor(patternImage: UIImage(named: "pencilTexture")!.withTintColor(UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 0.7 + pressure)))
			} else if currentWrittingTool == "highlighter"{
				drawingPath = UIBezierPath()
				color = UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 0.6)
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + gesture.currentAsimuth
			} else {
				drawingPath = UIBezierPath()
				color = UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 1)
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + pressure
			}
			drawingPath.move(to: tempPoint)
			drawingPath.addQuadCurve(to: convertedPoint, controlPoint: drawingPath.currentPoint)
			if currentWrittingTool != "eraser"{
				currentGroup.children.append(InkObject(tempPoint, convertedPoint, drawingPath.lineWidth, currentGroup, color))
			}
			
			let caLayer: CAShapeLayer!
			if currentWrittingTool != "eraser" || currentWrittingTool != "pen"{
				caLayer = CAShapeLayer()
			} else {
				caLayer = currentLayer
				caLayer.removeFromSuperlayer()
				if currentWrittingTool == "eraser"{
					caLayer.compositingFilter = "sourceOutCompositing"
				}
			}
            caLayer.frame = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.currentPage!.bounds(for: .mediaBox)
            caLayer.masksToBounds = true
            caLayer.path = drawingPath.cgPath
            caLayer.strokeColor = color.cgColor
            caLayer.lineWidth = drawingPath.lineWidth
            caLayer.lineCap = .round
            caLayer.lineJoin = .round
            caLayer.miterLimit = -10
            let mirror = CGAffineTransform(scaleX: 1, y: -1)
            caLayer.setAffineTransform(mirror)
			fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.subviews[0].subviews[0].subviews[1].layer.addSublayer(caLayer)
			removableDrawings.append(caLayer)
        } else if gesture.state == .ended {
			let currentPage: PDFPage = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.currentPage!
			let convertedPoint: CGPoint = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.convert(gesture.currentPoint, to: currentPage)
			let tempPoint = drawingPath.currentPoint
			let pressure = (gesture.currentForce ?? 0) - 0.333
			let firstPreference = latestPreferences[currentTool].lastPicked[0]
			let secondPreference = latestPreferences[currentTool].lastPicked[1]
			var color: UIColor!
			let tool = toolBox.toolManager.tools[currentTool] as! InkTool
			if currentWrittingTool == "pencil"{
				drawingPath = UIBezierPath()
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + 0
				color = UIColor(patternImage: UIImage(named: "pencilTexture")!.withTintColor(UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 0.7 + pressure)))
			} else if currentWrittingTool == "highlighter"{
				drawingPath = UIBezierPath()
				color = UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 0.6)
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + gesture.currentAsimuth
			} else {
				drawingPath = UIBezierPath()
				color = UIColor(red: CGFloat(tool.colors[secondPreference - 3].red.value!), green: CGFloat(tool.colors[secondPreference - 3].green.value!), blue: CGFloat(tool.colors[secondPreference - 3].blue.value!), alpha: 1)
				drawingPath.lineWidth = (CGFloat(tool.thicknesses[firstPreference].value.value! * 2.835)) + pressure
			}
			drawingPath.move(to: tempPoint)
			drawingPath.addQuadCurve(to: convertedPoint, controlPoint: drawingPath.currentPoint)
			if currentWrittingTool != "eraser"{
				currentGroup.children.append(InkObject(tempPoint, convertedPoint, drawingPath.lineWidth, currentGroup, color))
			}
			
			let caLayer: CAShapeLayer!
			if currentWrittingTool != "eraser" || currentWrittingTool != "pen"{
				caLayer = CAShapeLayer()
			} else {
				caLayer = currentLayer
				caLayer.removeFromSuperlayer()
				if currentWrittingTool == "eraser"{
					let drawings = fileView.pageViewControllers[fileView.currentPageViewController]?.pdfPageInfo?.inkData.groups
					caLayer.compositingFilter = "sourceOutCompositing"
					DispatchQueue.global(qos: .background).async {
						for group in drawings ?? []{
							for child in group.children {
								if child.path.bounds.contains(self.drawingPath.bounds){
									group.children.append(InkObject(tempPoint, convertedPoint, self.drawingPath.lineWidth, group, .clear))
								}
							}
						}
						DispatchQueue.main.sync {
							self.fileView.pageViewControllers[self.fileView.currentPageViewController]?.writeChages()
						}
					}
				}
			}
			caLayer.frame = fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.currentPage!.bounds(for: .mediaBox)
			caLayer.masksToBounds = true
			caLayer.path = drawingPath.cgPath
			caLayer.strokeColor = color.cgColor
			caLayer.lineWidth = drawingPath.lineWidth
			caLayer.lineCap = .round
			caLayer.lineJoin = .round
			caLayer.miterLimit = -10
			let mirror = CGAffineTransform(scaleX: 1, y: -1)
			caLayer.setAffineTransform(mirror)
			fileView.pageViewControllers[fileView.currentPageViewController]!.contentView.subviews[0].subviews[0].subviews[1].layer.addSublayer(caLayer)
			removableDrawings.append(caLayer)
			if currentWrittingTool != "eraser"{
				fileView.pageViewControllers[fileView.currentPageViewController]?.pdfPageInfo?.layerData.layers.append(LayerObject("ink", fileView.pageViewControllers[fileView.currentPageViewController]!.pdfPageInfo!.inkData.groups.count, 				fileView.pageViewControllers[fileView.currentPageViewController]!.pdfPageInfo!.layerData))
				fileView.pageViewControllers[fileView.currentPageViewController]?.pdfPageInfo?.inkData.groups.append(currentGroup)
				self.fileView.pageViewControllers[fileView.currentPageViewController]?.writeChages()
			}
        } else if gesture.state == .cancelled{
			
        }
    }
    
    func setupToolDelegates(){
        toolPanDelegate.controller = self
        inkToolPan = ToolPanGestureRecognizer()
		linkToolPan = ToolPanGestureRecognizer()
		textToolPan = ToolPanGestureRecognizer()
		lassoToolPan = ToolPanGestureRecognizer()
        toolPanDelegate.pdfView = fileView
        inkToolPan.delegate = toolPanDelegate
		linkToolPan.delegate = toolPanDelegate
		textToolPan.delegate = toolPanDelegate
		lassoToolPan.delegate = toolPanDelegate
    }
    
    func isApplePencil(peripheral: CBPeripheral) -> Bool{
        return peripheral.name == "Apple Pencil"
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
    weak var pdfView: EditorView!
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

//class DrawingAnnotation: PDFAnnotation {
//    var pathsToDraw = [UIBezierPath]()
//    var controller: EditingViewController!
//    var visibleRect: CGRect{
//        get{
//            var origin = controller.notebookView.convert(CGPoint(x: controller.notebookView.frame.origin.x - 5, y: controller.notebookView.frame.height + 5), to: controller.notebookView.currentPage!)
//            var size = CGSize(width: controller.notebookView.scrollView!.bounds.size.width + 10, height: controller.notebookView.scrollView!.bounds.size.height + 10)
//            origin.x = origin.x / controller.notebookView.scaleFactor + 10
//            origin.y = origin.y / controller.notebookView.scaleFactor + 10
//            size.width = size.width / controller.notebookView.scrollView!.zoomScale
//            size.height = size.height / controller.notebookView.scrollView!.zoomScale
//            return CGRect(origin: origin, size: size)
//        }
//    }
////    var borders = [PDFBorder]()
//    override func draw(with box: PDFDisplayBox, in context: CGContext) {
//        if !controller.notebookView.scrollView!.isZooming{
//            UIGraphicsPushContext(context)
//    //        context.saveGState()
//            context.setShouldAntialias(false)
//            print("\n\n\n\n View Bounds \n \(controller.notebookView.bounds)")
//            print("\n\n\n\n Document Bounds \n \(controller.notebookView.documentView?.bounds)")
//            print("\n\n\n\n View frame \n \(controller.notebookView.frame)")
//            print("\n\n\n\n Visible Rect \n \(visibleRect)")
//
//                for index in 0..<pathsToDraw.count{
////                    if visibleRect.contains(pathsToDraw[index].bounds){
//                        let pathCopy = pathsToDraw[index]
//                        color.set()
//                        pathCopy.lineJoinStyle = .round
//                        pathCopy.lineCapStyle = .round
//                        pathCopy.stroke()
////                    }
//                }
//
//    //        context.restoreGState()
//
//            UIGraphicsPopContext()
//        }
//    }
//}

