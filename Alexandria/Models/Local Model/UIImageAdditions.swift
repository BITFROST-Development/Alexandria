//
//  UIImageAdditions.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/22/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

extension UIImage {
	func cropAlpha() -> UIImage {
			
		let cgImage = self.cgImage!;
		
		let width = cgImage.width
		let height = cgImage.height
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bytesPerPixel:Int = 4
		let bytesPerRow = bytesPerPixel * width
		let bitsPerComponent = 8
		let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
		
		guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
			let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
				return self
		}
		
		context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
		
		var minX = width
		var minY = height
		var maxX: Int = 0
		var maxY: Int = 0
		
		for x in 1 ..< width {
			for y in 1 ..< height {
				
				let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
				let a = CGFloat(ptr[i + 3]) / 255.0
				
				if(a>0) {
					if (x < minX) { minX = x };
					if (x > maxX) { maxX = x };
					if (y < minY) { minY = y};
					if (y > maxY) { maxY = y};
				}
			}
		}
		
		let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
		let imageScale:CGFloat = self.scale
		let croppedImage =  self.cgImage!.cropping(to: rect)!
		let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
		
		return ret;
	}
//	func trim() -> UIImage {
//		let newRect = self.cropRect
//		if let imageRef = self.cgImage!.cropping(to: newRect) {
//			return UIImage(cgImage: imageRef)
//		}
//		return self
//	}
//
//	var cropRect: CGRect {
//		func cropRect() -> CGRect {
//			let cgImage = self.cgImage!;
//
//			let width = cgImage.width
//			let height = cgImage.height
//
//			let colorSpace = CGColorSpaceCreateDeviceRGB()
//			let bytesPerPixel:Int = 4
//			let bytesPerRow = bytesPerPixel * width
//			let bitsPerComponent = 8
//			let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
//
//			guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
//				let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
//					return self
//			}
//
//			context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//			var minX = width
//			var minY = height
//			var maxX: Int = 0
//			var maxY: Int = 0
//
//			for x in 1 ..< width {
//				for y in 1 ..< height {
//
//					let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
//					let a = CGFloat(ptr[i + 3]) / 255.0
//
//					if(a>0) {
//						if (x < minX) { minX = x };
//						if (x > maxX) { maxX = x };
//						if (y < minY) { minY = y};
//						if (y > maxY) { maxY = y};
//					}
//				}
//			}
//
//			let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
//			let imageScale:CGFloat = self.scale
//			let croppedImage =  self.cgImage!.cropping(to: rect)!
//			let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
//
//			return ret;
//	}
//
//	func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {
//
//		let width = inImage.width
//		let height = inImage.height
//
//		let bitmapBytesPerRow = width * 4
//		let bitmapByteCount = bitmapBytesPerRow * height
//
//		let colorSpace = CGColorSpaceCreateDeviceRGB()
//
//		let bitmapData = malloc(bitmapByteCount)
//		if bitmapData == nil {
//			return nil
//		}
//
//		let context = CGContext (data: bitmapData,
//								 width: width,
//								 height: height,
//								 bitsPerComponent: 8,      // bits per component
//			bytesPerRow: bitmapBytesPerRow,
//			space: colorSpace,
//			bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
//
//		return context
//	}
}
