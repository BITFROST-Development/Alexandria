//
//  MyShelvesTableView.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/6/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

class MyShelvesTableView: UITableView {
    
    var controller: MyShelvesViewController?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func swipeDismiss(_ gesture: UIPanGestureRecognizer){
        let transition = gesture.translation(in: self.superview)
        if transition.x < 0 {
            self.layer.frame.origin.x = transition.x
            if gesture.state == .ended{
                if transition.x < (0 - self.layer.frame.width / 2) || gesture.velocity(in: controller?.view).x < 0 - 1000 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layer.frame.origin.x = 0 - self.layer.frame.width
                        self.controller?.opacityFilter.alpha = 0.0
                    })
                    controller?.shelvesListIsPresent = false
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.layer.frame.origin.x = 0.0
                    })
                }
            } else if gesture.state == .cancelled{
                UIView.animate(withDuration: 0.1, animations: {
                    self.layer.frame.origin.x = 0.0
                })
            }
        }
    }


}

extension MyShelvesTableView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
}
