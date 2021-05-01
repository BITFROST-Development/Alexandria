//
//  GeneralNavigationViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 9/25/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class GeneralNavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

class AlexandriaConstants {
	static let alexandriaRed = UIColor(cgColor: CGColor(red: 192/255, green: 53/255, blue: 41/255, alpha: 1))
	static let alexandriaBlue = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
	static let iconBlue = UIColor(cgColor: CGColor(red: 137/255, green: 179/255, blue: 231/255, alpha: 1))
	static let iconBlack = UIColor(cgColor: CGColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1))
	static let iconGreen = UIColor(cgColor: CGColor(red: 148/255, green: 231/255, blue: 137/255, alpha: 1))
	static let iconGrey = UIColor(cgColor: CGColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1))
	static let iconOrange = UIColor(cgColor: CGColor(red: 231/255, green: 185/255, blue: 137/255, alpha: 1))
	static let iconPink = UIColor(cgColor: CGColor(red: 231/255, green: 137/255, blue: 221/255, alpha: 1))
	static let iconPurple = UIColor(cgColor: CGColor(red: 161/255, green: 137/255, blue: 231/255, alpha: 1))
	static let iconRed = UIColor(cgColor: CGColor(red: 231/255, green: 137/255, blue: 137/255, alpha: 1))
	static let iconTurquoise = UIColor(cgColor: CGColor(red: 137/255, green: 231/255, blue: 207/255, alpha: 1))
	static let iconYellow = UIColor(cgColor: CGColor(red: 231/255, green: 225/255, blue: 137/255, alpha: 1))
}
