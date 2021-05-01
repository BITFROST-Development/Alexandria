//
//  EditorViewDataModels.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/30/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import PDFKit

class EditableUserData{
	var layerData: LayerData!
	var inkData: InkData!
	var imgData: ImageData!
	var linkData: LinkData!
	var textData: TextData!
	var controller: EditorFileInfo!
	
	init(_ pageNumber: Int, _ controller: EditorFileInfo, _ backgroudFetch: Bool, _ completion: ((EditableUserData) -> Void)? ) {
		self.controller = controller
		self.layerData = LayerData()
		self.inkData = InkData()
		self.imgData = ImageData()
		self.linkData = LinkData()
		self.textData = TextData()
		if backgroudFetch{
			completion?(self)
		} else {
			self.fetch(pageNumber, controller, nil)
		}
	}
	
	init(_ layerData: LayerData, _ inkData: InkData, _ imgData: ImageData, _ linkData: LinkData, _ textData: TextData, _ controller: EditorFileInfo) {
		self.controller = controller
		self.layerData = layerData
		self.inkData = inkData
		self.imgData = imgData
		self.linkData = linkData
		self.textData = textData
	}
	
	func backgroundFetch(_ pageNumber: Int, _ controller: EditorFileInfo, _ completion: @escaping(Bool) -> Void){
		DispatchQueue.global().async {
			self.fetch(pageNumber, controller, completion)
		}
	}
	
	func forgroundFetch(_ pageNumber: Int, _ controller: EditorFileInfo){
		fetch(pageNumber, controller, nil)
	}
	
