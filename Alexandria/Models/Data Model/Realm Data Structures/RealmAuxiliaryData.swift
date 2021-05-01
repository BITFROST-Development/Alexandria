//
//  RealmAuxiliaryData.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/4/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class IconColor: Object{
    var red = RealmOptional<Double>()
    var green = RealmOptional<Double>()
    var blue = RealmOptional<Double>()
    @objc dynamic var colorName: String?
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, name: String) {
        self.init()
        self.red.value = Double(red)
        self.green.value = Double(green)
        self.blue.value = Double(blue)
        self.colorName = name
    }
    
    convenience init(from cloud: IconColorDec) {
        self.init()
        self.red.value = cloud.red
        self.green.value = cloud.green
        self.blue.value = cloud.blue
        self.colorName = cloud.colorName
    }
    
	func getColor() -> UIColor{
		return UIColor(cgColor: CGColor(red: CGFloat(red.value ?? 0), green: CGFloat(green.value ?? 0), blue: CGFloat(blue.value ?? 0), alpha: 1))
	}
	
    static func != (_ lhs: IconColor, _ rhs: IconColor) -> Bool {
        if lhs.red.value != rhs.red.value || lhs.green.value != rhs.green.value || lhs.blue.value != rhs.blue.value || lhs.colorName != rhs.colorName{
            return false
        }
        return true
    }
    
    static func equals (_ lhs: IconColor?, _ rhs: IconColorDec?) -> Bool{
        if lhs?.red.value != rhs?.red || lhs?.green.value != rhs?.green || lhs?.blue.value != rhs?.blue || lhs?.colorName != rhs?.colorName{
            return false
        }
        return true
    }
    
    static func ^ (_ lhs: IconColor, _ rhs: IconColorDec) {
        lhs.red.value = rhs.red
        lhs.green.value = rhs.green
        lhs.blue.value = rhs.blue
        lhs.colorName = rhs.colorName
    }
}

class StoredFile: Object{
    
    @objc dynamic var name: String?
    @objc dynamic var data: Data?
    @objc dynamic var contentType: String?
    
    func initialize (_ label: String,_ file: Data,_ type: String) {
        name = label
        data = file
        contentType = type
    }
    
    convenience init(_ decodedFile: StoredFileDec?){
        self.init()
        if decodedFile != nil {
            self.name = decodedFile?.name
            self.contentType = decodedFile?.contentType
            self.data = Data(bytes: decodedFile!.data?.data ?? [], count: decodedFile!.data?.data?.count ?? 0)
        }
    }
    
    static func equals (lhs: StoredFile, rhs: StoredFileDec) -> Bool{
        if lhs.name != rhs.name || lhs.data != Data(bytes: rhs.data?.data ?? [], count: rhs.data?.data?.count ?? 0) || lhs.contentType != rhs.contentType {
            return false
        }
        
        return true
    }
    
    static func equals (lhs: StoredFile, rhs: StoredFile) -> Bool {
        if lhs.name != rhs.name || lhs.data != rhs.data || lhs.contentType != rhs.contentType {
            return false
        }
        
        return true
    }
    
    static func ^ (lhs: StoredFile, rhs: StoredFileDec){
        lhs.name = rhs.name
        lhs.data = Data(bytes: rhs.data?.data ?? [], count: rhs.data?.data?.count ?? 0)
        lhs.contentType = rhs.contentType
    }
}


class ItemIDWrapper: Object{
    @objc dynamic var value: String?
    
    convenience init(_ id: String?) {
        self.init()
        value = id
    }
}

class ListWrapperForDouble: Object{
    var value = RealmOptional<Double>()
    convenience init(_ doubleValue: Double) {
        self.init()
        value.value = doubleValue
    }
}

class ListWrapperForString: Object{
    @objc dynamic var value: String?
    
    convenience init(_ stringVal: String?) {
        self.init()
        value = stringVal
    }
}

class GiganticData: Object{
    @objc dynamic var avatar: StoredFile?
}
