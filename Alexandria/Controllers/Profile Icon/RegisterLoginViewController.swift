//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ToRegister(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func ToLogin(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
}