	private func fetch(_ pageNumber: Int, _ controller: EditorFileInfo, _ completion: ((Bool) -> Void)?){
		self.controller = controller
		self.layerData = LayerData()
		self.inkData = InkData()
		self.imgData = ImageData()
		self.linkData = LinkData()
		self.textData = TextData()
		
		let currentPageData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(controller.contentAddress).appendingPathComponent(controller.pageIDs[pageNumber])
		
		let layerInfo = try! Data(contentsOf: currentPageData.appendingPathComponent("layer"))
		layerInfo.withUnsafeBytes({
			
			let buffers = $0.split(separator: UInt8(ascii: "\n"))
			for buffer in buffers{
				let currentLayer = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
				self.layerData.layers.append(LayerObject(currentLayer[1], Int(currentLayer[2])!, self.layerData))
			}
			
		})
		
		let inkInfo = try! Data(contentsOf: currentPageData.appendingPathComponent("ink"))
		inkInfo.withUnsafeBytes({
			let buffers = $0.split(separator: UInt8(ascii: "\n"))
			var index = 0
			while index < buffers.count{
				var buffer = buffers[index]
				let currentInkGroup = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
				let currentInkGroupObject = InkGroup(self.inkData)
				for _ in 0..<Int(currentInkGroup[3])!{
					index += 1
					buffer = buffers[index]
					let currentInkObject = String(decoding: buffer, as: UTF8.self).components(separatedBy: " ")
					let startPoint = CGPoint(x: Double(currentInkObject[0])!, y: Double(currentInkObject[1])!)
					let endPoint = CGPoint(x: Double(currentInkObject[2])!, y: Double(currentInkObject[3])!)
					let lineWidth = CGFloat(Double(currentInkObject[4])!)
					let color = UIColor(red: CGFloat(Double(currentInkObject[5])!), green: CGFloat(Double(currentInkObject[6])!), blue: CGFloat(Double(currentInkObject[7])!), alpha: CGFloat(Double(currentInkObject[8])!))
					currentInkGroupObject.children.append(InkObject(startPoint, endPoint, lineWidth, currentInkGroupObject, color))
				}
				self.inkData.groups.append(currentInkGroupObject)
				index += 2
			}
		})
		
		let imageInfo = try! Data(contentsOf: currentPageData.appendingPathComponent("image"))
		imageInfo.withUnsafeBytes({
			let buffers = $0.split(separator: UInt8(ascii: "\n"))
			var index = 0
			while index < buffers.count{
				var buffer = buffers[index]
				let currentImageDrawingData = String(decoding: buffer, as: UTF8.self).components(separatedBy: " ")
				index += 1
				buffer = buffers[index]
				let binaryData = Data(buffer)
				self.imgData.images.append(ImageObject(binaryData, CGRect(x: Double(currentImageDrawingData[0])!, y: Double(currentImageDrawingData[1])!, width: Double(currentImageDrawingData[2])!, height: Double(currentImageDrawingData[4])!), CGFloat(Double(currentImageDrawingData[5])!), self.imgData))
				index += 1
			}
		})
		
		let linkInfo = try! Data(contentsOf: currentPageData.appendingPathComponent("link"))
		linkInfo.withUnsafeBytes({
			let buffers = $0.split(separator: UInt8(ascii: "\n"))
			if buffers.count > 0{
				let idTableString = String(decoding: buffers[0], as: UTF8.self)
				let currentIDTable = Data(base64Encoded: idTableString)
				let decoder = JSONDecoder()
				if currentIDTable != nil{
					self.linkData.idTable = try! decoder.decode(Set<String>.self, from: currentIDTable!)
				}
				var index = 1
				while index < buffers.count{
					var buffer = buffers[index]
					let currentLinkData = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
					let currentLink = LinkCluster(currentLinkData[4], self.linkData)
					index += 1
					buffer = buffers[index]
					let currentRoot = String(decoding: buffer, as: UTF8.self).components(separatedBy: " ")
					currentLink.root = LinkObject("", pageNumber, CGRect(x: Double(currentRoot[0])!, y: Double(currentRoot[1])!, width: Double(currentRoot[2])!, height: Double(currentRoot[3])!), currentLinkData[4], currentLink)
					index += 1
					buffer = buffers[index]
					let linkIDTableString = String(decoding: buffer, as: UTF8.self)
					let linkIDTable = Data(base64Encoded: linkIDTableString)
					if linkIDTable != nil{
						currentLink.idTable = try! decoder.decode(Set<String>.self, from: linkIDTable!)
					}
					for _ in 0..<Int(currentLinkData[3])!{
						index += 1
						buffer = buffers[index]
						let currentConnection = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
						currentLink.objects.append(LinkObject(currentConnection[1], Int(currentConnection[2])!, currentConnection[3], currentLink))
					}
					self.linkData.clusters.append(currentLink)
					index += 2
				}
			}
		})
		
		let textInfo = try! Data(contentsOf: currentPageData.appendingPathComponent("text"))
		textInfo.withUnsafeBytes({
			let buffers = $0.split(separator: UInt8(ascii: "\n"))
			var index = 0
			while index < buffers.count{
				var buffer = buffers[index]
				let currentTextData = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
				let currentText = TextObject(self.textData)
				currentText.position = CGRect(x: Double(currentTextData[4])!, y: Double(currentTextData[5])!, width: Double(currentTextData[6])!, height: Double(currentTextData[7])!)
				currentText.rotation = CGFloat(Double(currentTextData[8])!)
				for _ in 0..<Int(currentTextData[3])!{
					index += 1
					buffer = buffers[index]
					let currentSectionContent = String(decoding: buffer, as: UTF8.self).removingPercentEncoding!
					index += 1
					buffer = buffers[index]
					let currentSectionData = String(decoding: buffer, as: UTF8.self).components(separatedBy: "/")
					currentText.content.append(TextSection(currentSectionContent, currentSectionData[1], currentSectionData[2], CGFloat(Double(currentSectionData[3])!), UIColor(red: CGFloat(Double(currentSectionData[6])!), green: CGFloat(Double(currentSectionData[7])!), blue: CGFloat(Double(currentSectionData[8])!), alpha: CGFloat(Double(currentSectionData[9])!)), Int(currentSectionData[4])!, CGFloat(Double(currentSectionData[5])!)))
				}
				index += 2
			}
		})
		completion?(true)
	}
	
