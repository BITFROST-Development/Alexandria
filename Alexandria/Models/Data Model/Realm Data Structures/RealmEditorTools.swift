//
//  RealmEditorTools.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/6/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class EditorTool: Object {
	@objc dynamic var toolID: String?
	fileprivate func generateID() -> String{
		var newIDValue = randomString(length: 16)
		while((realm?.objects(InkTool.self).filter("toolID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(TextTool.self).filter("toolID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(ImageTool.self).filter("toolID == '\(newIDValue)'").count ?? 0) > 0) || ((realm?.objects(StaticTool.self).filter("toolID == '\(newIDValue)'").count ?? 0) > 0){
			newIDValue = "C" + randomString(length: 16)
		}
		return newIDValue
	}

	fileprivate func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}

class InkTool: EditorTool{
//	@objc dynamic var toolID: String?
	@objc dynamic var kind: String?
	var colors = RealmSwift.List<IconColor>()
	var thicknesses = RealmSwift.List<ListWrapperForDouble>()
	
	convenience init(_ toolID: String, _ kind: String, _ colors: RealmSwift.List<IconColor>, _ thicknesses: RealmSwift.List<ListWrapperForDouble>) {
		self.init()
		self.toolID = toolID
		self.kind = kind
		self.colors = colors
		self.thicknesses = thicknesses
	}
	
	convenience init(_ toolID: String, _ kind: String, _ colors: [IconColorDec], _ thicknesses: [Double]) {
		self.init()
		self.toolID = toolID
		self.kind = kind
		for color in colors{
			self.colors.append(IconColor(from: color))
		}
		
		for value in thicknesses{
			self.thicknesses.append(ListWrapperForDouble(value))
		}
	}
	
	convenience init(_ kind: String, _ colors: RealmSwift.List<IconColor>, _ thicknesses: RealmSwift.List<ListWrapperForDouble>) {
		self.init()
		self.toolID = generateID()
		self.kind = kind
		self.colors = colors
		self.thicknesses = thicknesses
	}
	
	convenience init(_ kind: String, _ colors: [IconColorDec], _ thicknesses: [Double]) {
		self.init()
		self.toolID = generateID()
		self.kind = kind
		for color in colors{
			self.colors.append(IconColor(from: color))
		}
		
		for value in thicknesses{
			self.thicknesses.append(ListWrapperForDouble(value))
		}
	}
	
	convenience init(_ decodedInkTool: InkToolDec) {
		self.init()
		self.toolID = decodedInkTool.toolID
		self.kind = decodedInkTool.kind
		for color in decodedInkTool.colors ?? []{
			self.colors.append(IconColor(from: color))
		}
		for value in decodedInkTool.thicknesses ?? []{
			self.thicknesses.append(ListWrapperForDouble(value))
		}
	}
	
	static func != (_ lhs: InkTool, _ rhs: InkToolDec) -> Bool{
		if lhs.toolID != rhs.toolID || lhs.kind != rhs.kind || lhs.colors.count != rhs.colors?.count{
			return false
		}
		
		for index in 0..<(rhs.colors?.count ?? 0){
			if !IconColor.equals(lhs.colors[index], rhs.colors?[index]){
				return false
			}
		}
		
		for index in 0..<(rhs.thicknesses?.count ?? 0){
			if lhs.thicknesses[index].value.value == rhs.thicknesses![index]{
				return false
			}
		}
		
		return true
	}
	
}

class TextTool: EditorTool{
//	@objc dynamic var toolID: String?
	@objc dynamic var kind: String?
	@objc dynamic var fontName: String?
	var fontSize = RealmOptional<Double>()
	@objc dynamic var fontStyle: String?
	var textAlignment = RealmOptional<Double>()
	var spacing = RealmOptional<Double>()
	@objc dynamic var color: IconColor?
	
	convenience init(_ toolID: String, _ kind: String, _ fontName: String, _ fontSize: Double, _ fontStyle: String, _ textAlignment: Double, _ spacing: Double, _ color: IconColor) {
		self.init()
		self.toolID = toolID
		self.kind = kind
		self.fontName = fontName
		self.fontSize.value = fontSize
		self.fontStyle = fontStyle
		self.color = color
		self.textAlignment.value = textAlignment
		self.spacing.value = spacing
	}
	
	convenience init(_ toolID: String, _ kind: String, _ fontName: String, _ fontSize: Double, _ fontStyle: String, textAlignment: Double, _ spacing: Double, _ color: IconColorDec) {
		self.init()
		self.toolID = toolID
		self.kind = kind
		self.fontName = fontName
		self.fontSize.value = fontSize
		self.fontStyle = fontStyle
		self.color = IconColor(from: color)
		self.textAlignment.value = textAlignment
		self.spacing.value = spacing
	}
	
