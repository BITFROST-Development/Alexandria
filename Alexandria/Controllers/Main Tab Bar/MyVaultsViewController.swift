//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyVaultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ProfileButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toRegisterLogin", sender: self)
    }
    
    @IBAction func ToSettings(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }

}

