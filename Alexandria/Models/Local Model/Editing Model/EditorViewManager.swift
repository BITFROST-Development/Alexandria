//
//  EditorViewManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 10/13/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit

extension EditorView{
    private func getFloatingPoint(_ binaryString: String) -> CGFloat{
        var finalNumber: CGFloat = 0
        var positive = true
        var exponentString = ""
        var exponent: CGFloat = 0
        var mantisaString = ""
        var index = 0
        for digit in binaryString{
            if index == 0{
                if Int(String(digit)) == 0{
                    positive = true
                } else {
                    positive = false
                }
            } else if index < 10{
                exponentString = exponentString + String(digit)
                if index == 9{
                    exponent = getFloat(exponentString)
                }
            } else {
                mantisaString += mantisaString + String(digit)
            }
            
            index += 1
        }
        mantisaString = "1.\(mantisaString)"
        let mantissa = CGFloat(Float(mantisaString)!)
        let value = mantissa * (pow(2, exponent - 127))
        if positive{
            finalNumber = value
        } else {
            finalNumber = 0 - value
        }
        return finalNumber
    }
    
    private func getFloat(_ binaryString: String) -> CGFloat{
        var finalNumber: CGFloat = 0
        var index = 1
        for digit in binaryString{
            finalNumber += CGFloat(Float(String(digit))!) * pow(2, CGFloat(binaryString.count - index))
            index += 1
        }
        return finalNumber
    }
    