	convenience init(_ kind: String, _ fontName: String, _ fontSize: Double, _ fontStyle: String, textAlignment: Double, _ spacing: Double, _ color: IconColor) {
		self.init()
		self.toolID = generateID()
		self.kind = kind
		self.fontName = fontName
		self.fontSize.value = fontSize
		self.fontStyle = fontStyle
		self.color = color
		self.textAlignment.value = textAlignment
		self.spacing.value = spacing
	}
	
	convenience init(_ kind: String, _ fontName: String, _ fontSize: Double, _ fontStyle: String, textAlignment: Double, _ spacing: Double, _ color: IconColorDec) {
		self.init()
		self.toolID = generateID()
		self.kind = kind
		self.fontName = fontName
		self.fontSize.value = fontSize
		self.fontStyle = fontStyle
		self.color = IconColor(from: color)
		self.textAlignment.value = textAlignment
		self.spacing.value = spacing
	}
	
	convenience init(_ decodedTextTool: TextToolDec) {
		self.init()
		self.toolID = decodedTextTool.toolID
		self.kind = decodedTextTool.kind
		self.fontName = decodedTextTool.fontName
		self.fontSize.value = decodedTextTool.fontSize
		self.fontStyle = decodedTextTool.fontStyle
		self.color = IconColor(from: decodedTextTool.color!)
		self.textAlignment.value = decodedTextTool.textAlignment
		self.spacing.value = decodedTextTool.spacing
	}
	
	static func != (_ lhs: TextTool, _ rhs: TextToolDec) -> Bool{
		if lhs.toolID != rhs.toolID || lhs.kind != rhs.kind || lhs.fontName != rhs.fontName || lhs.fontSize.value != rhs.fontSize || lhs.fontStyle != rhs.fontStyle || lhs.textAlignment.value != rhs.textAlignment || lhs.spacing.value != rhs.spacing || !IconColor.equals(lhs.color, rhs.color){
			return false
		}
		
		return true
	}
}

class ImageTool: EditorTool{
//	@objc dynamic var toolID: String?
	@objc dynamic var wrapping: String?
	var colorParameters = RealmSwift.List<ListWrapperForDouble>()
	
	convenience init(_ toolID: String, _ wrapping: String, _ colorParameters: RealmSwift.List<ListWrapperForDouble>) {
		self.init()
		self.toolID = toolID
		self.wrapping = wrapping
		self.colorParameters = colorParameters
	}
	
	convenience init(_ toolID: String, _ wrapping: String, _ colorParameters: [Double]) {
		self.init()
		self.toolID = toolID
		self.wrapping = wrapping
		for value in colorParameters{
			self.colorParameters.append(ListWrapperForDouble(value))
		}
	}
	
	convenience init(_ wrapping: String, _ colorParameters: RealmSwift.List<ListWrapperForDouble>) {
		self.init()
		self.toolID = generateID()
		self.wrapping = wrapping
		self.colorParameters = colorParameters
	}
	
	convenience init(_ wrapping: String, _ colorParameters: [Double]) {
		self.init()
		self.toolID = generateID()
		self.wrapping = wrapping
		for value in colorParameters{
			self.colorParameters.append(ListWrapperForDouble(value))
		}
	}
	
	convenience init(_ decodedImageTool: ImageToolDec) {
		self.init()
		self.toolID = decodedImageTool.toolID
		self.wrapping = decodedImageTool.wrapping
		for value in decodedImageTool.colorParameters ?? []{
			self.colorParameters.append(ListWrapperForDouble(value))
		}
	}
	
	static func != (_ lhs: ImageTool, _ rhs: ImageToolDec) -> Bool{
		if lhs.toolID != rhs.toolID || lhs.wrapping != rhs.wrapping || lhs.colorParameters.count != rhs.colorParameters?.count{
			return false
		}
		
		for index in 0..<(lhs.colorParameters.count){
			if lhs.colorParameters[index].value.value != rhs.colorParameters![index]{
				return false
			}
		}
		
		return true
	}
}

class StaticTool: EditorTool{
//	@objc dynamic var toolID: String?
	@objc dynamic var kind: String?
	
	convenience init(_ toolID: String, _ kind: String) {
		self.init()
		self.toolID = toolID
		self.kind = kind
	}
	
	convenience init(_ kind: String) {
		self.init()
		self.toolID = generateID()
		self.kind = kind
	}
	
	convenience init(_ decodedStaticTool: StaticToolDec) {
		self.init()
		self.toolID = decodedStaticTool.toolID
		self.kind = decodedStaticTool.kind
	}
	
	static func != (_ lhs: StaticTool, _ rhs: StaticToolDec) -> Bool{
		if lhs.toolID != rhs.toolID || lhs.kind != rhs.kind{
			return false
		}
		return true
	}
}
