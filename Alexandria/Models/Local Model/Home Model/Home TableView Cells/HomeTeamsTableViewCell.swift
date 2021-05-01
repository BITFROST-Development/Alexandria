//
//  HomeTeamsTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class HomeTeamsTableViewCell: UITableViewCell, TeamDisplayableDelegate{
    
    static var identifier = "homeTeamsTableViewCell"
    
    var controller: TeamDisplayableControllerDelegate!
    var elementsToDisplay: [Team]?
    var alexandria: AlexandriaData?{
        get{
            return controller.realm.objects(AlexandriaData.self).first
        }
    }
    @IBOutlet weak var isEmptyView: UIView!
    @IBOutlet weak var mustRegisterView: UIView!
    @IBOutlet weak var mustAddElementView: UIView!
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var dragDropIcon: UIImageView!
    @IBOutlet weak var displayingSectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamCollectionView.register(UINib(nibName: "TeamIconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TeamIconCollectionViewCell.identifier)
        teamCollectionView.register(UINib(nibName: "TeamDirectMessageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TeamDirectMessageCollectionViewCell.identifier)
        let newPressRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cellMovementStarted(_:)))
        newPressRecognizer.delegate = self
        dragDropIcon.addGestureRecognizer(newPressRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func cellMovementStarted(_ gesture: UIPanGestureRecognizer){
        if(gesture.state == .began){
            if let homeController = controller as? HomeViewController{
                homeController.displayingTable.dragInteractionEnabled = true
            }
        } else if gesture.state == .ended || gesture.state == .changed || gesture.state == .failed{
            if let homeController = controller as? HomeViewController{
                homeController.finishedDragging.notify(queue: .main, execute: {
                    homeController.displayingTable.dragInteractionEnabled = true
                }) 
            }
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension HomeTeamsTableViewCell: UICollectionViewDelegate{
    
}

extension HomeTeamsTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (elementsToDisplay?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamDirectMessageCollectionViewCell.identifier, for: indexPath) as! TeamDirectMessageCollectionViewCell
            cell.controller = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamIconCollectionViewCell.identifier, for: indexPath) as! TeamIconCollectionViewCell
            cell.controller = self
            cell.currentTeam = elementsToDisplay![indexPath.row - 1]
            cell.teamPicture.image = UIImage(data: elementsToDisplay?[indexPath.row - 1].teamIcon?.data ?? Data())
            let username = controller.realm.objects(CloudUser.self)[0].username
            var missedNotificationCounter = 0
            for message in elementsToDisplay![indexPath.row - 1].messages{
                if message.membersAware.contains(ListWrapperForString(username)){
                    missedNotificationCounter += 1;
                }
            }
            if missedNotificationCounter > 0{
                cell.notificationView.alpha = 1
                if missedNotificationCounter < 99{
                    cell.notificationLabel.text = String(missedNotificationCounter)
                } else {
                    cell.notificationLabel.text = "+"
                }
            } else {
                cell.notificationView.alpha = 0
            }
            
            return cell
        }
    }
    
    
}

