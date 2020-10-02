//
//  ColorPickerViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/22/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var pickedColor: DisplayedColor!
    var pickedColorName: String!
    var currentCell: DefaultColorCell?
    var controller: NewVaultSetViewController!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(UINib(nibName: "DefaultColorCell", bundle: nil), forCellWithReuseIdentifier: DefaultColorCell.identifier)
    }
    
    
}
