//
//  NotebookView.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/28/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit

class NotebookView: PDFView {
    override var canGoForward: Bool{
        get{
            if !super.canGoForward && document?.index(for: currentPage!) == document!.pageCount - 2{
                return shouldGoForward
            }
            return super.canGoForward
        } set(value) {
            shouldGoForward = value
        }
    }
    var scrollView: UIScrollView?{
        get{
            for subView in self.subviews{
                for view in subView.subviews{
                    if let scroller = view as? UIScrollView{
                        return scroller
                    }
                }
            }
            return nil
        }
    }
    var currentlyZooming: Bool{
        get{
            return scrollView!.isZooming
        }
    }
    var shouldGoForward = false
    var annotating = false
    override func goToFirstPage(_ sender: Any?) {
        super.goToFirstPage(sender)
        super.goToFirstPage(sender)
    }
    
//    override func draw(_ page: PDFPage, to context: CGContext) {
////        var shouldDraw = true
////        DispatchQueue.main.async {
////            if !self.currentlyZooming{
////                shouldDraw = false
////            }
////        }
////
////        if shouldDraw {
////            context.drawPDFPage(page.pageRef!)
////        }
//
//
//
////        DispatchQueue.main.async {
////            if !(self.scrollView?.isZooming ?? false) {
////                super.draw(page, to: context)
////            }
////        }
//    }
    
    override func draw(_ rect: CGRect) {
        if document != nil{
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.scaleBy(x: 1, y: -1)
            ctx?.translateBy(x: 0, y: -rect.size.height)
            
            let mediaRect = currentPage!.pageRef?.getBoxRect(.cropBox)
            ctx?.scaleBy(x: rect.size.width / mediaRect!.size.width, y: rect.size.height / mediaRect!.size.height)
            ctx?.translateBy(x: 0 - mediaRect!.origin.x, y: 0 - mediaRect!.origin.y)
            ctx?.drawPDFPage(currentPage!.pageRef!)
        }
    }
}
