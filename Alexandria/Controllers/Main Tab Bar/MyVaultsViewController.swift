//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyVaultsViewController: AuthenticationSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
}

extension MyVaultsViewController: SocketDelegate{
    func refreshView() {
        
    }
}