	func writeToFile(_ address: String, _ completion: @escaping(Bool) -> Void){
		DispatchQueue.global().async {
			let pageDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(address)
			let layerURL = pageDataURL.appendingPathComponent("layer")
			let inkURL = pageDataURL.appendingPathComponent("ink")
			let imageURL = pageDataURL.appendingPathComponent("image")
			let linkURL = pageDataURL.appendingPathComponent("link")
			let textURL = pageDataURL.appendingPathComponent("text")
			do {
				try self.layerData.toString().write(to: layerURL, atomically: true, encoding: .utf8)
				try self.inkData.toString().write(to: inkURL, atomically: true, encoding: .utf8)
				try self.imgData.toString().write(to: imageURL, atomically: true, encoding: .utf8)
				try self.linkData.toString().write(to: linkURL, atomically: true, encoding: .utf8)
				try self.textData.toString().write(to: textURL, atomically: true, encoding: .utf8)
				completion(true)
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
	}
}



class LayerData{
	var layers: [LayerObject]!
	
	init() {
		self.layers = []
	}
	
	init(_ layers: [LayerObject]) {
		self.layers = layers
	}
	
	func toString() -> String{
		var dataString = ""
		var counter = 0
		for layer in layers{
			dataString = "\(dataString)\(layer.toString())"
			if counter < layers.count - 1{
				dataString = "\(dataString)\n"
			}
			counter += 1
		}
		return dataString
	}
}

class LayerObject{
	var type: LayerObjecType!
	var index: Int
	var parent: LayerData!
	
	init(_ type: String, _ indexInFile: Int) {
		switch type {
		case "ink":
			self.type = .ink
		case "image":
			self.type = .image
		case "link":
			self.type = .link
		case "text":
			self.type = .text
		default:
			print("something went wrong in Layer Object Creation")
		}
		self.index = indexInFile
	}
	
	init(_ type: String, _ indexInFile: Int, _ parent: LayerData) {
		switch type {
		case "ink":
			self.type = .ink
		case "image":
			self.type = .image
		case "link":
			self.type = .link
		case "text":
			self.type = .text
		default:
			print("something went wrong in Layer Object Creation")
		}
		self.index = indexInFile
		self.parent = parent
	}
	
	func toString() -> String{
		return "/\(type.rawValue)/\(index)/"
	}
}

enum LayerObjecType: String {
	case ink = "ink"
	case image = "image"
	case link = "link"
	case text = "text"
}



class InkData{
	var groups: [InkGroup]!
	
	init() {
		self.groups = []
	}
	
	init(_ groups: [InkGroup]){
		self.groups = groups
		for group in self.groups{
			group.parent = self
		}
	}
	
	func toString() -> String{
		var dataString = ""
		var counter = 0
		for group in groups{
			dataString = dataString + "\(group.toString())"
			if counter < groups.count - 1{
				dataString = "\(dataString)\n"
			}
			counter += 1
		}
		return dataString
	}
}

class InkGroup{
	var children: [InkObject]!
	var parent: InkData!
	
	init(_ parent: InkData) {
		self.parent = parent
		self.children = []
	}
	
	init(_ children: [InkObject], _ parent: InkData) {
		self.children = children
		self.parent = parent
		for child in self.children{
			child.parentGroup = self
		}
	}
	
	
	init(_ children: [InkObject]) {
		self.children = children
		for child in self.children{
			child.parentGroup = self
		}
	}
	
	func toString() -> String {
		var groupString = "/group/begin/\(children.count)/\n"
		for child in children{
			groupString = groupString + "\(child.toString())\n"
		}
		return groupString + "/group/end/"
	}
}

class InkObject{
	var path: UIBezierPath!{
		get{
			let returningPath = UIBezierPath()
			returningPath.move(to: startPoint)
			returningPath.addLine(to: endPoint)
			returningPath.lineWidth = lineWidth
			return returningPath
		}
	}
	var startPoint: CGPoint!
	var endPoint: CGPoint!
	var lineWidth: CGFloat!
	var parentGroup: InkGroup!
	var color: UIColor!
	
	init(_ startPoint: CGPoint, _ endPoint: CGPoint, _ lineWidth: CGFloat, _ parent: InkGroup, _ color: UIColor) {
		self.startPoint = startPoint
		self.endPoint = endPoint
		self.lineWidth = lineWidth
		self.parentGroup = parent
		self.color = color
	}
	
	init(_ startPoint: CGPoint, _ endPoint: CGPoint, _ lineWidth: CGFloat, _ color: UIColor) {
		self.startPoint = startPoint
		self.endPoint = endPoint
		self.lineWidth = lineWidth
		self.color = color
	}
	
	func toString() -> String{
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return "\(startPoint.x) \(startPoint.y) \(endPoint.x) \(endPoint.y) \(lineWidth!) \(red) \(green) \(blue) \(alpha)"
	}
}


class ImageData{
	var images: [ImageObject]!
	
	init(){
		self.images = []
	}
	
	init(_ images: [ImageObject]) {
		self.images = images
	}
	
	func toString() -> String{
		var dataString = ""
		var counter = 0
		for image in images{
			dataString = "\(dataString)\(image.toString())"
			if counter < images.count - 1{
				dataString = "\(dataString)\n"
			}
			counter += 1
		}
		return dataString
	}
}

class ImageObject{
	var data: Data!
	var position: CGRect!
	var rotation: CGFloat!
	var parent: ImageData!
	
	init(_ data: Data, _ position: CGRect, _ rotation: CGFloat, _ parent: ImageData){
		self.data = data
		self.position = position
		self.parent = parent
	}
	
	init(_ data: Data, _ position: CGRect, _ rotation: CGFloat){
		self.data = data
		self.position = position
	}
	
	func toString() -> String{
		return "\(position.origin.x) \(position.origin.y) \(position.width) \(position.height) \(rotation!)\n\(data.base64EncodedString())"
	}
}


class LinkData{
	var clusters: [LinkCluster]!
	var idTable: Set<String>!
	
	init() {
		self.clusters = []
		self.idTable = Set<String>()
	}
	
	init(_ clusters: [LinkCluster]){
		self.clusters = clusters
		self.idTable = Set<String>()
	}
	
	init(_ clusters: [LinkCluster], _ idTable: Set<String>){
		self.clusters = clusters
		self.idTable = idTable
	}
	
	func toString() -> String{
		var dataString = ""
		let encoder = JSONEncoder()
		let tableData = try! encoder.encode(idTable)
		dataString = "\(tableData.base64EncodedString())/n"
		var counter = 0
		for cluster in clusters{
			dataString = "\(dataString)\(cluster.toString())"
			if counter < clusters.count - 1{
				dataString = "\(dataString)\n"
			}
			counter += 1
		}
		return dataString
	}
}

class LinkCluster{
	var objects: [LinkObject]!
	var parent: LinkData!
	var clusterID: String!
	var idTable: Set<String> = Set<String>()
	var root: LinkObject!
	
	init(_ parent: LinkData) {
		self.parent = parent
		self.objects = []
		var id = randomString(length: 30)
		while parent.idTable.contains(id) {
			id = randomString(length: 30)
		}
		self.clusterID = id
	}
	
	init(_ parent: LinkData, _ objects: [LinkObject]) {
		self.parent = parent
		self.objects = objects
		var id = randomString(length: 30)
		while parent.idTable.contains(id) {
			id = randomString(length: 30)
		}
		self.clusterID = id
	}
	
	init(_ clusterID: String) {
		self.objects = []
		self.clusterID = clusterID
	}
	
	init(_ clusterID: String, _ objects: [LinkObject]) {
		self.objects = objects
		self.clusterID = clusterID
	}
	
	init(_ clusterID: String, _ parent: LinkData!) {
		self.objects = []
		self.parent = parent
		self.clusterID = clusterID
	}
	
	init(_ clusterID: String, _ objects: [LinkObject], parent: LinkData!) {
		self.objects = objects
		self.parent = parent
		self.clusterID = clusterID
	}
	
	private func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
	
	func toString() -> String{
		var clusterString = "/link/begin/\(objects.count)/\(clusterID!)/\n"
		clusterString = "\(clusterString)\(root.toString(true))\n"
		let encoder = JSONEncoder()
		let tableData = try! encoder.encode(idTable)
		clusterString = "\(clusterString)\(tableData.base64EncodedString())\n"
		for link in objects{
			clusterString = "\(clusterString)\(link.toString(false))\n"
		}
		clusterString = "\(clusterString)/link/end/"
		return clusterString
	}
}

class LinkObject{
	var path: String!
	var page: Int!
	var position: CGRect!
	var clusterID: String!
	var cluster: LinkCluster!
	
	init(_ path: String, _ page: Int, _ clusterID: String) {
		self.path = path
		self.page = page
		self.clusterID = clusterID
	}
	
	init(_ path: String, _ page: Int, _ clusterID: String, _ cluster: LinkCluster) {
		self.path = path
		self.page = page
		self.clusterID = clusterID
		self.cluster = cluster
	}
	
	init(_ path: String, _ page: Int, _ position: CGRect, _ clusterID: String, _ cluster: LinkCluster){
		self.path = path
		self.page = page
		self.cluster = cluster
		self.clusterID = clusterID
		self.position = position
	}
	
	init(_ path: String, _ page: Int, _ position: CGRect, _ clusterID: String){
		self.path = path
		self.clusterID = clusterID
		self.page = page
		self.position = position
	}
	
	func toString(_ root: Bool) -> String{
		if !root{
			return "/\(path!)/\(page!)/\(clusterID!)/"
		} else {
			return "\(position.origin.x) \(position.origin.y) \(position.width) \(position.height)"
		}
	}
}



class TextData {
	var contents: [TextObject]!
	
	init() {
		self.contents = []
	}
	
	init(_ contents: [TextObject]) {
		self.contents = contents
	}
	
	func toString() -> String{
		var dataString = ""
		var counter = 0
		for object in contents{
			dataString = "\(dataString)\(object.toString())"
			if counter < contents.count - 1{
				dataString = "\(dataString)\n"
			}
			counter += 1
		}
		return dataString
		
	}
}

class TextObject{
	var content: [TextSection]!
	var parent: TextData!
	var position: CGRect!
	var rotation: CGFloat!
	var text: NSAttributedString{
		get{
			let string = NSMutableAttributedString()
			for section in content{
				string.append(section.text)
			}
			return string
		}
	}
	
	init() {
		self.content = []
		self.position = CGRect()
	}
	
	init(_ parent: TextData!) {
		self.parent = parent
		self.content = []
		self.position = CGRect()
		self.rotation = 0
	}
	
	init(_ content: [TextSection]) {
		self.content = content
		self.position = CGRect()
		self.rotation = 0
		for section in self.content{
			section.parent = self
		}
	}
	
	init(_ parent: TextData, _ content: [TextSection]) {
		self.content = content
		self.parent = parent
		self.position = CGRect()
		self.rotation = 0
		for section in self.content{
			section.parent = self
		}
	}
	
	init(_ content: [TextSection], _ position: CGRect, _ rotation: CGFloat) {
		self.content = content
		self.position = position
		self.rotation = rotation
		for section in self.content{
			section.parent = self
		}
	}
	
	init(_ parent: TextData, _ content: [TextSection], _ position: CGRect, _ rotation: CGFloat) {
		self.content = content
		self.parent = parent
		self.position = position
		self.rotation = rotation
		for section in self.content{
			section.parent = self
		}
	}
	
	func toString() -> String{
		var objectData = "/text/begin/\(content.count)/\(position.origin.x)/\(position.origin.y)/\(position.width)/\(position.height)/\(rotation!)/\n"
		for section in content{
			objectData = "\(objectData)\(section.toString())\n"
		}
		objectData = "\(objectData)/text/end/"
		return objectData
	}
}

class TextSection{
	var text: NSAttributedString{
		get{
			return NSAttributedString(string: content, attributes: attributes.attributes)
		}
	}
	var content: String!
	var attributes: TextAttributes!
	var parent: TextObject!
	
	init(_ content: String, _ fontName: String, _ fontStyle: String, _ fontSize: CGFloat, _ fontColor: UIColor, _ alignment: Int, _ spacing: CGFloat) {
		self.content = content
		self.attributes = TextAttributes(fontName, fontStyle, fontSize, fontColor, alignment, spacing)
	}
	
	init(_ content: String, _ parent: TextObject, _ fontName: String, _ fontStyle: String, _ fontSize: CGFloat, _ fontColor: UIColor, _ alignment: Int, _ spacing: CGFloat) {
		self.content = content
		self.parent = parent
		self.attributes = TextAttributes(fontName, fontStyle, fontSize, fontColor, alignment, spacing)
	}
	
	func toString() -> String{
		return "\(content!)\n\(attributes.toString())"
	}
}

class TextAttributes{
	var attributes: [NSAttributedString.Key: Any]{
		get{
			let paragraph = NSMutableParagraphStyle()
			switch alignment {
			case 1:
				paragraph.alignment = .left
				break
			case 2:
				paragraph.alignment = .center
				break
			case 3:
				paragraph.alignment = .right
				break
			case 4:
				paragraph.alignment = .justified
				break
			default:
				print("something went wrong aligning text.")
			}
			paragraph.lineSpacing = spacing
			return (underlined != nil) ? [.font: font, .underlineStyle: underlined!, .foregroundColor: color, .underlineColor: color, .paragraphStyle: paragraph] : [.font: font, .foregroundColor: color, .underlineColor: color, .paragraphStyle: paragraph]
		}
	}
	var font: UIFont{
		get{
			var font: UIFont = UIFont(name: self.name, size: self.size)!
			
			if style.contains("bold"){
				if let fd = UIFontDescriptor().withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold){
					font = UIFont(descriptor: fd, size: self.size)
				} else {
					print("couldn't apply bold")
				}
			} else if style.contains("italics"){
				if let fd = UIFontDescriptor().withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitItalic){
					font = UIFont(descriptor: fd, size: self.size)
				} else {
					print("couldn't apply italics")
				}
			}
			return font
		}
	}
	var underlined: NSUnderlineStyle?{
		get{
			if style.contains("underline"){
				return .single
			} else {
				return nil
			}
		}
	}
	private var name: String!
	private var style: String!
	private var size: CGFloat!
	private var color: UIColor
	private var alignment: Int!
	private var spacing: CGFloat!
	
	init(_ name: String, _ style: String, _ size: CGFloat, _ color: UIColor, _ alignment: Int, _ spacing: CGFloat) {
		self.name = name
		self.style = style
		self.size = size
		self.color = color
		self.alignment = alignment
		self.spacing = spacing
	}
	
	func toString() -> String{
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return "/\(name!)/\(style!)/\(size!)/\(alignment!)/\(spacing!)/\(red)/\(green)/\(blue)/\(alpha)/"
	}
}

