//
//  AddFileCheckBoxes.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class AddItemCheckBoxes: UITableViewCell {

    static var identifier = "addItemCheckBoxes"
    var isChecked = false
    var controller: AddItemViewController!
    var shouldCheckStatus = true
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var checkCircle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(self.layer.frame.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        if shouldCheckStatus {
            if !isChecked {
                UIView.animate(withDuration: 0.1, animations: {
                    self.checkCircle.tintColor = UIColor(cgColor: CGColor(srgbRed: 192/255, green: 53/255, blue: 41/255, alpha: 1))
                })
                UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.checkCircle.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
                }, completion: nil)
                isChecked = true
                if optionName.text == "Store in cloud"{
                    controller.toDrive = true
                } else if optionName.text == "Local copy"{
                    controller.toLocal = true
                } else if optionName.text == "Pin to home tab"{
                    controller.isPinned = true
                } else if optionName.text == "Favorite" {
                    controller.isFavorite = true
                }
            } else {
                
                if optionName.text == "Store in cloud" {
                    if controller.isEditingItem {
                        let alert = UIAlertController(title: "Removing Cloud File", message: "You're currently removing the cloud copy of this file!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: {_ in
                            UIView.animate(withDuration: 0.1, animations: {
                                self.checkCircle.tintColor = .lightGray
                            })
                            UIView.transition(with: self.checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
                            }, completion: nil)
                            self.controller.toDrive = false
                            self.isChecked = false
                        }))
                        controller.present(alert, animated: true)
                    } else {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.checkCircle.tintColor = .lightGray
                        })
                        UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
                        }, completion: nil)
                        isChecked = false
                        controller.toDrive = false
						controller.teams = []
						controller.displayingView.reloadData()
                    }
                } else if optionName.text == "Local copy" {
                    if controller.isEditingItem {
                        let alert = UIAlertController(title: "Removing Local File", message: "You're currently removing the local copy of this file!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: {_ in
                            UIView.animate(withDuration: 0.1, animations: {
                                self.checkCircle.tintColor = .lightGray
                            })
                            UIView.transition(with: self.checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
                            }, completion: nil)
                            self.controller.toLocal = false
                            self.isChecked = false
                        }))
                        controller.present(alert, animated: true)
                    } else {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.checkCircle.tintColor = .lightGray
                        })
                        UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
                        }, completion: nil)
                        isChecked = false
                        controller.toLocal = false
                    }
				} else if optionName.text == "Pin to home tab"{
					if controller.isEditingItem{
						
					} else {
						UIView.animate(withDuration: 0.1, animations: {
							self.checkCircle.tintColor = .lightGray
						})
						UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
							self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
						}, completion: nil)
						isChecked = false
						controller.isPinned = false
					}
				} else if optionName.text == "Favorite" {
					if controller.isEditingItem{
						
					} else {
						UIView.animate(withDuration: 0.1, animations: {
							self.checkCircle.tintColor = .lightGray
						})
						UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
							self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
						}, completion: nil)
						isChecked = false
						controller.isFavorite = false
					}
				}
            }
        }
    }
}


//if optionName.text == "Store in Google Drive"{
//    if controller.isEditingItem {
//        let alert = UIAlertController(title: "Removing Cloud File", message: "You're currently removing the cloud copy of this file!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: {_ in
//            UIView.animate(withDuration: 0.1, animations: {
//                self.checkCircle.tintColor = .lightGray
//            })
//            UIView.transition(with: self.checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
//            }, completion: nil)
//            self.controller.toDrive = false
//            self.isChecked = false
//        }))
//        controller.present(alert, animated: true)
//    } else {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.checkCircle.tintColor = .lightGray
//        })
//        UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
//        }, completion: nil)
//        isChecked = false
//        controller.toDrive = false
//    }
//} else if optionName.text == "Local Copy"{
//    if controller.isEditingItem {
//        let alert = UIAlertController(title: "Removing Local File", message: "You're currently removing the local copy of this file!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: {_ in
//            UIView.animate(withDuration: 0.1, animations: {
//                self.checkCircle.tintColor = .lightGray
//            })
//            UIView.transition(with: self.checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
//            }, completion: nil)
//            self.controller.toLocal = false
//            self.isChecked = false
//        }))
//        controller.present(alert, animated: true)
//    } else {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.checkCircle.tintColor = .lightGray
//        })
//        UIView.transition(with: checkCircle.imageView!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
//        }, completion: nil)
//        isChecked = false
//        controller.toLocal = false
//    }
//} else
