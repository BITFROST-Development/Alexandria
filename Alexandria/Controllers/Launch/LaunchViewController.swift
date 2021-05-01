//
//  LaunchViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 8/3/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var instance = LaunchViewController()
    
    var shouldPresent = true
    
    @IBOutlet weak var logoShadow: UIView!
    @IBOutlet weak var alexandriaLogo: UIImageView!
    
    var originalSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        alexandriaLogo.alpha = 0
        alexandriaLogo.layer.cornerRadius = 30
        logoShadow.layer.cornerRadius = 30
        logoShadow.alpha = 0
        originalSize = alexandriaLogo.layer.frame.size
        if !shouldPresent{
            self.performSegue(withIdentifier: "toApp", sender: self)
        }
        UIView.animate(withDuration: 1.5, animations: {
            self.alexandriaLogo.alpha = 1.0
            self.logoShadow.alpha = 1.0
            
        }){ _ in
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.performSegue(withIdentifier: "toApp", sender: self)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !shouldPresent{
            self.performSegue(withIdentifier: "toApp", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if shouldPresent {
            UIView.animate(withDuration: 1, animations: {
                self.alexandriaLogo.layer.frame.origin.x = -1500
                self.logoShadow.layer.frame.origin.x = -1501
                self.alexandriaLogo.layer.frame.origin.y = -2500
                self.logoShadow.layer.frame.origin.y = -2501
                self.alexandriaLogo.layer.frame.size.width = self.originalSize.width + 3500
                self.logoShadow.layer.frame.size.width = self.originalSize.width + 3501
                self.alexandriaLogo.layer.frame.size.height = self.originalSize.height + 3500
                self.logoShadow.layer.frame.size.height = self.originalSize.height + 3501
                self.alexandriaLogo.alpha = 0.4
                self.shouldPresent = false
            })
        }
    }

}
