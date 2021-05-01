////
////  BookCell.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 7/21/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class BookCell: UICollectionViewCell {
//
//    
//    static var identifier = "bookCell"
//    
//    var controller: MyShelvesViewController!
//    var bookIndex: Double!
//    var isCloud: Bool!
//    @IBOutlet var backgroundColorView: UIView!
//    @IBOutlet var thumbnailImage: UIButton!
//    @IBOutlet var bookTitle: UILabel!
//    @IBOutlet var bookDescription: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        thumbnailImage.imageView?.layer.cornerRadius = 6
//        thumbnailImage.imageView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//        backgroundColorView.layer.cornerRadius = 6
//        backgroundColorView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//    }
//
//    @IBAction func displayOptions(_ sender: Any) {
//        print(bookIndex)
//        controller.displayBookOptions(for: self)
//    }
//    
//    @IBAction func openBook(_ sender: Any) {
//        let realm = AppDelegate.realm
//        if isCloud{
//            controller.currentBook = realm!.objects(AlexandriaData.self)[0].cloudBooks[Int(bookIndex)]
//        } else {
//            controller.currentBook = realm!.objects(AlexandriaData.self)[0].localBooks[Int(bookIndex)]
//        }
//        controller.openBook(named: bookTitle.text!)
//    }
//    
//}
