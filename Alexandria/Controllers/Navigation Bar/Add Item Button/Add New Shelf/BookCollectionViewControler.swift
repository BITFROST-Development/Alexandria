//
//  BookCollectionViewControler.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/27/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class BookCollectionViewControler: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let realm = try! Realm(configuration: AppDelegate.realmConfig)
    
    var controller: ShelfChangerDelegate!
    var selectedCloudBooks: [Double] = []
    var selectedLocalBooks: [Double] = []
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ShelfBookPickerCollectionCell", bundle: nil), forCellWithReuseIdentifier: ShelfBookPickerCollectionCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(selectedLocalBooks)
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishSelecting(_ sender: Any) {
        print(selectedLocalBooks)
        print(selectedCloudBooks)
        controller.booksCell.cloudBooksInCollection = selectedCloudBooks
        controller.booksCell.localBooksInCollection = selectedLocalBooks
        controller.reloadAllData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension BookCollectionViewControler: UICollectionViewDelegate{
    
}

extension BookCollectionViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm.objects(Book.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < realm.objects(AlexandriaData.self)[0].cloudBooks.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfBookPickerCollectionCell.identifier, for: indexPath) as! ShelfBookPickerCollectionCell
            cell.controller = self
            var indexToCheck = selectedCloudBooks.count / 2
            while indexToCheck < selectedCloudBooks.count {
                if selectedCloudBooks[indexToCheck] > Double(indexPath.row){
                    indexToCheck /= 2
                } else if selectedCloudBooks[indexToCheck] < Double(indexPath.row){
                    if indexToCheck % 2 == 0{
                        indexToCheck = indexToCheck * 3 / 2
                    } else {
                        indexToCheck = (indexToCheck * 3 / 2) + 1
                    }
                } else if indexToCheck == 0 && selectedCloudBooks[indexToCheck] != Double(indexPath.row){
                    break
                } else {
                    let basicImage = UIImage(systemName: "xmark.circle.fill")
                    cell.bookShadow.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 0.4))
                    let imageToSet = basicImage?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
                    cell.addDeleteButton.setImage(imageToSet, for: .normal)
                    cell.isSelectedBook = true
                    break
                }
            }
            cell.bookImage.setImage(UIImage(data: realm.objects(AlexandriaData.self)[0].cloudBooks[indexPath.row].thumbnail!.data!), for: .normal)
            cell.bookTitle.text = realm.objects(AlexandriaData.self)[0].cloudBooks[indexPath.row].title
            cell.bookIndexInContext = Double(indexPath.row)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfBookPickerCollectionCell.identifier, for: indexPath) as! ShelfBookPickerCollectionCell
            cell.controller = self
            cell.isCloud = false
            var indexToCheck = selectedLocalBooks.count / 2
            while indexToCheck < selectedLocalBooks.count {
                if indexToCheck == 0 && selectedLocalBooks[indexToCheck] != Double(indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count){
                    break
                } else if selectedLocalBooks[indexToCheck] > Double(indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count){
                    indexToCheck /= 2
                } else if selectedLocalBooks[indexToCheck] < Double(indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count){
                    if indexToCheck % 2 == 0{
                        indexToCheck = indexToCheck * 3 / 2
                    } else {
                        indexToCheck = (indexToCheck * 3 / 2) + 1
                    }
                } else {
                    let basicImage = UIImage(systemName: "xmark.circle.fill")
                    let imageToSet = basicImage?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
                    cell.bookShadow.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 234/255, green: 145/255, blue: 33/255, alpha: 0.4))
                    cell.addDeleteButton.setImage(imageToSet, for: .normal)
                    cell.isSelectedBook = true
                    break
                }
            }
            cell.bookImage.setImage(UIImage(data: realm.objects(AlexandriaData.self)[0].localBooks[indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count].thumbnail!.data!), for: .normal)
            cell.bookTitle.text = realm.objects(AlexandriaData.self)[0].localBooks[indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count].title
            cell.bookIndexInContext = Double(indexPath.row - realm.objects(AlexandriaData.self)[0].cloudBooks.count)
            return cell
        }
    }
    
    
}
