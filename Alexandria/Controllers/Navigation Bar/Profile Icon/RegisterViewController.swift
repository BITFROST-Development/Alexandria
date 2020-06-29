//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let sem = DispatchSemaphore.init(value: 0)
    var presenter: RegisterLoginViewController?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifiedField: UITextField!
    @IBOutlet weak var usernameIndicator: UIActivityIndicatorView!
    var agreedToTerms = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameField.delegate = self
        nameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        verifiedField.delegate = self
    }
    
    func updatePrevious(){
        RegisterLoginViewController.updateUser()
        sem.signal()
    }

    @IBAction func agreeToTerms(_ sender: Any) {
        let check = sender as! UIButton
        
        if !agreedToTerms{
            check.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            agreedToTerms = true
        } else{
            check.setImage(UIImage(systemName: "circle"), for: .normal)
            agreedToTerms = false
        }
    }
    
    @IBAction func login(_ sender: Any) {
        dismiss(animated: true, completion: {RegisterLoginViewController.redirect("register", self.presenter!)})
            
    }
    
    @IBAction func registerUser(_ sender: Any) {
        let registerRequest = RequestManager()
        
        if !agreedToTerms{
            let alert = UIAlertController(title: "You didn't accept the terms of service!", message: "You need to accept the terms if you want to register", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if passwordField.text != verifiedField.text{
            let alert = UIAlertController(title: "Error Registering", message: "Your passwords do not match, make sure to enter the same password on the password and verify password fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if let username = usernameField.text, let password = passwordField.text, let name = nameField.text, let lastName = lastNameField.text, let email = emailField.text{
            if let user = registerRequest.registerUser(username: username, password: password, name: name, last: lastName, email: email){
                
                NewUserManager.createNewCloudUser(username: user)
                
                updatePrevious()
                sem.wait()
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Error Registering", message: "A user with the given username already registered. Try with another username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "Error Registering", message: "You must fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let registerRequest = RequestManager()
        
        if textField == usernameField{
            if let userText = textField.text{
                usernameIndicator.startAnimating()
                DispatchQueue.global(qos: .background).async {
                    self.checkUser(userText: userText, registerRequest: registerRequest, textField: textField)
                }
            }
        }
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let registerRequest = RequestManager()
        
        if textField == usernameField{
            if let userText = textField.text{
                usernameIndicator.startAnimating()
                DispatchQueue.global(qos: .background).async {
                    self.checkUser(userText: userText, registerRequest: registerRequest, textField: textField)
                }
            }
        }
    }
    
    func checkUser(userText: String, registerRequest: RequestManager, textField: UITextField) {
        
        if !registerRequest.checkForUsername(username: userText){
            DispatchQueue.main.async {
                textField.resignFirstResponder()
                let alert = UIAlertController(title: "Error Registering", message: "A user with the given username already registered. Try with another username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        DispatchQueue.main.async {
            self.usernameIndicator.stopAnimating()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

