//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var loggedIn = false
    var controller: AuthenticationSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleSignIn.sharedInstance().delegate = AppDelegate.sharedInstance!
    }
    
    @IBAction func toRegister(_ sender: Any) {
        AppDelegate.source = "register"
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func toLogin(_ sender: Any) {
        AppDelegate.source = "logIn"
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    static func redirect (_ sender: String, _ currentController: RegisterLoginViewController){
        if sender == "login"{
            currentController.performSegue(withIdentifier: "toRegister", sender: self)
        } else if sender == "register"{
            currentController.performSegue(withIdentifier: "toLogin", sender: self)
        }
    }
    
    func updateUser(){
        RegisterLoginViewController.loggedIn = true
        controller.loggedIn = true
//        if let myShelves = controller as? MyShelvesViewController {
//            myShelves.shelfCollectionView.reloadData()
//            myShelves.shelvesList.reloadData()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegister" {
            let destination = segue.destination as! RegisterViewController
            
            destination.presenter = self
        } else if segue.identifier == "toLogin" {
            let destination = segue.destination as! LoginViewController
            
            destination.presenter = self
        }
    }
    
}

