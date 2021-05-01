//
//  EditingManger.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/25/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension EditingViewController{
	
	@objc func exitEditingMode(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func presentAddView(){
		
	}
	
	@objc func toPicker(){
		
	}
	
	@objc func presentThumbnailView(){
		
	}
	
	@objc func bookmarkPage(){
		if let book = currentlyOpen.item as? Book{
			book.bookmarkedPages.append(ListWrapperForDouble(Double(fileView.currentPage)))
		} else if let notebook = currentlyOpen.item as? Notebook{
			notebook.bookmarkedPages.append(ListWrapperForDouble(Double(fileView.currentPage)))
		}
	}
	
	@objc func shareFile(){
		
	}
	
	@objc func startSearch(){
		
	}
	
	@objc func undoAction(){
//		if let fileInfo = currentlyOpen as? EditorFileInfo{
//			if let lastLayer = fileInfo.currentPageData.layerData.layers.last{
//				switch lastLayer.type {
//				case .ink:
//					let deletingLayer = fileInfo.currentPageData.inkData.groups[lastLayer.index]
//					if let currentPageUndone = fileInfo.undoneActions[fileInfo.currentPage]{
//						currentPageUndone.layerData.layers.append(LayerObject("ink", currentPageUndone.inkData.groups.count, <#T##parent: LayerData##LayerData#>))
//					}
//				case .image:
//					
//				case .link:
//					
//				case .text:
//					
//				default:
//					print("something went wrong in undo")
//				}
//			}
//			
//		}
	}
	
	@objc func redoAction(){
		
	}
	
	@objc func editCurrentFile(){
		
	}
	
	@objc func writingGesture(_ kind: String){
		removeGestures()
		fileView.view.addGestureRecognizer(inkToolPan)
		currentWrittingTool = kind
	}
	
	@objc func linkGesture(){
		removeGestures()
		fileView.view.addGestureRecognizer(linkToolPan)
	}
	
	@objc func lassoGesture(){
		removeGestures()
		fileView.view.addGestureRecognizer(lassoToolPan)
	}
	
	@objc func dragGesture(){
		removeGestures()
	}
	
	@objc func textGesture(_ kind: String){
		removeGestures()
		fileView.view.addGestureRecognizer(textToolPan)
	}
	
	@objc func changeTabTo(index: Int){
		let previousIndex = openElements.firstIndex(where: {$0.item.personalID == currentlyOpen.item.personalID})!
		currentlyOpen = openElements[index]
		tabSwitcher.tabCollection.reloadData()
		if currentlyOpen.item as? TermSet != nil{
			self.toolBox.alpha = 0
			self.fileView.view.alpha = 0
			self.termSetView.alpha = 1
			self.editorFileNavigationViewLarge.alpha = 0
			self.editorFileNavigationViewShort.alpha = 0
			self.editorSetNavigationViewLarge.alpha = 0
			self.editorSetNavigationViewShort.alpha = 0
			if editorSetNavigationViewLargeHeight.constant == 115{
				self.editorSetNavigationViewLarge.alpha = 1
				self.editorSetNavigationViewLarge.refreshView()
				self.tabSwitcherDistanceToTop.constant = 115
				UIView.animate(withDuration: 0.3, animations: {
					self.view.layoutIfNeeded()
				})
			} else {
				self.editorSetNavigationViewShort.alpha = 1
				self.editorSetNavigationViewShort.refreshView()
				self.tabSwitcherDistanceToTop.constant = 45
				UIView.animate(withDuration: 0.3, animations: {
					self.view.layoutIfNeeded()
				})
			}
			self.termSetView.reloadData()
		} else {
			self.toolBox.alpha = 1
			self.fileView.view.alpha = 1
			self.termSetView.alpha = 0
			self.editorFileNavigationViewLarge.alpha = 0
			self.editorFileNavigationViewShort.alpha = 0
			self.editorSetNavigationViewLarge.alpha = 0
			self.editorSetNavigationViewShort.alpha = 0
			if editorFileNavigationViewLargeHeight.constant == 115{
				self.editorFileNavigationViewLarge.alpha = 1
				self.editorFileNavigationViewLarge.refreshView()
				self.tabSwitcherDistanceToTop.constant = 115
				UIView.animate(withDuration: 0.3, animations: {
					self.view.layoutIfNeeded()
				})
			} else {
				self.editorFileNavigationViewShort.alpha = 1
				self.editorFileNavigationViewShort.refreshView()
				self.tabSwitcherDistanceToTop.constant = 45
				UIView.animate(withDuration: 0.3, animations: {
					self.view.layoutIfNeeded()
				})
			}
			self.fileView.setDocument(currentlyOpen as! EditorFileInfo, previousIndex, index)
		}
	}
	
	@objc func closeTabAt(index: Int){
		if openElements.count > 2{
			tabSwitcher.tabCollection.performBatchUpdates({
				self.tabSwitcher.tabCollection.deleteItems(at: [IndexPath(row: index, section: 0)])
			}, completion: {_ in
				self.openElements.remove(at: index)
				let currentIndex = (index == self.openElements.count) ? index - 1 : index
				self.currentlyOpen = self.openElements[currentIndex]
				if self.currentlyOpen.item as? TermSet != nil{
					self.toolBox.alpha = 0
					self.fileView.view.alpha = 0
					self.termSetView.alpha = 1
					self.termSetView.reloadData()
				} else {
					self.toolBox.alpha = 1
					self.fileView.view.alpha = 1
					self.termSetView.alpha = 0
					self.fileView.setDocument(self.currentlyOpen as! EditorFileInfo, index, currentIndex)
				}
				self.tabSwitcher.tabCollection.reloadData()
			})
		} else {
			self.openElements.remove(at: index)
			let currentIndex = (index == self.openElements.count) ? index - 1 : index
			self.currentlyOpen = self.openElements[currentIndex]
			self.tabSwitcherHeight.constant = 0
			if currentlyOpen.item as? TermSet != nil{
				self.toolBox.alpha = 0
				self.fileView.view.alpha = 0
				self.termSetView.alpha = 1
				self.termSetView.reloadData()
			} else {
				self.toolBox.alpha = 1
				self.fileView.view.alpha = 1
				self.termSetView.alpha = 0
				self.fileView.setDocument(currentlyOpen as! EditorFileInfo, index, currentIndex)
			}
			self.toolBoxDistanceToTop.constant -= 30
			UIView.animate(withDuration: 0.5, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}
	
	private func removeGestures(){
		fileView.view.removeGestureRecognizer(self.inkToolPan)
		fileView.view.removeGestureRecognizer(self.linkToolPan)
		fileView.view.removeGestureRecognizer(self.lassoToolPan)
		fileView.view.removeGestureRecognizer(self.textToolPan)
	}
    
    @objc func shouldAddPage(_ gesture: UIPanGestureRecognizer){
//        if pickerBar.selectedSegmentIndex == 1{
//            if notebookView.document?.index(for: notebookView.currentPage!) == notebookView.document!.pageCount - 1{
//                let transition = gesture.translation(in: self.view)
//                if transition.x < 0{
//                    if transition.x > 0 - 90{
//                        addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width + transition.x
//                    }
//                    addPageSymbol.alpha = (0 - transition.x) / 90
//                    if gesture.state == .ended{
//                        if transition.x < 0 - 90 || gesture.velocity(in: self.view).x < 0 - 1000{
//                            let pageData = notebookView.currentPage?.dataRepresentation
//                            let newPage = PDFDocument(data: pageData!)?.page(at: 0)
//                            notebookView.document!.insert(newPage!, at: notebookView.document!.pageCount)
//                            notebookView.layoutDocumentView()
//                            notebookView.document!.write(to: URL(fileURLWithPath: currentNotebook.localAddress!).appendingPathComponent("attachments").appendingPathComponent("root"))
//                            let tempDoc = notebookView.document
//                            notebookView.document = nil
//                            notebookView.document = tempDoc
//                            notebookView.maxScaleFactor = 7.5
//                            notebookView.minScaleFactor = notebookView.scaleFactorForSizeToFit
//                            notebookView.goToFirstPage(self)
//                            let addedPage = notebookView.document?.page(at: notebookView.document!.pageCount - 1)
//                            notebookView.canGoForward = true
//                            print(notebookView.canGoForward)
//                            notebookView.go(to: addedPage!)
//                            UIView.animate(withDuration: 0.3, animations: {
//                                self.addPageSymbol.alpha = 0
//                            }){_ in
//                                self.addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width
//                            }
//                        } else {
//                            UIView.animate(withDuration: 0.3, animations: {
//                                self.addPageSymbol.alpha = 0
//                                self.addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width
//                            })
//                        }
//                    }
//                }
//            }
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toFilePicker"{
//            let destination = segue.destination as! EditingFilePickerViewController
//            destination.controller = self
//            if self.pickerBar.selectedSegmentIndex == 0{
//                destination.sourceKind = "Shelf"
//            } else if self.pickerBar.selectedSegmentIndex == 1{
//                destination.sourceKind = "Note"
//            } else {
//                destination.sourceKind = "Set"
//            }
//        }
    }
}

extension EditingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed{
			if let pdfView = pageViewController as? EditorView{
				if pdfView.viewControllers?.first as? EditorViewPageViewController == pdfView.pageViewControllers[pdfView.previousPageViewController]{
					pdfView.currentPage -= 1
					pdfView.nextPageViewController = pdfView.currentPageViewController
					pdfView.currentPageViewController = pdfView.previousPageViewController
					if pdfView.currentPageViewController == 0{
						if pdfView.nextPageViewController == 1{
							pdfView.previousPageViewController = 2
						} else if pdfView.nextPageViewController == 2{
							pdfView.previousPageViewController = 1
						}
					} else if pdfView.currentPageViewController == 1{
						if pdfView.nextPageViewController == 0{
							pdfView.previousPageViewController = 2
						} else if pdfView.nextPageViewController == 2{
							pdfView.previousPageViewController = 0
						}
					} else if pdfView.currentPageViewController == 2{
						if pdfView.nextPageViewController == 1{
							pdfView.previousPageViewController = 0
						} else if pdfView.nextPageViewController == 0{
							pdfView.previousPageViewController = 1
						}
					}
					if pdfView.currentPage > 0 {
						if pdfView.currentPage == pdfView.bufferViewController?.pageNumber{
							pdfView.pageViewControllers[pdfView.previousPageViewController] = pdfView.bufferViewController
						} else {
							if pdfView.pageViewControllers[pdfView.previousPageViewController] == nil{
								pdfView.pageViewControllers[pdfView.previousPageViewController] = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage - 1)!, pdfView.currentPage - 1, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage - 1) * 3) + 1], pdfView)
							} else {
								pdfView.pageViewControllers[pdfView.previousPageViewController]?.loadController(pdfView.document.page(at: pdfView.currentPage - 1)!, pdfView.currentPage - 1, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage - 1) * 3) + 1])
							}
							
							if pdfView.currentPage > 1{
								pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage - 2)!, pdfView.currentPage - 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage - 2) * 3) + 1], pdfView)
							} else if pdfView.currentPage + 1 < pdfView.document.pageCount - 1{
								pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage + 2)!, pdfView.currentPage + 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage + 2) * 3) + 1], pdfView)
							}
						}
					} else {
						pdfView.pageViewControllers[pdfView.previousPageViewController] = nil
						if pdfView.currentPage + 1 < pdfView.document.pageCount - 1{
							pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage + 2)!, pdfView.currentPage + 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage + 2) * 3) + 1], pdfView)
						}
					}
				} else if pdfView.viewControllers?.first as? EditorViewPageViewController == pdfView.pageViewControllers[pdfView.nextPageViewController]{
					pdfView.currentPage += 1
					pdfView.previousPageViewController = pdfView.currentPageViewController
					pdfView.currentPageViewController = pdfView.nextPageViewController
					
					if pdfView.currentPageViewController == 0{
						if pdfView.previousPageViewController == 1{
							pdfView.nextPageViewController = 2
						} else if pdfView.previousPageViewController == 2{
							pdfView.nextPageViewController = 1
						}
					} else if pdfView.currentPageViewController == 1{
						if pdfView.previousPageViewController == 0{
							pdfView.nextPageViewController = 2
						} else if pdfView.previousPageViewController == 2{
							pdfView.nextPageViewController = 0
						}
					} else if pdfView.currentPageViewController == 2{
						if pdfView.previousPageViewController == 1{
							pdfView.nextPageViewController = 0
						} else if pdfView.previousPageViewController == 0{
							pdfView.nextPageViewController = 1
						}
					}
					
					if pdfView.currentPage < pdfView.document.pageCount - 1{
						if pdfView.currentPage + 1 == pdfView.bufferViewController?.pageNumber{
							pdfView.pageViewControllers[pdfView.nextPageViewController] = pdfView.bufferViewController
						} else {
							if pdfView.pageViewControllers[pdfView.nextPageViewController] == nil{
								pdfView.pageViewControllers[pdfView.nextPageViewController] = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage + 1)!, pdfView.currentPage + 1, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage + 1) * 3) + 1], pdfView)
							} else {
								pdfView.pageViewControllers[pdfView.nextPageViewController]?.loadController(pdfView.document.page(at: pdfView.currentPage + 1)!, pdfView.currentPage + 1, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage + 1) * 3) + 1])
							}
						}
						if pdfView.currentPage + 1 < pdfView.document.pageCount - 1{
							pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage + 2)!, pdfView.currentPage + 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage + 2) * 3) + 1], pdfView)
						} else if pdfView.currentPage > 1{
							pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage - 2)!, pdfView.currentPage - 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage - 2) * 3) + 1], pdfView)
						}
					} else {
						pdfView.pageViewControllers[pdfView.nextPageViewController] = nil
						if pdfView.currentPage > 1{
							pdfView.bufferViewController = EditorViewPageViewController(pdfView.document.page(at: pdfView.currentPage - 2)!, pdfView.currentPage - 2, pdfView.currentScale, pdfView.annotationLayer[((pdfView.currentPage - 2) * 3) + 1], pdfView)
						}
					}
				}
				pageNumber.text = "Page \(pdfView.currentPage + 1) of \(pdfView.document.pageCount)"
			}
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		if let pdfView = pageViewController as? EditorView{
			pdfView.pageViewControllers[pdfView.currentPageViewController]?.writeChages()
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let pdfView = pageViewController as? EditorView{
			if pdfView.currentPage > 0{
				return pdfView.pageViewControllers[pdfView.previousPageViewController]
			}
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let pdfView = pageViewController as? EditorView{
			if pdfView.currentPage < pdfView.document.pageCount - 1{
				return pdfView.pageViewControllers[pdfView.nextPageViewController]
			}
		}
		return nil
	}
	
	
}

class ScrollingGestureRecognizer: UIPanGestureRecognizer{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .began
        let coalleced = event.coalescedTouches(for: touches.first!)
        let scrollingDelegate = delegate as! PDFScrollGestureDelegate
        scrollingDelegate.controller.currentlyScrolling = true
//        scrollingDelegate.controller.scrollBegan(self)
    }
}
