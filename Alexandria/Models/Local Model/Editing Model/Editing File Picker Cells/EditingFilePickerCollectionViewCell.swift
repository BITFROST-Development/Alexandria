////
////  EditingFilePickerCollectionViewCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 9/25/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import PDFKit
//import ZIPFoundation
//
//class EditingFilePickerCollectionViewCell: UICollectionViewCell {
//    
//    static var identifier = "editingFilePickerCell"
//    
//    var controller: EditingFilePickerViewController!
//    var cellKind: String!
//    var itemIndex: Int!
//    @IBOutlet weak var shadowView: UIView!
//    @IBOutlet weak var iconView: EditingPickerImage!
//    @IBOutlet weak var itemTitle: UILabel!
//    @IBOutlet weak var shadowWidth: NSLayoutConstraint!
//    @IBOutlet weak var shadowHeight: NSLayoutConstraint!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    @IBAction func selectCell(_ sender: Any) {
//        if cellKind == "Shelf" || cellKind == "Vault"{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.controller.pickerCollection.layer.frame.origin.x = 0 - self.controller.view.layer.frame.size.width
//            }){ _ in
//                if self.cellKind == "Shelf"{
//                    if self.itemIndex > 0{
//                        self.controller.currentShelf = self.controller.displayingShelves[self.itemIndex - 1]
//                    } else {
//                        self.controller.currentShelf = nil
//                    }
//                    self.controller.sourceKind = "Book"
//                    self.controller.displayingShelves.removeAll()
//                } else {
//                    if self.controller.currentVault != nil {
//                        self.controller.parentVault.append(self.controller.currentVault)
//                    }
//                    self.controller.currentVault = self.controller.displayingVaultItems[self.itemIndex] as? Vault
//                    self.controller.displayingVaultItems.removeAll()
//                }
//                self.controller.pickerCollection.reloadData()
//                self.controller.pickerCollection.layer.frame.origin.x = self.controller.view.layer.frame.size.width
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.controller.pickerCollection.layer.frame.origin.x = 0
//                })
//            }
//        } else {
//            if cellKind == "Book"{
//                let book = controller.displayingBooks[itemIndex]
//                let url = URL(fileURLWithPath: book.localAddress!)
//                let archive = Archive(url: url, accessMode: .read)
////                try! archive!.extract(archive!["attachments/root"]!, consumer: { pdfData in
////                    let pdfDoc = PDFDocument(data: pdfData)
////                    try! archive!.extract(archive!["userData/layer"]!, consumer: { layerData in
////                        try! archive!.extract(archive!["userData/ink"], consumer: <#T##(Data) throws -> Void#>)
////                        self.controller.controller.currentBook = book
////                        self.controller.controller.bookView.document = pdfDoc
////                        self.controller.dismiss(animated: true, completion: nil)
////                    })
////                })
//            } else if cellKind == "Notebook"{
//                let notebook = controller.displayingVaultItems[itemIndex] as! Notebook
//                controller.controller.currentNotebook = notebook
//                do{
//                    let data = try Data(contentsOf: URL(fileURLWithPath: notebook.localAddress!))
//                    controller.controller.notebookView.document = PDFDocument(data: data)
//                    controller.dismiss(animated: true, completion: nil)
//                } catch let error{
//                    print(error.localizedDescription)
//                    let alert = UIAlertController(title: "Problem opening notebook", message: "There was a problem opening the notebook, try again later or contact support.alexandria@bitfrost.app.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//                    controller.present(alert, animated: true)
//                }
//            } else {
//                
//            }
//        }
//    }
//    
//}
//
//class EditingPickerImage: UIImageView{
//    var controller: EditingFilePickerCollectionViewCell!
//    override var intrinsicContentSize: CGSize{
//        get{
//            if controller.cellKind == "Vault" || controller.cellKind == "Set"{
//                return CGSize(width: 50, height: 100)
//            }
//            return super.intrinsicContentSize
//        }
//    }
//}