    private func getBinary(_ character: Character) -> String{
        var binary = ""
        switch character {
        case "0":
            binary = "0000"
        case "1":
            binary = "0001"
        case "2":
            binary = "0010"
        case "3":
            binary = "0011"
        case "4":
            binary = "0100"
        case "5":
            binary = "0101"
        case "6":
            binary = "0110"
        case "7":
            binary = "0111"
        case "8":
            binary = "1000"
        case "9":
            binary = "1001"
        case "A":
            binary = "1010"
        case "B":
            binary = "1011"
        case "C":
            binary = "1100"
        case "D":
            binary = "1101"
        case "E":
            binary = "1110"
        case "F":
            binary = "1111"
        default:
            print("error")
        }
        return binary
    }
    
//    private func getPageIndex(_ annotationKind: String, pageIndex: Int) -> Int?{
//        switch annotationKind {
//        case "layer":
//            var checkingPageIndex = 0
//            repeat{
//                if editableUserData.layerData[checkingPageIndex].components(separatedBy: "/").count > 1 {
//                    if Int(editableUserData.layerData[checkingPageIndex].components(separatedBy: "/")[2]) == pageIndex{
//                        return checkingPageIndex
//                    } else if checkingPageIndex < editableUserData.layerData.count{
//                        let newPageCheckingIndex = checkingPageIndex + Int(editableUserData.layerData[checkingPageIndex].components(separatedBy: "/")[5])!
//                        if newPageCheckingIndex < editableUserData.layerData.count{
//                            checkingPageIndex = newPageCheckingIndex
//                        } else {
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                }
//            } while editableUserData.layerData[checkingPageIndex].components(separatedBy: "/").count > 1  && Int(editableUserData.layerData[checkingPageIndex].components(separatedBy: "/")[2]) != pageIndex
//        case "ink":
//            var checkingPageIndex = 0
//            repeat{
//                if editableUserData.inkData[checkingPageIndex].components(separatedBy: "/").count > 1{
//                    if Int(editableUserData.inkData[checkingPageIndex].components(separatedBy: "/")[2]) == pageIndex{
//                        return checkingPageIndex
//                    } else if checkingPageIndex < editableUserData.inkData.count{
//                        let newPageCheckingIndex = checkingPageIndex + Int(editableUserData.inkData[checkingPageIndex].components(separatedBy: "/")[5])!
//                        if newPageCheckingIndex < editableUserData.inkData.count{
//                            checkingPageIndex = newPageCheckingIndex
//                        } else {
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                }
//            } while editableUserData.inkData[checkingPageIndex].components(separatedBy: "/").count > 1 && Int(editableUserData.inkData[checkingPageIndex].components(separatedBy: "/")[2]) != pageIndex
//        case "img":
//            var checkingPageIndex = 0
//            repeat{
//                if editableUserData.imgData[checkingPageIndex].components(separatedBy: "/").count > 1{
//                    if Int(editableUserData.imgData[checkingPageIndex].components(separatedBy: "/")[2]) == pageIndex{
//                        return checkingPageIndex
//                    } else if checkingPageIndex < editableUserData.imgData.count{
//                        let newPageCheckingIndex = checkingPageIndex + Int(editableUserData.imgData[checkingPageIndex].components(separatedBy: "/")[5])!
//                        if newPageCheckingIndex < editableUserData.imgData.count{
//                            checkingPageIndex = newPageCheckingIndex
//                        } else {
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                }
//            } while editableUserData.imgData[checkingPageIndex].components(separatedBy: "/").count > 1 && Int(editableUserData.imgData[checkingPageIndex].components(separatedBy: "/")[2]) != pageIndex
//        case "link":
//            var checkingPageIndex = 0
//            repeat{
//                if editableUserData.linkData[checkingPageIndex].components(separatedBy: "/").count > 1{
//                    if Int(editableUserData.linkData[checkingPageIndex].components(separatedBy: "/")[2]) == pageIndex{
//                        return checkingPageIndex
//                    } else if checkingPageIndex < editableUserData.linkData.count{
//                        let newPageCheckingIndex = checkingPageIndex + Int(editableUserData.linkData[checkingPageIndex].components(separatedBy: "/")[5])!
//                        if newPageCheckingIndex < editableUserData.linkData.count{
//                            checkingPageIndex = newPageCheckingIndex
//                        } else {
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                }
//            } while editableUserData.linkData[checkingPageIndex].components(separatedBy: "/").count > 1 && Int(editableUserData.linkData[checkingPageIndex].components(separatedBy: "/")[2]) != pageIndex
//        case "text":
//            var checkingPageIndex = 0
//            repeat{
//                if editableUserData.textData[checkingPageIndex].components(separatedBy: "/").count > 1{
//                    if Int(editableUserData.textData[checkingPageIndex].components(separatedBy: "/")[2]) == pageIndex{
//                        return checkingPageIndex
//                    } else if checkingPageIndex < editableUserData.textData.count{
//                        let newPageCheckingIndex = checkingPageIndex + Int(editableUserData.textData[checkingPageIndex].components(separatedBy: "/")[5])!
//                        if newPageCheckingIndex < editableUserData.textData.count{
//                            checkingPageIndex = newPageCheckingIndex
//                        } else {
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                }
//            } while editableUserData.textData[checkingPageIndex].components(separatedBy: "/").count > 1 && Int(editableUserData.textData[checkingPageIndex].components(separatedBy: "/")[2]) != pageIndex
//        default:
//            print("error")
//            return nil
//        }
//        return nil
//    }
//    
//    func fetchPageInkData (_ page: PDFPage){
//        var paths = [UIBezierPath]()
//        var colors = [UIColor]()
//        var ids = [String]()
//        let pageIndex = getPageIndex("ink", pageIndex: document?.index(for: page) ?? 0)
//        if pageIndex ?? editableUserData.inkData.count < editableUserData.inkData.count{
//            let pageInkHeader = editableUserData.inkData[pageIndex!].components(separatedBy: "/")
//            let pageInkComponentCount = Int(pageInkHeader[4])!
//            for index in 0..<pageInkComponentCount{
//                let currentPathData = editableUserData.inkData[pageIndex! + (index * 3) + 2].components(separatedBy: " ")
//                let currentPathHeader = editableUserData.inkData[pageIndex! + (index * 3) + 1].components(separatedBy: "/")
//                
//                let path = UIBezierPath()
//                let colorHex = currentPathData[4]
//                var red: CGFloat = 0
//                var green: CGFloat = 0
//                var blue: CGFloat = 0
//                var alpha: CGFloat = 0
//                var lineWidth: CGFloat = 0
//                var startingPoint: CGPoint!
//                var endingPoint: CGPoint!
//                var characterIndex = 0
//                var binaryString = ""
//                for character in colorHex{
//                    if characterIndex % 2 == 0{
//                        binaryString = binaryString + getBinary(character)
//                    } else {
//                        binaryString = binaryString + getBinary(character)
//                        switch characterIndex {
//                        case 1:
//                            red = getFloat(binaryString) / 255
//                        case 3:
//                            green = getFloat(binaryString) / 255
//                        case 5:
//                            blue = getFloat(binaryString) / 255
//                        case 7:
//                            alpha = getFloat(binaryString) / 255
//                        default:
//                            print("error")
//                        }
//                        binaryString = ""
//                    }
//                    characterIndex += 1
//                }
//                let currentColor = UIColor(cgColor: CGColor(srgbRed: red, green: green, blue: blue, alpha: alpha))
//                
//                for character in currentPathData[4]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                lineWidth = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentPathData[0]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let startx = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for charater in currentPathData[1]{
//                    binaryString = binaryString + getBinary(charater)
//                }
//                let starty = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentPathData[2] {
//                    binaryString = binaryString + getBinary(character)
//                }
//                let endx = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentPathData[3]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let endy = getFloatingPoint(binaryString)
//                
//                startingPoint = CGPoint(x: startx, y: starty)
//                endingPoint = CGPoint(x: endx, y: endy)
//                path.lineWidth = lineWidth
//                path.lineCapStyle = .round
//                path.lineJoinStyle = .round
//                path.move(to: startingPoint)
//                path.addLine(to: endingPoint)
//                paths.append(path)
//                colors.append(currentColor)
//                ids.append(currentPathHeader[3])
//            }
//            currentPageInkData = InkData(paths, colors, ids)
//        } else {
//            currentPageInkData = InkData([], [], [])
//        }
//    }
//    
//    func fetchImagedData(_ page: PDFPage){
//        let pageIndex = getPageIndex("img", pageIndex: document?.index(for: page) ?? 0)
//        if pageIndex ?? editableUserData.imgData.count < editableUserData.imgData.count{
//            let pageImageHeader = editableUserData.imgData[pageIndex!].components(separatedBy: "/")
//            let imageCount = Int(pageImageHeader[4])!
//            var imageDataArray: [Data] = []
//            var imageDrawingArray: [CGRect] = []
//            for index in 0..<imageCount{
//                let currentImageDataString = editableUserData.imgData[pageIndex! + (index * 8) + 6]
//                imageDataArray.append(Data(base64Encoded: currentImageDataString)!)
//                
//                let currentImageDrawingString = editableUserData.imgData[pageIndex! + (index * 8) + 3].components(separatedBy: " ")
//                
//                var binaryString = ""
//                
//                for character in currentImageDrawingString[0]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let xorigin = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentImageDrawingString[1]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let yorigin = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentImageDrawingString[2]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let width = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in currentImageDrawingString[3]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let height = getFloatingPoint(binaryString)
//                
//                imageDrawingArray.append(CGRect(x: xorigin, y: yorigin, width: width, height: height))
//            }
//            
//            currentPageImageData = ImageData(imageDataArray, imageDrawingArray)
//        } else {
//            currentPageImageData = ImageData([], [])
//        }
//    }
//    
//    func fetchLinkData(_ page: PDFPage){
//        let pageIndex = getPageIndex("link", pageIndex: document?.index(for: page) ?? 0)
//        if pageIndex ?? editableUserData.linkData.count < editableUserData.linkData.count{
//            var currentPageLinkObjects = [LinkObject]()
//            var currentPageLinkIds = [String]()
//            var currentPageLinkPositions = [CGRect]()
//            let linkHeader = editableUserData.linkData[pageIndex!].components(separatedBy: "/")
//            let linkCount = Int(linkHeader[4])!
//            var nextLink = 0
//            for _ in 0..<linkCount{
//                var currentPageLinkPaths = [String]()
//                var currentPageLinkPages = [Int]()
//                currentPageLinkPaths.append("root")
//                currentPageLinkPages.append(document!.index(for: page))
//                let rootDrawingData = editableUserData.linkData[pageIndex! + nextLink + 3].components(separatedBy: " ")
//                
//                var rootBinaryString = ""
//                
//                for character in rootDrawingData[0]{
//                    rootBinaryString = rootBinaryString + getBinary(character)
//                }
//                let xorigin = getFloatingPoint(rootBinaryString)
//                rootBinaryString = ""
//                
//                for character in rootDrawingData[1]{
//                    rootBinaryString = rootBinaryString + getBinary(character)
//                }
//                let yorigin = getFloatingPoint(rootBinaryString)
//                rootBinaryString = ""
//                
//                for character in rootDrawingData[2]{
//                    rootBinaryString = rootBinaryString + getBinary(character)
//                }
//                let width = getFloatingPoint(rootBinaryString)
//                rootBinaryString = ""
//                
//                for character in rootDrawingData[3]{
//                    rootBinaryString = rootBinaryString + getBinary(character)
//                }
//                let height = getFloatingPoint(rootBinaryString)
//                
//                currentPageLinkPositions.append(CGRect(x: xorigin, y: yorigin, width: width, height: height))
//                
//                let currentLinkHeader = editableUserData.linkData[pageIndex! + nextLink + 1].components(separatedBy: "/")
//                
//                currentPageLinkIds.append(currentLinkHeader[4])
//                
//                let externalLinksCount = Int(currentLinkHeader[3])!
//                
//                for index in 0..<externalLinksCount{
//                    let currentExternalLinkPath = editableUserData.linkData[pageIndex! + nextLink + (index * 4) + 6]
//                    let currentExternalLinkPage = editableUserData.linkData[pageIndex! + nextLink + (index * 4) + 7]
//                    currentPageLinkPaths.append(currentExternalLinkPath)
//                    currentPageLinkPages.append(Int(currentExternalLinkPage)!)
//                }
//                
//                currentPageLinkObjects.append(LinkObject(currentPageLinkPaths, currentPageLinkPages))
//                
//                nextLink = nextLink + Int(currentLinkHeader[3])!
//            }
//        } else {
//            currentPageLinkData = LinkData([], [], [])
//        }
//    }
//    
//    func fetchTextData(_ page: PDFPage){
//        let pageIndex = getPageIndex("text", pageIndex: document?.index(for: page) ?? 0)
//        if pageIndex ?? editableUserData.textData.count < editableUserData.textData.count{
//            var currentPageTextContents = [String]()
//            var currentPageTextFonts = [String]()
//            var currentPageTextFontStyles = [String]()
//            var currentPageTextFontSizes = [Int]()
//            var currentPageTextColors = [UIColor]()
//            var currentPageTextPositions = [CGRect]()
//            let textCount = Int(editableUserData.textData[pageIndex!].components(separatedBy: "/")[4])!
//            for index in 0..<textCount{
//                currentPageTextContents.append(editableUserData.textData[pageIndex! + (8 * index) + 2])
//                currentPageTextFonts.append(editableUserData.textData[pageIndex! + (8 * index) + 3])
//                currentPageTextFontStyles.append(editableUserData.textData[pageIndex! + (8 * index) + 4])
//                currentPageTextFontSizes.append(Int(editableUserData.textData[pageIndex! + (8 * index) + 5])!)
//                let colorHex = editableUserData.textData[pageIndex! + (8 * index) + 6]
//                var binaryString = ""
//                var characterIndex = 0
//                var red: CGFloat!
//                var green: CGFloat!
//                var blue: CGFloat!
//                var alpha: CGFloat!
//                for character in colorHex{
//                    if characterIndex % 2 == 0{
//                        binaryString = binaryString + getBinary(character)
//                    } else{
//                        binaryString = binaryString + getBinary(character)
//                        if characterIndex == 1{
//                            red = getFloat(binaryString) / 255
//                            binaryString = ""
//                        } else if characterIndex == 3{
//                            green = getFloat(binaryString) / 255
//                            binaryString = ""
//                        } else if characterIndex == 5{
//                            blue = getFloat(binaryString) / 255
//                            binaryString = ""
//                        } else if characterIndex == 7{
//                            alpha = getFloat(binaryString) / 100
//                            binaryString = ""
//                        }
//                    }
//                    characterIndex += 1
//                }
//                characterIndex = 0
//                currentPageTextColors.append(UIColor(cgColor: CGColor(srgbRed: red, green: green, blue: blue, alpha: alpha)))
//                
//                let coordinates = editableUserData.textData[pageIndex! + (8 * index) + 7].components(separatedBy: " ")
//                
//                for character in coordinates[0]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let xorigin = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in coordinates[1]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let yorigin = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in coordinates[2]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let width = getFloatingPoint(binaryString)
//                binaryString = ""
//                
//                for character in coordinates[3]{
//                    binaryString = binaryString + getBinary(character)
//                }
//                let height = getFloatingPoint(binaryString)
//                
//                currentPageTextPositions.append(CGRect(x: xorigin, y: yorigin, width: width, height: height))
//            }
//            currentPageTextData = TextData(currentPageTextContents, currentPageTextFonts, currentPageTextFontStyles, currentPageTextFontSizes, currentPageTextColors, currentPageTextPositions)
//        } else {
//            currentPageTextData = TextData([], [], [], [], [], [])
//        }
//    }
//    
//    func fetchLayerData(_ page: PDFPage) {
//        var layerArray = [LayerObject]()
//        let pageIndex = getPageIndex("layer", pageIndex: document?.index(for: page) ?? 0)
//        if pageIndex ?? editableUserData.layerData.count < editableUserData.layerData.count{
//            let layerCount = Int(editableUserData.layerData[pageIndex!].components(separatedBy: "/")[4])!
//            
//            for index in 0..<layerCount{
//                let currentLayerIndex = index + 1
//                let layerString = editableUserData.layerData[pageIndex! + currentLayerIndex + 1].components(separatedBy: "/")
//                let newLayerObject = LayerObject(layerString[2], Int(layerString[3])!)
//                layerArray.append(newLayerObject)
//            }
//            
//            currentPageLayerData = LayerData(layerArray)
//        } else {
//            currentPageLayerData = LayerData(layerArray)
//        }
//    }
//    
//    func writeInkUpdates(_ startingPoint: CGPoint, _ endPoint: CGPoint, _ lineWidth: CGFloat, _ color: UIColor, with id: String, _ page: PDFPage){
//        DispatchQueue.global(qos: .background).sync { [self] in
//            var pageIndex = getPageIndex("layer", pageIndex: document?.index(for: page) ?? 0)
//            if pageIndex ?? editableUserData.layerData.count < editableUserData.layerData.count{
//                let pageLayerCount = pageIndex! + Int(editableUserData.layerData[pageIndex!].components(separatedBy: "/")[4])! + 1
//                let layerPageIndex = pageIndex!
//                pageIndex = getPageIndex("ink", pageIndex: document?.index(for: page) ?? 0)
//                if pageIndex != nil{
//                    let pageInkCount = Int(editableUserData.inkData[pageIndex!].components(separatedBy: "/")[4])!
//                    let inkInserIndex = pageIndex! + (pageInkCount * 3) + 1
//                    let layerPageHeader = editableUserData.layerData[layerPageIndex].components(separatedBy: "/")
//                    let inkPageHeader = editableUserData.inkData[pageIndex!].components(separatedBy: "/")
//                    editableUserData.layerData[layerPageIndex] = "/page/\(layerPageHeader[2])/begin/\(Int(layerPageHeader[4])! + 1)/\(Int(layerPageHeader[5])! + 1)/"
//                    editableUserData.inkData[pageIndex!] = "/page/\(inkPageHeader[2])/begin/\(Int(inkPageHeader[4])! + 1)/\(Int(inkPageHeader[5])! + 1)/"
//                    editableUserData.layerData.insert("/layer/ink/\(pageInkCount)/", at: pageLayerCount + 1)
//                    editableUserData.inkData.insert("/path/begin/\(id)/", at: inkInserIndex)
//                    editableUserData.inkData.insert("\(pathToHex(startingPoint, endPoint, lineWidth, color))", at: inkInserIndex + 1)
//                    editableUserData.inkData.insert("/path/end/", at: inkInserIndex + 2)
//                } else {
//                    while pageIndex ?? editableUserData.inkData.count >= editableUserData.inkData.count - 2 {
//                        if editableUserData.inkData.count > 1{
//                            let lastAvailableInkPage = Int(editableUserData.inkData[editableUserData.inkData.count - 1].components(separatedBy: "/")[2])!
//                            editableUserData.inkData.append("/page/\(lastAvailableInkPage + 1)/begin/0/2/")
//                            editableUserData.inkData.append("/page/\(lastAvailableInkPage + 1)/end/")
//                        } else {
//                            editableUserData.inkData[0] = "/page/0/begin/0/2"
//                            editableUserData.inkData.append("/page/0/end")
//                        }
//                        if pageIndex == nil{
//                            pageIndex = getPageIndex("ink", pageIndex: document?.index(for: page) ?? 0)
//                        }
//                    }
//                    let pageIndexInDoc = document!.index(for: page)
//                    editableUserData.inkData.append("/page/\(Int(editableUserData.inkData[editableUserData.inkData.count - 1].components(separatedBy: "/")[2])! + 1)/begin/1/5")
//                    editableUserData.inkData.append("/path/begin/\(id)")
//                    editableUserData.inkData.append("\(pathToHex(startingPoint, endPoint, lineWidth, color))")
//                    editableUserData.inkData.append("/path/end/")
//                    editableUserData.inkData.append("/page/\(pageIndexInDoc)/end")
//                }
//                
//            } else {
//                
//                while pageIndex ?? editableUserData.layerData.count >= editableUserData.layerData.count - 2{
//                    if editableUserData.layerData.count > 1{
//                        let lastAvailableLayerPage = Int(editableUserData.layerData[editableUserData.layerData.count - 1].components(separatedBy: "/")[2])!
//                        editableUserData.layerData.append("/page/\(lastAvailableLayerPage + 1)/begin/0/2/")
//                        editableUserData.layerData.append("/page/\(lastAvailableLayerPage + 1)/end/")
//                    } else {
//                        editableUserData.layerData[0] = "/page/0/begin/0/2/"
//                        editableUserData.layerData.append("/page/0/end/")
//                    }
//                    pageIndex = getPageIndex("layer", pageIndex: document?.index(for: page) ?? 0)
//                }
//                
//                pageIndex = getPageIndex("ink", pageIndex: document?.index(for: page) ?? 0)
//                while pageIndex ?? editableUserData.inkData.count >= editableUserData.inkData.count - 2 {
//                    if editableUserData.inkData.count > 1{
//                        let lastAvailableInkPage = Int(editableUserData.inkData[editableUserData.inkData.count - 1].components(separatedBy: "/")[2])!
//                        editableUserData.inkData.append("/page/\(lastAvailableInkPage + 1)/begin/0/2/")
//                        editableUserData.inkData.append("/page/\(lastAvailableInkPage + 1)/end/")
//                    } else {
//                        editableUserData.inkData[0] = "/page/0/begin/0/2"
//                        editableUserData.inkData.append("/page/0/end")
//                    }
//                    if pageIndex == nil{
//                        pageIndex = getPageIndex("ink", pageIndex: document?.index(for: page) ?? 0)
//                    }
//                }
//                
//                let pageIndexInDoc = Int(editableUserData.layerData[editableUserData.layerData.count - 1].components(separatedBy: "/")[2])! + 1
//                editableUserData.layerData.append("/page/\(pageIndexInDoc)/begin/1/3")
//                editableUserData.layerData.append("/layer/ink/0/")
//                editableUserData.layerData.append("/page/\(pageIndexInDoc)/end/")
//                editableUserData.inkData.append("/page/\(Int(editableUserData.inkData[editableUserData.inkData.count - 1].components(separatedBy: "/")[2])! + 1)/begin/1/5")
//                editableUserData.inkData.append("/path/begin/\(id)")
//                editableUserData.inkData.append("\(pathToHex(startingPoint, endPoint, lineWidth, color))")
//                editableUserData.inkData.append("/path/end/")
//                editableUserData.inkData.append("/page/\(pageIndexInDoc)/end")
//            }
//        }
//        
//    }
    
    private func pathToHex(_ startingPoint: CGPoint, _ endPoint: CGPoint, _ lineWidth: CGFloat, _ color: UIColor) -> String{
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return "\(getHex(startingPoint.x)) \(getHex(startingPoint.y)) \(getHex(endPoint.x)) \(getHex(endPoint.y)) \(getHex(lineWidth)) \(getColorHex(red, green, blue, (alpha * 255).rounded(.down)))"
    }
    
    private func getColorHex(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> String{
        var finalString = ""
        for index in 0..<4{
            var value = 0
            if index == 0{
                value = Int(red)
            } else if index == 1{
                value = Int(green)
            } else if index == 2{
                value = Int(blue)
            } else if index == 3{
                value = Int(alpha)
            }
            var binaryString = ""
            while value != 0 {
                if value % 2 == 0{
                    binaryString = binaryString + "0"
                } else {
                    binaryString = binaryString + "1"
                }
                value /= 2
            }
            finalString = finalString + binaryToHex(binaryString)
        }
        return finalString
    }
    
    private func getHex(_ float: CGFloat) -> String{
        var finalString = ""
        var preDecimal = float
        preDecimal.round(.down)
        var postDecimal = float - preDecimal
        var preDecimalString = ""
        var preDecimalInt = Int(preDecimal)
        while preDecimalInt != 0{
            if preDecimalInt % 2 != 0{
                preDecimalString = preDecimalString + "1"
            } else {
                preDecimalString = preDecimalString + "0"
            }
            preDecimalInt /= 2
        }
        var postDecimalString = ""
        while postDecimal != 0 && postDecimalString.count < 23 {
            postDecimal *= 2
            if postDecimal > 1{
                postDecimalString = postDecimalString + "1"
                postDecimal -= 1
            } else {
                postDecimalString = postDecimalString + "0"
            }
        }
        postDecimalString = postDecimalString + "0"
        var mantissa = ""
        var index = preDecimalString.firstIndex(of: "1")
        var exponentShift = 0
        if index != nil {
            if preDecimalString.endIndex == index{
                mantissa = postDecimalString
            } else {
                mantissa = preDecimalString[preDecimalString.index(after: index!)..<preDecimalString.endIndex] + postDecimalString
            }
            
            var finalMantissa = ""
            var charIndex = 0
            for character in mantissa{
                if charIndex < 23{
                    finalMantissa = finalMantissa + String(character)
                    charIndex += 1
                } else {
                    break
                }
            }
            if finalMantissa.count < 23{
                for _ in finalMantissa.count..<23{
                    finalMantissa = finalMantissa + "0"
                }
            }
            mantissa = finalMantissa
            exponentShift = preDecimalString.distance(from: preDecimalString.index(after: index!), to: preDecimalString.endIndex)
        } else {
            index = postDecimalString.firstIndex(of: "1")
            if index != nil {
                exponentShift = 0 - postDecimalString.distance(from: postDecimalString.index(after: index!), to: postDecimalString.endIndex)
                mantissa = String(postDecimalString[postDecimalString.index(after: index!)..<postDecimalString.endIndex])
                var finalMantissa = ""
                var charIndex = 0
                for character in mantissa{
                    if charIndex < 23{
                        finalMantissa = finalMantissa + String(character)
                        charIndex += 1
                    } else {
                        break
                    }
                }
                if finalMantissa.count < 23{
                    for _ in finalMantissa.count..<23{
                        finalMantissa = finalMantissa + "0"
                    }
                }
                mantissa = finalMantissa
            } else {
                mantissa = "00000000000000000000000"
                exponentShift = 0 - 127
            }
        }
        var exponentValue = exponentShift + 127
        var exponentBinary = ""
        while exponentValue != 0{
            if exponentValue % 2 != 0{
                exponentBinary = exponentBinary + "1"
            } else {
                exponentBinary = exponentBinary + "0"
            }
            exponentValue /= 2
        }
        if exponentBinary.firstIndex(of: "1") != nil {
            exponentBinary = String(exponentBinary[exponentBinary.firstIndex(of: "1")!..<exponentBinary.endIndex])
            var frontPadding = ""
            for _ in exponentBinary.count..<8{
                frontPadding = frontPadding + "0"
            }
            exponentBinary = frontPadding + exponentBinary
        } else {
            exponentBinary = "00000000"
        }
        var finalBinary = ""
        if float < 0{
            finalBinary = "1\(exponentBinary)\(mantissa)"
        } else {
            finalBinary = "0\(exponentBinary)\(mantissa)"
        }
        finalString = binaryToHex(finalBinary)
        return finalString
    }
    
    private func binaryToHex(_ binaryString: String) -> String{
        var hexSubcomponents: [String] = []
        var currentSubcomponent = ""
        var hexTranscoder = 0
        for character in binaryString{
            if hexTranscoder < 4{
                currentSubcomponent = currentSubcomponent + String(character)
                hexTranscoder += 1
            } else {
                hexTranscoder = 1
                hexSubcomponents.append(currentSubcomponent)
                currentSubcomponent = String(character)
            }
        }
        var finalHexString = ""
        for subcomponent in hexSubcomponents{
            switch subcomponent {
            case "0000":
                finalHexString = finalHexString + "0"
            case "0001":
                finalHexString = finalHexString + "1"
            case "0010":
                finalHexString = finalHexString + "2"
            case "0011":
                finalHexString = finalHexString + "3"
            case "0100":
                finalHexString = finalHexString + "4"
            case "0101":
                finalHexString = finalHexString + "5"
            case "0110":
                finalHexString = finalHexString + "6"
            case "0111":
                finalHexString = finalHexString + "7"
            case "1000":
                finalHexString = finalHexString + "8"
            case "1001":
                finalHexString = finalHexString + "9"
            case "1010":
                finalHexString = finalHexString + "A"
            case "1011":
                finalHexString = finalHexString + "B"
            case "1100":
                finalHexString = finalHexString + "C"
            case "1101":
                finalHexString = finalHexString + "D"
            case "1110":
                finalHexString = finalHexString + "E"
            case "1111":
                finalHexString = finalHexString + "F"
            default:
                print("error")
            }
        }
        return finalHexString
    }
    
}
