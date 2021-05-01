//
//  AuthenticationSourceDocumentViewManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/26/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth
import PDFKit

extension AuthenticationSource: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let pickedFile = urls[0]
        if pickedFile.lastPathComponent.split(separator: ".").last == "pdf" {
			itemNameClue = pickedFile.deletingPathExtension().lastPathComponent
			let pdfDoc = PDFDocument(url: pickedFile)
			itemAuthorClue = pdfDoc?.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String
			itemYearClue = pdfDoc?.documentAttributes?[PDFDocumentAttribute.creationDateAttribute] as? String
			let page = pdfDoc?.page(at: 0)
			let pageSize = page?.bounds(for: .mediaBox)
			let pdfScale = 180 / pageSize!.width
			let scale = UIScreen.main.scale * pdfScale
			let screenSize = CGSize(width: pageSize!.width * scale, height: pageSize!.height * scale)
			itemImageClue = [page!.thumbnail(of: screenSize, for: .mediaBox)]
			itemOriginalLocationClue = pickedFile
            self.performSegue(withIdentifier: "toAddItemView", sender: controller)
        } else {
            
        }
    }
}
