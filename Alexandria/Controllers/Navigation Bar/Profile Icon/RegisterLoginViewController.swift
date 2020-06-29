//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {
    
    static var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toRegister(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func toLogin(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    static func redirect (_ sender: String, _ currentController: RegisterLoginViewController){
        if sender == "login"{
            currentController.performSegue(withIdentifier: "toRegister", sender: self)
        } else if sender == "register"{
            currentController.performSegue(withIdentifier: "toLogin", sender: self)
        }
    }
    
    static func updateUser(){
        loggedIn = true
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

