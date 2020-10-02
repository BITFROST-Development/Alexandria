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
    
    var shouldGoForward = false
    var annotating = false
    override func goToFirstPage(_ sender: Any?) {
        super.goToFirstPage(sender)
        super.goToFirstPage(sender)
    }
    
}
