//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()
    var presenter: RegisterLoginViewController?
    var unloggedUser:Results<UnloggedUser>?
    let sem = DispatchSemaphore.init(value: 0)
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func updatePrevious(){
        RegisterLoginViewController.updateUser()
        sem.signal()
    }
    
    @IBAction func signUp(_ sender: Any) {
        dismiss(animated: true, completion: {RegisterLoginViewController.redirect("login", self.presenter!)})
            
    }
    
    @IBAction func logMeIn(_ sender: Any) {
        
        let request = RequestManager()
        
        if let user = username.text, let pass = password.text{
            
            if let incommingUser = request.loginUser(username: user, password: pass){
                
                NewUserManager.createNewCloudUser(username: incommingUser)
                
                updatePrevious()
                sem.wait()
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Error Loging In", message: "Wrong username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        } else {
            let alert = UIAlertController(title: "Error Loging In", message: "You must fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
 
