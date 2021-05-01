//
//  EditorViewPageViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/25/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import PDFKit
import CoreGraphics

class EditorViewPageViewController: UIViewController {
	
	var controller: EditorView!
	var pdfPage: PDFPage!
	var pageNumber: Int!
	var pdfPageInfo: EditableUserData?
	var contentView: EditorViewPageViewControllerContentView!
	var undoneActions: [EditableUserData?] = []
	
	init(_ pdfPage: PDFPage, _ pageNumber: Int, _ scale: CGFloat, _ currentAnnotation: String, _ controller: EditorView){
		super.init(nibName: nil, bundle: nil)
		self.pdfPage = pdfPage
		self.contentView = EditorViewPageViewControllerContentView(pdfPage, currentAnnotation, self)
		self.controller = controller
		self.pageNumber = pageNumber
		setupConstraints()
		pdfPageInfo = EditableUserData(pageNumber, self.controller.currentInfo, true, { userData in
			userData.backgroundFetch(pageNumber, controller.currentInfo, {success in
				if success{
					self.updateView(userData)
					self.pdfPageInfo = userData
				} else {
					print("something went wrong loading assets")
				}
			})
		})
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func loadController(_ pdfPage: PDFPage, _ pageNumber: Int, _ scale: CGFloat, _ currentAnnotation: String) {
		self.pdfPage = pdfPage
		contentView.controller = self
		contentView.pdfPage = pdfPage
		contentView.document = PDFDocument()
		contentView.document?.insert(pdfPage, at: 0)
		contentView.currentAnnotations = currentAnnotation
		self.pageNumber = pageNumber
		pdfPageInfo = EditableUserData(pageNumber, controller.currentInfo, false, nil)
		self.updateView(pdfPageInfo)
//		pdfPageInfo = EditableUserData(pageNumber, self.controller.currentInfo, true, { userData in
//			userData.backgroundFetch(pageNumber, self.controller.currentInfo, {success in
//				if success{
//					self.updateView(userData)
//					self.pdfPageInfo = userData
//				} else {
//					print("something went wrong loading assets")
//				}
//			})
//		})
	}
	
	func setupConstraints(){
		self.view.addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
		contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
		contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
		contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
		contentView.documentView?.backgroundColor = .clear
	}
	
	func updateView(_ pdfPageInfo: EditableUserData?){
		if pdfPageInfo != nil{
			for layer in pdfPageInfo?.layerData.layers ?? []{
				if layer.type == .ink{
					let inkLayer = pdfPageInfo!.inkData.groups[layer.index]
					for path in inkLayer.children{
						let caLayer = CAShapeLayer()
						caLayer.frame = pdfPage.bounds(for: .mediaBox)
						caLayer.masksToBounds = true
						caLayer.path = path.path.cgPath
						var alpha:CGFloat = 0
						path.color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
						if alpha == 0{
							caLayer.compositingFilter = "sourceOutCompositing"
						}
						caLayer.strokeColor = path.color.cgColor
						caLayer.lineWidth = path.path.lineWidth
						caLayer.lineCap = .round
						caLayer.lineJoin = .round
						caLayer.miterLimit = -10
						let mirror = CGAffineTransform(scaleX: 1, y: -1)
						caLayer.setAffineTransform(mirror)
						contentView.subviews[0].subviews[0].subviews[1].layer.addSublayer(caLayer)
					}
				} else if layer.type == .text{
					let textLayer = pdfPageInfo!.textData.contents[layer.index]
					let caLayer = CALayer()
					caLayer.frame = pdfPage.bounds(for: .mediaBox)
					caLayer.masksToBounds = true
					let rotation = CATransform3DMakeRotation(textLayer.rotation, 0, 0, 1.0)
					let textView = UITextView(frame: textLayer.position)
					textView.attributedText = textLayer.text
					textView.isUserInteractionEnabled = true
					let textContent = CALayer()
					textContent.frame = textView.frame
					textContent.contents = textView
					textContent.contentsGravity = .resizeAspect
					textContent.transform = rotation
					caLayer.addSublayer(textContent)
					let mirror = CGAffineTransform(scaleX: 1, y: -1)
					caLayer.setAffineTransform(mirror)
					contentView.subviews[0].subviews[0].subviews[1].layer.addSublayer(caLayer)
				} else if layer.type == .link{
					
				} else if layer.type == .image{
					let imageLayer = pdfPageInfo!.imgData.images[layer.index]
					let caLayer = CALayer()
					caLayer.frame = pdfPage.bounds(for: .mediaBox)
					caLayer.masksToBounds = true
					let rotation = CATransform3DMakeRotation(imageLayer.rotation, 0, 0, 1.0)
					let image = UIImage(data: imageLayer.data)!
					let imageView = CALayer()
					imageView.contents = image
					imageView.contentsGravity = .resizeAspect
					imageView.transform = rotation
					caLayer.addSublayer(imageView)
					let mirror = CGAffineTransform(scaleX: 1, y: -1)
					caLayer.setAffineTransform(mirror)
					contentView.subviews[0].subviews[0].subviews[1].layer.addSublayer(caLayer)
				}
			}
		}
	}
	
	func writeChages(){
		pdfPageInfo?.writeToFile("\(controller.currentInfo.contentAddress!)/\(controller.currentInfo.pageIDs[pageNumber])", { success in
			if success {
				print("everything saved")
			} else {
				print("error saving")
			}
		})
	}

}

class EditorViewPageViewControllerContentView: PDFView{
	var pdfPage: PDFPage!
	var currentAnnotations: String!
	var controller: EditorViewPageViewController!
	
	convenience init(_ pdfPage: PDFPage, _ currentAnnotations: String,_ controller: EditorViewPageViewController) {
		self.init()
		self.controller = controller
		self.pdfPage = pdfPage
		self.document = PDFDocument()
		self.document?.insert(pdfPage, at: 0)
		self.currentAnnotations = currentAnnotations
	}
}
