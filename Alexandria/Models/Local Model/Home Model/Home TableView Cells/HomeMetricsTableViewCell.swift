//
//  HomeMetricsTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class HomeMetricsTableViewCell: UITableViewCell, GoalDisplayableDelegate {

    static var identifier = "homeMetricsTableViewCell"
    
    var controller: GoalDisplayableControllerDelegate!
    var goalsToDisplay: [Goal]!
    
    @IBOutlet weak var isEmptyView: UIView!
    @IBOutlet weak var mustRegisterView: UIView!
    @IBOutlet weak var mustAddElementsView: UIView!
    @IBOutlet weak var displayingGoalsName: UILabel!
    @IBOutlet weak var dragDropIcon: UIImageView!
    @IBOutlet weak var goalCollection: UICollectionView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var goalIndicator: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goalCollection.register(UINib(nibName: "MetricsCircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MetricsCircleCollectionViewCell.identifier)
        let newPressRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cellMovementStarted(_:)))
        newPressRecognizer.delegate = self
        dragDropIcon.addGestureRecognizer(newPressRecognizer)
        goalIndicator.numberOfPages = (goalsToDisplay.count % 3 == 0) ? (goalsToDisplay.count / 3) : ((goalsToDisplay.count / 3) + 1)
        
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

extension HomeMetricsTableViewCell: UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        var countArray = Array(repeating: 0, count: goalIndicator.numberOfPages)
        for path in goalCollection.indexPathsForVisibleItems{
            countArray[(path.row / 3)] += 1
        }
        var pageWithMostVisibleCells = 0
        for page in countArray{
            if page > countArray[pageWithMostVisibleCells]{
                pageWithMostVisibleCells = page
            }
        }
        goalIndicator.currentPage = pageWithMostVisibleCells
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var countArray = Array(repeating: 0, count: goalIndicator.numberOfPages)
        for path in goalCollection.indexPathsForVisibleItems{
            countArray[(path.row / 3)] += 1
        }
        var pageWithMostVisibleCells = 0
        for page in countArray{
            if page > countArray[pageWithMostVisibleCells]{
                pageWithMostVisibleCells = page
            }
        }
        goalIndicator.currentPage = pageWithMostVisibleCells
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var countArray = Array(repeating: 0, count: goalIndicator.numberOfPages)
        for path in goalCollection.indexPathsForVisibleItems{
            countArray[(path.row / 3)] += 1
        }
        var pageWithMostVisibleCells = 0
        for page in countArray{
            if page > countArray[pageWithMostVisibleCells]{
                pageWithMostVisibleCells = page
            }
        }
        goalIndicator.currentPage = pageWithMostVisibleCells
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var countArray = Array(repeating: 0, count: goalIndicator.numberOfPages)
        for path in goalCollection.indexPathsForVisibleItems{
            countArray[(path.row / 3)] += 1
        }
        var pageWithMostVisibleCells = 0
        for page in countArray{
            if page > countArray[pageWithMostVisibleCells]{
                pageWithMostVisibleCells = page
            }
        }
        goalIndicator.currentPage = pageWithMostVisibleCells
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var countArray = Array(repeating: 0, count: goalIndicator.numberOfPages)
        for path in goalCollection.indexPathsForVisibleItems{
            countArray[(path.row / 3)] += 1
        }
        var pageWithMostVisibleCells = 0
        for page in countArray{
            if page > countArray[pageWithMostVisibleCells]{
                pageWithMostVisibleCells = page
            }
        }
        goalIndicator.currentPage = pageWithMostVisibleCells
    }
}

extension HomeMetricsTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricsCircleCollectionViewCell.identifier, for: indexPath) as! MetricsCircleCollectionViewCell
        cell.controller = self
        cell.currentGoal = goalsToDisplay[indexPath.row]
        let progressPercentage = goalsToDisplay[indexPath.row].progressList.filter("contributor = \(controller.realm.objects(CloudUser.self)[0].username)")[0].progress.value ?? 0
        cell.goalProgressBar.progress = CGFloat(progressPercentage)
        switch goalsToDisplay[indexPath.row].type {
        case "Pages":
            cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 192/255, green: 53/255, blue: 41/255, alpha: 1))
            cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 192/255, green: 53/255, blue: 41/255, alpha: 1))
            cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 192/255, green: 53/255, blue: 41/255, alpha: 1))
            cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) pages of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
            break
        case "Terms Reviewed":
            cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
            cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) terms reviewd of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
            break
		case "Terms Learned":
			cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
			cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
			cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 49/255, green: 175/255, blue: 218/255, alpha: 1))
			cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) terms learned of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
			break
        case "Hours":
            cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) hours of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
            break
        case "Minutes":
            cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 0/255, green: 230/255, blue: 58/255, alpha: 1))
            cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) minutes of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
            break
		case "Links":
			cell.goalProgressBar.color = UIColor(cgColor: CGColor(red: 147/255, green: 41/255, blue: 192/255, alpha: 1))
			cell.percentageCompleted.textColor = UIColor(cgColor: CGColor(red: 147/255, green: 41/255, blue: 192/255, alpha: 1))
			cell.preferencesChevron.tintColor = UIColor(cgColor: CGColor(red: 147/255, green: 41/255, blue: 192/255, alpha: 1))
			cell.tasksRemaining.text = "\(String(Int((goalsToDisplay[indexPath.row].valueToHit.value ?? 0) * progressPercentage))) links of \(String(Int(goalsToDisplay[indexPath.row].valueToHit.value ?? 0)))"
			break
        default:
            print("failed at picking color")
        }
        cell.goalTitle.text = goalsToDisplay[indexPath.row].name
        cell.percentageCompleted.text = "\(String(Int(progressPercentage * 100)))%"
        
        cell.sizeOfRing.constant = (self.frame.width / 3) - 30
        
        return cell
    }
    
    
}
