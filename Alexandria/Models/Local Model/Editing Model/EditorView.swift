//
//  NotebookView.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/28/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit

class EditorFileInfo: EditingFile {
	var controller: EditorView!
	var item: FileItem!
	var pageIDs: [String] = []
	var currentPage: Int {
		get{
			return getCurrentPage()
		} set (newPageNumber){
			setupCurrentPage(newPageNumber)
		}
	}
	var contentAddress: String!{
		get{
			return fileFolder
		} set (appendingString) {
			setupAddress(appendingString)
		}
	}
	private var fileFolder: String!
	var linkMode = false
	
	init(_ controller: EditorView, _ item: FileItem) {
		self.controller = controller
		self.item = item
		if let book = item as? Book{
			self.contentAddress = book.localAddress
			self.currentPage = Int(book.currentPage.value ?? 0)
		} else if let notebook = item as? Notebook{
			self.contentAddress = notebook.localAddress
			self.currentPage = Int(notebook.currentPage.value ?? 0)
		}
	}
	
	private func setupAddress(_ appendingString: String){
		fileFolder = appendingString + "/userData"
		let newValue = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(appendingString)
		do{
			let idData = try Data(contentsOf: newValue.appendingPathComponent("userData").appendingPathComponent("pages"))
			let ids: [String] = idData.withUnsafeBytes {
				return $0.split(separator: UInt8(ascii: "\n")).map { String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self) }
			}
			pageIDs = ids
		} catch let error{
			print(error.localizedDescription)
		}
	}
	
	private func getCurrentPage() -> Int{
		if let book = item as? Book{
			return Int(book.currentPage.value ?? 0)
		} else if let notebook = item as? Notebook{
			return Int(notebook.currentPage.value ?? 0)
		}
		return 0
	}
	
	private func setupCurrentPage(_ newPageNumber: Int){
		do{
			try AppDelegate.realm.write({
				if let book = item as? Book{
					book.currentPage.value = Double(newPageNumber)
				} else if let notebook = item as? Notebook{
					notebook.currentPage.value = Double(newPageNumber)
				}
			})
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
}

class EditorView: UIPageViewController{
	var controller: EditingViewController!
	var document: PDFDocument!
	var currentPage: Int {
		get{
			return pageTracker
		} set (newPage){
			pageTracker = newPage
			currentInfo.currentPage = pageTracker
		}
	}
	private var pageTracker: Int = 0
	var previousPageViewController: Int = 0
	var currentPageViewController: Int = 1
	var nextPageViewController: Int = 2
	var bufferViewController: EditorViewPageViewController? = nil
	var pageViewControllers: [EditorViewPageViewController?] = [nil, nil, nil]
	var annotationLayer: [String] = []
    var shouldGoForward = false
	var currentScale: CGFloat = 1
    var annotating = false
	var updating = false
	var currentInfo: EditorFileInfo!{
		get{
			return displayingInfo as? EditorFileInfo
		} set (newInfo){
			displayingInfo = newInfo
		}
	}
	private var displayingInfo: EditingFile!{
		get{
			return controller?.currentlyOpen ?? nil
		} set (newInfo){
			controller.currentlyOpen = newInfo
		}
	}
	
	func goToFirstPage(){
		goToPage(0, nil)
	}
	
	func goToLastPage(){
		goToPage(document.pageCount - 1, nil)
	}
	
	func goToPage(_ index: Int, _ forwards: Bool?){
		if currentPage < index{
			currentPage = index
			if pageViewControllers[nextPageViewController] == nil{
				pageViewControllers[nextPageViewController] = EditorViewPageViewController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage ) * 3) + 1], self)
			} else {
				pageViewControllers[nextPageViewController]?.loadController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage ) * 3) + 1])
			}
			if currentPage > 0{
				if pageViewControllers[previousPageViewController] == nil{
					pageViewControllers[previousPageViewController] = EditorViewPageViewController(document.page(at: currentPage - 1)!, currentPage - 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage - 1) * 3) + 1], self)
				} else {
					pageViewControllers[previousPageViewController]?.loadController(document.page(at: currentPage - 1)!, currentPage - 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage - 1) * 3) + 1])
				}
			}
			
			self.setViewControllers([pageViewControllers[nextPageViewController]!], direction: (forwards != nil) ? ((forwards!) ? .forward : .reverse) : .forward, animated: true, completion: {_ in
				self.currentPageViewController = self.nextPageViewController
				if self.currentPageViewController == 0{
					if self.previousPageViewController == 1{
						self.nextPageViewController = 2
					} else if self.previousPageViewController == 2{
						self.nextPageViewController = 1
					}
				} else if self.currentPageViewController == 1{
					if self.previousPageViewController == 0{
						self.nextPageViewController = 2
					} else if self.previousPageViewController == 2{
						self.nextPageViewController = 0
					}
				} else if self.currentPageViewController == 2{
					if self.previousPageViewController == 1{
						self.nextPageViewController = 0
					} else if self.previousPageViewController == 0{
						self.nextPageViewController = 1
					}
				}
				if self.currentPage < self.document.pageCount - 1{
					if self.pageViewControllers[self.nextPageViewController] == nil{
						self.pageViewControllers[self.nextPageViewController] = EditorViewPageViewController(self.document.page(at: self.currentPage + 1)!, self.currentPage + 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage + 1) * 3) + 1], self)
					} else {
						self.pageViewControllers[self.nextPageViewController]?.loadController(self.document.page(at: self.currentPage + 1)!, self.currentPage + 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage + 1) * 3) + 1])
					}
				} else {
					self.pageViewControllers[self.nextPageViewController] = nil
				}
			})
		} else if currentPage > index{
			currentPage = index
			if pageViewControllers[previousPageViewController] == nil{
				pageViewControllers[previousPageViewController] = EditorViewPageViewController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage ) * 3) + 1], self)
			} else {
				pageViewControllers[previousPageViewController]?.loadController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage ) * 3) + 1])
			}
			if currentPage < document.pageCount - 1{
				if pageViewControllers[nextPageViewController] == nil{
					pageViewControllers[nextPageViewController] = EditorViewPageViewController(document.page(at: currentPage + 1)!, currentPage + 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage + 1) * 3) + 1], self)
				} else {
					pageViewControllers[nextPageViewController]?.loadController(document.page(at: currentPage + 1)!, currentPage + 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage + 1) * 3) + 1])
				}
			}
			
			self.setViewControllers([pageViewControllers[previousPageViewController]!], direction: (forwards != nil) ? ((forwards!) ? .forward : .reverse) : .reverse, animated: true, completion: {_ in
				self.currentPageViewController = self.previousPageViewController
				if self.currentPageViewController == 0{
					if self.nextPageViewController == 1{
						self.previousPageViewController = 2
					} else if self.nextPageViewController == 2{
						self.previousPageViewController = 1
					}
				} else if self.currentPageViewController == 1{
					if self.nextPageViewController == 0{
						self.previousPageViewController = 2
					} else if self.nextPageViewController == 2{
						self.previousPageViewController = 0
					}
				} else if self.currentPageViewController == 2{
					if self.nextPageViewController == 1{
						self.previousPageViewController = 0
					} else if self.nextPageViewController == 0{
						self.previousPageViewController = 1
					}
				}
				if self.currentPage > 0{
					if self.pageViewControllers[self.previousPageViewController] == nil{
						self.pageViewControllers[self.previousPageViewController] = EditorViewPageViewController(self.document.page(at: self.currentPage - 1)!, self.currentPage + 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage - 1) * 3) + 1], self)
					} else {
						self.pageViewControllers[self.previousPageViewController]?.loadController(self.document.page(at: self.currentPage - 1)!, self.currentPage + 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage - 1) * 3) + 1])
					}
				} else {
					self.pageViewControllers[self.previousPageViewController] = nil
				}
			})
		} else if forwards != nil {
			currentPage = index
			if pageViewControllers[previousPageViewController] == nil{
				pageViewControllers[previousPageViewController] = EditorViewPageViewController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage) * 3) + 1], self)
			} else {
				pageViewControllers[previousPageViewController]?.loadController(document.page(at: currentPage)!, currentPage, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage) * 3) + 1])
			}
			if currentPage < document.pageCount - 1{
				if pageViewControllers[nextPageViewController] == nil{
					pageViewControllers[nextPageViewController] = EditorViewPageViewController(document.page(at: currentPage + 1)!, currentPage + 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage + 1) * 3) + 1], self)
				} else {
					pageViewControllers[nextPageViewController]?.loadController(document.page(at: currentPage + 1)!, currentPage + 1, currentScale, (self.annotationLayer.count <= 1) ? "" : annotationLayer[((currentPage + 1) * 3) + 1])
				}
			}
			
			self.setViewControllers([pageViewControllers[previousPageViewController]!], direction: (forwards!) ? .forward : .reverse, animated: true, completion: {_ in
				self.currentPageViewController = self.previousPageViewController
				if self.currentPageViewController == 0{
					if self.nextPageViewController == 1{
						self.previousPageViewController = 2
					} else if self.nextPageViewController == 2{
						self.previousPageViewController = 1
					}
				} else if self.currentPageViewController == 1{
					if self.nextPageViewController == 0{
						self.previousPageViewController = 2
					} else if self.nextPageViewController == 2{
						self.previousPageViewController = 0
					}
				} else if self.currentPageViewController == 2{
					if self.nextPageViewController == 1{
						self.previousPageViewController = 0
					} else if self.nextPageViewController == 0{
						self.previousPageViewController = 1
					}
				}
				if self.currentPage > 0{
					if self.pageViewControllers[self.previousPageViewController] == nil{
						self.pageViewControllers[self.previousPageViewController] = EditorViewPageViewController(self.document.page(at: self.currentPage - 1)!, self.currentPage - 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage - 1) * 3) + 1], self)
					} else {
						self.pageViewControllers[self.previousPageViewController]?.loadController(self.document.page(at: self.currentPage - 1)!, self.currentPage - 1, self.currentScale, (self.annotationLayer.count <= 1) ? "" : self.annotationLayer[((self.currentPage - 1) * 3) + 1])
					}
				} else {
					self.pageViewControllers[self.previousPageViewController] = nil
				}
			})
		} 
		controller.pageNumber.text = "Page \(currentPage + 1) of \(document.pageCount)"
	}
	
    
	func setDocument(_ fileInfo: EditorFileInfo, _ previousIndex: Int, _ newIndex: Int){
		let documetAddress = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent((fileInfo.item as? Book != nil) ? (fileInfo.item as! Book).localAddress! : (fileInfo.item as! Notebook).localAddress!).appendingPathComponent("attachments")
		self.document = PDFDocument(url: documetAddress.appendingPathComponent("root"))
		annotationLayer = try! String(contentsOf: documetAddress.appendingPathComponent("top")).components(separatedBy: .newlines)
		updating = true
		goToPage(fileInfo.currentPage, previousIndex <= newIndex)
		updating = false
	}
	
    
