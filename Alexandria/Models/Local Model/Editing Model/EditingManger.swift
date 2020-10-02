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
    @objc func pickerChanged(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            if self.currentBook != nil {
                self.viewTitle.text = self.currentBook.title
            }
            bookView.alpha = 1
            self.bookView.layer.frame.origin.x = 0 - self.view.layer.frame.size.width
            self.lastSelectedBarIndex = sender.selectedSegmentIndex
            self.notebookView.layer.frame.origin.x = 0
            self.termSetView.layer.frame.origin.x = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.notebookView.layer.frame.origin.x = self.view.layer.frame.size.width
                self.termSetView.layer.frame.origin.x = self.view.layer.frame.size.width
                self.bookView.layer.frame.origin.x = 0
                self.notebookView.layoutIfNeeded()
                self.bookView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }){_ in
                if self.currentBook == nil{
                    self.performSegue(withIdentifier: "toFilePicker", sender: self)
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.notebookView.alpha = 0
                    self.termSetView.alpha = 0
                })
            }
        } else if sender.selectedSegmentIndex == 1{
            if self.lastSelectedBarIndex < 1{
                self.notebookView.layer.frame.origin.x = self.view.layer.frame.size.width
            } else if self.lastSelectedBarIndex > 1{
                self.notebookView.layer.frame.origin.x = 0 - self.view.layer.frame.size.width
            }
            if self.currentNotebook != nil{
                self.viewTitle.text = self.currentNotebook.name
            }
            self.lastSelectedBarIndex = sender.selectedSegmentIndex
            notebookView.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                if self.lastSelectedBarIndex < 1{
                    self.bookView.layer.frame.origin.x = 0 - self.view.layer.frame.size.width
                    self.termSetView.layer.frame.origin.x = self.view.layer.frame.size.width
                } else if self.lastSelectedBarIndex > 1 {
                    self.bookView.layer.frame.origin.x = self.view.layer.frame.size.width
                    self.termSetView.layer.frame.origin.x = self.view.layer.frame.size.width
                }
                self.notebookView.layoutIfNeeded()
                self.bookView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                self.notebookView.layer.frame.origin.x = 0
            }){ _ in
                if self.currentNotebook == nil{
                    self.performSegue(withIdentifier: "toFilePicker", sender: self)
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.bookView.alpha = 0
                    self.termSetView.alpha = 0
                })
            }
        } else {
            self.termSetView.layer.frame.origin.x = self.view.layer.frame.size.width
            self.termSetView.alpha = 1
            if self.currentSet != nil{
                self.viewTitle.text = self.currentSet.name
            }
            termSetView.alpha = 1
            self.lastSelectedBarIndex = sender.selectedSegmentIndex
            UIView.animate(withDuration: 0.5, animations: {
                self.bookView.layer.frame.origin.x = 0 - self.view.layer.frame.size.width
                self.notebookView.layer.frame.origin.x = 0 - self.view.layer.frame.size.width
                self.termSetView.frame.origin.x = 0
            }){ _ in
                if self.currentSet == nil{
                    self.performSegue(withIdentifier: "toFilePicker", sender: self)
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.notebookView.alpha = 0
                    self.bookView.alpha = 0
                })
            }
        }
    }
    
    @objc func shouldAddPage(_ gesture: UIPanGestureRecognizer){
        if pickerBar.selectedSegmentIndex == 1{
            if notebookView.document?.index(for: notebookView.currentPage!) == notebookView.document!.pageCount - 1{
                let transition = gesture.translation(in: self.view)
                if transition.x < 0{
                    if transition.x > 0 - 90{
                        addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width + transition.x
                    }
                    addPageSymbol.alpha = (0 - transition.x) / 90
                    if gesture.state == .ended{
                        if transition.x < 0 - 90 || gesture.velocity(in: self.view).x < 0 - 1000{
                            print("yessirrrr")
                            let pageData = notebookView.currentPage?.dataRepresentation
                            let newPage = PDFDocument(data: pageData!)?.page(at: 0)
                            notebookView.document!.insert(newPage!, at: notebookView.document!.pageCount)
                            notebookView.layoutDocumentView()
                            notebookView.document!.write(to: URL(fileURLWithPath: currentNotebook.localAddress!))
                            let tempDoc = notebookView.document
                            notebookView.document = nil
                            notebookView.document = tempDoc
                            notebookView.maxScaleFactor = 7.5
                            notebookView.minScaleFactor = notebookView.scaleFactorForSizeToFit
                            notebookView.goToFirstPage(self)
                            let addedPage = notebookView.document?.page(at: notebookView.document!.pageCount - 1)
                            notebookView.canGoForward = true
                            print(notebookView.canGoForward)
                            notebookView.go(to: addedPage!)
                            UIView.animate(withDuration: 0.3, animations: {
                                self.addPageSymbol.alpha = 0
                            }){_ in
                                self.addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width
                            }
                        } else {
                            UIView.animate(withDuration: 0.3, animations: {
                                self.addPageSymbol.alpha = 0
                                self.addPageSymbol.layer.frame.origin.x = self.view.layer.frame.size.width
                            })
                        }
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilePicker"{
            let destination = segue.destination as! EditingFilePickerViewController
            destination.controller = self
            if self.pickerBar.selectedSegmentIndex == 0{
                destination.sourceKind = "Shelf"
            } else if self.pickerBar.selectedSegmentIndex == 1{
                destination.sourceKind = "Note"
            } else {
                destination.sourceKind = "Set"
            }
        }
    }
}
