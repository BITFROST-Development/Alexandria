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
    var swipingTable = false
    
    @objc func swipeDismiss(_ gesture: UIPanGestureRecognizer){
        if !swipingTable && gesture.direction?.isHorizontal != nil && gesture.direction!.isHorizontal {
            swipingTable = true
            controller?.shelvesList.panGestureRecognizer.state = .cancelled
        }
        
        if swipingTable {
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
                    } else if UIDevice.current.userInterfaceIdiom == .phone && (transition.x < (0 - self.layer.frame.width / 4) || gesture.velocity(in: controller?.view).x < 0 - 1000) {
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
                    swipingTable = false
                } else if gesture.state == .cancelled || gesture.state == .failed{
                    UIView.animate(withDuration: 0.1, animations: {
                        self.layer.frame.origin.x = 0.0
                    })
                    swipingTable = false
                }
            }
        } else {
            gesture.state = .cancelled
        }
    }
    
    @objc func swipePresent(_ gesture:UIScreenEdgePanGestureRecognizer){
        if !swipingTable && gesture.direction?.isHorizontal != nil && gesture.direction!.isHorizontal {
            swipingTable = true
            controller?.shelvesList.panGestureRecognizer.state = .cancelled
        }
        
        if swipingTable {
            let transition = gesture.translation(in: controller?.view)
            if transition.x < (0 + self.layer.frame.width) {
                self.layer.frame.origin.x = transition.x - self.layer.frame.width
                if gesture.state == .ended {
                    if transition.x > (0 + self.layer.frame.width / 2) || gesture.velocity(in: controller?.view).x > 1000{
                        UIView.animate(withDuration: 0.3, animations: {
                            self.layer.frame.origin.x = 0.0
                            self.controller?.opacityFilter.alpha = 1.0
                        })
                        controller?.shelvesListIsPresent = true
                    }
                    else if UIDevice.current.userInterfaceIdiom == .phone && (transition.x > (0 + self.layer.frame.width / 4) || gesture.velocity(in: controller?.view).x > 1000){
                        UIView.animate(withDuration: 0.3, animations: {
                            self.layer.frame.origin.x = 0.0
                            self.controller?.opacityFilter.alpha = 1.0
                        })
                        controller?.shelvesListIsPresent = true
                    } else{
                        UIView.animate(withDuration: 0.3, animations: {
                            self.layer.frame.origin.x = 0 - self.layer.frame.width
                        })
                    }
                    swipingTable = false
                } else if gesture.state == .cancelled || gesture.state == .failed{
                    UIView.animate(withDuration: 0.1, animations: {
                        self.layer.frame.origin.x = 0 - self.layer.frame.width
                    })
                    swipingTable = false
                }
            }
        } else {
            gesture.state = .cancelled
        }
    }


}

extension MyShelvesTableView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


public enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}

public extension UIPanGestureRecognizer {

   var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }

}
