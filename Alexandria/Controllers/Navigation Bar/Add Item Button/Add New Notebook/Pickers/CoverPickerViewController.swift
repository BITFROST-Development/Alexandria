//
//  CoverPickerViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/25/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class CoverPickerViewController: UIViewController, NewNotebookPickerDelegate, NotebookImageStyle {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var controller: NewNotebookViewController!
    var selectedCellImage: Int!
    var selectedCell: ClassCollectionViewCell?
    var selectedGroup: String!
    var currentCategory = ""
    var dispatchGroup = DispatchGroup()
    var continueChecking = true
    var collectionSize: Int!{
        get{
            switch currentCategory {
            case "Plain":
                return 13
            case "Circles":
                return 10
            case "Cubes":
                return 10
            case "Flowers":
                return 10
            case "Patterns":
                return 11
            case "Tech":
                return 10
            case "Textures":
                return 12
            default:
                return 0
            }
        }
    }
    let imageCache = NSCache<NSString, ImageCache>()
    private var plainArray = [UIImage(named: "notebookPlain01")!, UIImage(named: "notebookPlain02")!, UIImage(named: "notebookPlain03")!, UIImage(named: "notebookPlain04")!, UIImage(named: "notebookPlain05")!, UIImage(named: "notebookPlain06")!, UIImage(named: "notebookPlain07")!, UIImage(named: "notebookPlain08")!, UIImage(named: "notebookPlain09")!, UIImage(named: "notebookPlain10")!, UIImage(named: "notebookPlain11")!, UIImage(named: "notebookPlain12")!, UIImage(named: "notebookPlain13")!]
    private var circlesArray = [UIImage(named: "notebookCircles01")!, UIImage(named: "notebookCircles02")!, UIImage(named: "notebookCircles03")!, UIImage(named: "notebookCircles04")!, UIImage(named: "notebookCircles05")!, UIImage(named: "notebookCircles06")!, UIImage(named: "notebookCircles07")!, UIImage(named: "notebookCircles08")!, UIImage(named: "notebookCircles09")!, UIImage(named: "notebookCircles10")!]
    private var cubesArray = [UIImage(named: "notebookCubes01")!, UIImage(named: "notebookCubes02")!, UIImage(named: "notebookCubes03")!, UIImage(named: "notebookCubes04")!, UIImage(named: "notebookCubes05")!, UIImage(named: "notebookCubes06")!, UIImage(named: "notebookCubes07")!, UIImage(named: "notebookCubes08")!, UIImage(named: "notebookCubes09")!, UIImage(named: "notebookCubes10")!]
    private var flowersArray = [UIImage(named: "notebookFlowers01")!, UIImage(named: "notebookFlowers02")!, UIImage(named: "notebookFlowers03")!, UIImage(named: "notebookFlowers04")!, UIImage(named: "notebookFlowers05")!, UIImage(named: "notebookFlowers06")!, UIImage(named: "notebookFlowers07")!, UIImage(named: "notebookFlowers08")!, UIImage(named: "notebookFlowers09")!, UIImage(named: "notebookFlowers10")!]
    private var patternsArray = [UIImage(named: "notebookPatterns01")!, UIImage(named: "notebookPatterns02")!, UIImage(named: "notebookPatterns03")!, UIImage(named: "notebookPatterns04")!, UIImage(named: "notebookPatterns05")!, UIImage(named: "notebookPatterns06")!, UIImage(named: "notebookPatterns07")!, UIImage(named: "notebookPatterns08")!, UIImage(named: "notebookPatterns09")!, UIImage(named: "notebookPatterns01")!, UIImage(named: "notebookPatterns10")!, UIImage(named: "notebookPatterns11")!]
    private var techArray = [UIImage(named: "notebookTech01")!, UIImage(named: "notebookTech02")!, UIImage(named: "notebookTech03")!, UIImage(named: "notebookTech04")!, UIImage(named: "notebookTech05")!, UIImage(named: "notebookTech06")!, UIImage(named: "notebookTech07")!, UIImage(named: "notebookTech08")!, UIImage(named: "notebookTech09")!, UIImage(named: "notebookTech10")!]
    private var texturesArray = [UIImage(named: "notebookTextures01")!, UIImage(named: "notebookTextures02")!, UIImage(named: "notebookTextures03")!, UIImage(named: "notebookTextures04")!, UIImage(named: "notebookTextures05")!, UIImage(named: "notebookTextures06")!, UIImage(named: "notebookTextures07")!, UIImage(named: "notebookTextures08")!, UIImage(named: "notebookTextures09")!, UIImage(named: "notebookTextures10")!, UIImage(named: "notebookTextures11")!, UIImage(named: "notebookTextures12")!]
    var imagePicker: Bool{
        get{return true}
        set{
            imagesToDisplay = imageCache.object(forKey: NSString(string: currentCategory))?.array ?? []
        }
    }
    var imagesToDisplay: [UIImage] = []
    let realm = AppDelegate.realm
    @IBOutlet weak var styleTable: UITableView!
    @IBOutlet weak var styleCollection: UICollectionView!
    @IBOutlet weak var backCancelButton: UIButton!
    @IBOutlet weak var edgeConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        styleTable.register(UINib(nibName: "ClassTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ClassTitleTableViewCell.identifier)
        styleTable.register(UINib(nibName: "ClassCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: ClassCollectionTableViewCell.identifier)
        styleTable.register(UINib(nibName: "ClassViewTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ClassViewTitleTableViewCell.identifier)
        styleTable.delegate = self
        styleTable.dataSource = self
        styleCollection.layer.frame.origin.x = view.layer.frame.width
        styleCollection.dataSource = self
        styleCollection.register(UINib(nibName: "ClassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
        styleTable.layer.frame.origin.x = 0
        styleCollection.layer.frame.origin.x = view.layer.frame.width
        imageCache.setObject(ImageCache(givenArray: texturesArray), forKey: "Textures")
        imageCache.setObject(ImageCache(givenArray: plainArray), forKey: "Plain")
        imageCache.setObject(ImageCache(givenArray: circlesArray), forKey: "Circles")
        imageCache.setObject(ImageCache(givenArray: cubesArray), forKey: "Cubes")
        imageCache.setObject(ImageCache(givenArray: flowersArray), forKey: "Flowers")
        imageCache.setObject(ImageCache(givenArray: patternsArray), forKey: "Patterns")
        imageCache.setObject(ImageCache(givenArray: techArray), forKey: "Tech")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        continueChecking = true
        dispatchGroup.notify(queue: .main, execute: {
            self.currentCategory = "Plain"
            self.imagePicker = true
            self.styleCollection.reloadData()
        })
    }
    
    func reloadView(){
        styleCollection.reloadData()
    }

    @IBAction func dismissView(_ sender: Any) {
        if backCancelButton.titleLabel?.text == "Cancel"{
            self.dismiss(animated: true, completion: nil)
        } else {
            currentCategory = ""
            continueChecking = true
            imagePicker = false
            UIView.animate(withDuration: 0.5, animations: {
                self.styleCollection.layer.frame.origin.x = self.view.layer.frame.width
                self.styleTable.layer.frame.origin.x = 0
            }){ _ in
                self.styleCollection.reloadData()
                self.backCancelButton.setTitle("Cancel", for: .normal)
            }
        }
    }
    
    @IBAction func commitChoice(_ sender: Any) {
        var newSelection = ""
        var newImage: UIImage!
        switch selectedGroup {
        case "Plain":
            newImage = plainArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookPlain0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookPlain\(String(selectedCellImage + 1))"
            }
        case "Circles":
            newImage = circlesArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookCircles0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookCircles\(String(selectedCellImage + 1))"
            }
        case "Cubes":
            newImage = cubesArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookCubes0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookCubes\(String(selectedCellImage + 1))"
            }
        case "Flowers":
            newImage = flowersArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookFlowers0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookFlowers\(String(selectedCellImage + 1))"
            }
        case "Patterns":
            newImage = patternsArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookPatterns0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookPatterns\(String(selectedCellImage + 1))"
            }
        case "Tech":
            newImage = techArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookTech0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookTech\(String(selectedCellImage + 1))"
            }
        case "Textures":
            newImage = texturesArray[selectedCellImage]
            if selectedCellImage < 9 {
                newSelection = "notebookTextures0\(String(selectedCellImage + 1))"
            } else {
                newSelection = "notebookTextures\(String(selectedCellImage + 1))"
            }
        default:
            print("error")
        }
        controller.selectedCoverName = newSelection
        controller.tableView.beginUpdates()
        (controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NewNotebookThumbnail).fileThumbnail.image = newImage
        controller.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        controller.tableView.endUpdates()
        dismiss(animated: true, completion: nil)
    }
}

