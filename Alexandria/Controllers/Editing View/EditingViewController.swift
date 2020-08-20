//
//  EditingViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/18/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import PDFKit

class EditingViewController: UIViewController {
    
    var currentBook: Book!
    @IBOutlet weak var pdfView: PDFView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
        let path = URL(fileURLWithPath: currentBook.localAddress!)

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        } else {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        }
    }

    @IBAction func exitEditingMode(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