//    override func draw(_ page: PDFPage, to context: CGContext) {
//       case "img":
//                if currentPageImageData == nil {
//                    fetchImagedData(page)
//                }
//                for index in 0..<currentPageImageData.data.count{
//                    let currentImage = UIImage(data: currentPageImageData.data[index])!
//                    let originalRect = currentPageImageData.positions[index]
//                    var xorigin = originalRect.origin.x
//                    var yorigin = originalRect.origin.y
//                    var width = originalRect.size.width
//                    var height = originalRect.size.height
//                    if xorigin < page.bounds(for: .mediaBox).origin.x {
//                        xorigin = page.bounds(for: .mediaBox).origin.x
//                    }
//
//                    if yorigin < page.bounds(for: .mediaBox).origin.y{
//                        yorigin = page.bounds(for: .mediaBox).origin.y
//                    }
//
//                    if xorigin + width > page.bounds(for: .mediaBox).origin.x + page.bounds(for: .mediaBox).size.width{
//                        width = page.bounds(for: .mediaBox).origin.x + page.bounds(for: .mediaBox).size.width -  xorigin
//                    }
//
//                    if yorigin + height > page.bounds(for: .mediaBox).origin.y + page.bounds(for: .mediaBox).size.height{
//                        height = page.bounds(for: .mediaBox).origin.y + page.bounds(for: .mediaBox).size.height - yorigin
//                    }
//                    let finalRect = CGRect(x: xorigin, y: yorigin, width: width, height: height)
//
//                    let finalCurrentImage = currentImage.cgImage!.cropping(to: finalRect)!
//                    context.draw(finalCurrentImage, in: currentPageImageData.positions[index])
//                }
//            case "text":
//                if currentPageTextData == nil{
//                    fetchTextData(page)
//                }
//
//            default:
//                print("error")
//            }
//        }
//
//        if linkMode {
//            if currentPageLinkData == nil{
//                fetchLinkData(page)
//            }
//            for index in 0..<currentPageLinkData.links.count{
//
//            }
//        }
        
//        DispatchQueue.main.async {
//            if self.currentAnnotationLayer == nil{
//                self.currentAnnotationLayer = AnnotationView(frame: page.bounds(for: .mediaBox))
//                self.currentAnnotationLayer.controller = self
//                self.currentAnnotationLayer.page = page
//                self.addSubview(self.currentAnnotationLayer)
//            }
//
//            self.draw(self.currentAnnotationLayer.layer, in: context)
//            self.layoutSubviews()
//        }
        
        
//    }
    
    func clearCurrentPageData(){
//        currentPageLayerData = nil
//        currentPageInkData = nil
//        currentPageImageData = nil
//        currentPageLinkData = nil
//        currentPageTextData = nil
    }
    
}

class EditorSetInfo: EditingFile{
	var item: FileItem!
	var latestActions: [String] = []
	var undoneActions: [String] = []
	var linkMode = false
	
	init(_ item: TermSet) {
		self.item = item
	}
}