extension CoverPickerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0{
            let cell = tableView.cellForRow(at: indexPath) as! ClassTitleTableViewCell
            currentCategory = cell.sectionTitle.text!
            continueChecking = true
            imagePicker = true
            styleCollection.reloadData()
            self.backCancelButton.titleLabel?.text = "Back"
            dispatchGroup.notify(queue: .main, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.styleTable.layer.frame.origin.x = 0 - self.view.layer.frame.width
                    self.styleCollection.layer.frame.origin.x = 0
                    tableView.deselectRow(at: indexPath, animated: true)
                })
            })
        }
    }
}

extension CoverPickerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassViewTitleTableViewCell.identifier)
            return cell!
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Plain"
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Circles"
            return cell
        } else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Cubes"
            return cell
        } else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Flowers"
            return cell
        } else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Patterns"
            return cell
        } else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Tech"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassTitleTableViewCell.identifier) as! ClassTitleTableViewCell
            cell.sectionTitle.text = "Textures"
            return cell
        }
    }
}


extension CoverPickerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for _ in 0..<collectionSize{
            dispatchGroup.enter()
        }
        return collectionSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryTitle", for: indexPath) as? CategorySectionTitle{
            header.category.text = currentCategory
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCollectionViewCell.identifier, for: indexPath) as! ClassCollectionViewCell
        cell.itemImage.image = imagesToDisplay[indexPath.row]
        cell.controller = self
        cell.currentCell = indexPath.row
        cell.paperName.alpha = 0
        cell.currentGroup = currentCategory
        cell.backgroundSelectedView.layer.cornerRadius = 8
        cell.backgroundSelectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        if continueChecking {
            dispatchGroup.leave()
        }
        if collectionSize - indexPath.row == 1 {
            continueChecking = false
        }
        if currentCategory == selectedGroup && selectedCellImage == indexPath.row{
            cell.backgroundSelectedView.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 224/255, green: 80/255, blue: 51/255, alpha: 0.7))
            DispatchQueue.main.async {
                self.selectedCell = cell
            }
        } else {
            cell.backgroundSelectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
        }
        
        return cell
    }
}

class CategorySectionTitle: UICollectionReusableView{
    @IBOutlet weak var category: UILabel!
}

class ImageCache {
    var array: [UIImage]!
    
    init(givenArray: [UIImage]){
        array = givenArray
    }
}

