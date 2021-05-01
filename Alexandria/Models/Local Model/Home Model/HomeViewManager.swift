//
//  HomeViewManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

extension HomeViewController{
    func prepareTableView(){
        displayingTable.dragInteractionEnabled = true
        displayingTable.dragDelegate = self
        displayingTable.dropDelegate = self
        displayingTable.register(UINib(nibName: "HomeTeamsTableViewCell", bundle: nil), forCellReuseIdentifier: HomeTeamsTableViewCell.identifier)
        displayingTable.register(UINib(nibName: "HomeMetricsTableViewCell", bundle: nil), forCellReuseIdentifier: HomeMetricsTableViewCell.identifier)
        displayingTable.register(UINib(nibName: "HomeFileDisplayableTableViewCell", bundle: nil), forCellReuseIdentifier: HomeFileDisplayableTableViewCell.identifier)
        displayingTable.delegate = self
        displayingTable.dataSource = self
    }
	
	func openItem(_ item: DocumentItem){
		if let fileItem = item as? FileItem{
			selectedFileItem = fileItem
			performSegue(withIdentifier: "toEditingView", sender: self)
		}
	}
    
}

extension HomeViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        for cell in displayingTable.visibleCells{
            if let fileCell = cell as? HomeFileDisplayableTableViewCell{
                if touch.view?.isDescendant(of: fileCell.sortingTable) ?? true{
                    return false
                } else if touch.view?.isDescendant(of: addItemView) ?? true{
                    return false
                }
            }
        }
        
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellsToDisplay[indexPath.row].type == "Documents"{
			if cellsToDisplay[indexPath.row].name == "Favorites"{
				var documentItemGathering: [FolderItem] = []
				documentItemGathering = Array(realm.objects(Folder.self).filter("isFavorite = 'True'"))
				documentItemGathering.append(contentsOf: Array(realm.objects(Book.self).filter("isFavorite = 'True'")))
				documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self).filter("isFavorite = 'True'")))
				documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self).filter("isFavorite = 'True'")))
				if documentItemGathering.count > 0{
					return ((documentItemGathering.count * 163) > (Int(self.view.frame.width) - 20)) ? 612 : 331
				} else {
					return 200
				}
			} else if cellsToDisplay[indexPath.row].name == "Recents"{
				var documentItemGathering: [FileItem] = []
				documentItemGathering = Array(realm.objects(Book.self))
				documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self)))
				documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self)))
				if documentItemGathering.count > 0{
					return ((documentItemGathering.count * 163) > (Int(self.view.frame.width) - 20)) ? 612 : 331
				} else {
					return 200
				}
			} else {
				let pinnedCollection: FileCollection? = realm.objects(FileCollection.self).filter("personalID = '\(cellsToDisplay[indexPath.row].name!)'").first
				if pinnedCollection == nil{
					let pinnedFolder: Folder! = realm.objects(Folder.self).filter("personalID = '\(cellsToDisplay[indexPath.row].name!)'").first!
					if pinnedFolder.childrenIDs.count > 0{
						return ((pinnedFolder.childrenIDs.count * 163) > (Int(self.view.frame.width) - 20)) ? 612 : 331
					} else {
						return 200
					}
				} else {
					if pinnedCollection!.childrenIDs.count > 0{
						return ((pinnedCollection!.childrenIDs.count * 163) > (Int(self.view.frame.width) - 20)) ? 612 : 331
					} else {
						return 200
					}
				}
			}
        } else if cellsToDisplay[indexPath.row].type == "Team"{
            return 152
        } else if cellsToDisplay[indexPath.row].type == "Metrics"{
            return (self.view.frame.width / 3) - 86
        }
        return UITableView.automaticDimension
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellsToDisplay[indexPath.row].type == "Team"{
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTeamsTableViewCell.identifier, for: indexPath) as! HomeTeamsTableViewCell
            cell.controller = self
            cell.isEmptyView.alpha = 0
            cell.mustRegisterView.alpha = 0
            cell.mustAddElementView.alpha = 0
            var teams: [Team] = []
            var shouldDisplayMustAddElement = true
            if cellsToDisplay[indexPath.row].name == "Favorites"{
                cell.displayingSectionName.text = "Favorite teams"
                teams = Array(realm.objects(Team.self).filter("isFavorite = \(cellsToDisplay[indexPath.row].name ?? "")"))
            } else if loggedIn{
                cell.displayingSectionName.text = "Recent teams"
                for team in realm.objects(Team.self){
                    if team.messages.filter({($0).membersAware.contains(
                        self.realm.objects(ListWrapperForString.self)
                            .filter("value = \(self.realm.objects(CloudUser.self)[0].username)")[0])
                    }).count > 0{
                        teams.append(team)
                    }
                }
            } else {
                shouldDisplayMustAddElement = false
                cell.isEmptyView.alpha = 1
                cell.mustRegisterView.alpha = 1
            }
            cell.elementsToDisplay = teams
            if teams.count == 0 && shouldDisplayMustAddElement{
                cell.isEmptyView.alpha = 1
                cell.mustAddElementView.alpha = 1
            }
            if indexPath.row == cellsToDisplay.count - 1{
                cell.separator.alpha = 0
            }
            return cell
        } else if cellsToDisplay[indexPath.row].type == "Metrics"{
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeMetricsTableViewCell.identifier, for: indexPath) as! HomeMetricsTableViewCell
            cell.controller = self
            cell.isEmptyView.alpha = 0
            cell.mustRegisterView.alpha = 0
            cell.mustAddElementsView.alpha = 0
            if cellsToDisplay[indexPath.row].name == "All Today"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter("period = 'Daily'"))
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
                cell.displayingGoalsName.text = "Today's goals"
            } else if cellsToDisplay[indexPath.row].name == "All Week"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter("period = 'Weekly'"))
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
                cell.displayingGoalsName.text = "This weeks's goals"
            } else if cellsToDisplay[indexPath.row].name == "All Month"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter("period = 'Monthly'"))
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
                cell.displayingGoalsName.text = "This month's goals"
            } else if cellsToDisplay[indexPath.row].name == "Shared Today"{
                if loggedIn {
                    cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count > 1}).filter({($0).period == "Daily"}))
                } else {
                    cell.isEmptyView.alpha = 1
                    cell.mustRegisterView.alpha = 1
                    cell.goalsToDisplay = []
                }
                cell.displayingGoalsName.text = "Today's shared goals"
            } else if cellsToDisplay[indexPath.row].name == "Shared Week"{
                if loggedIn {
                    cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count > 1}).filter({($0).period == "Weekly"}))
                } else {
                    cell.isEmptyView.alpha = 1
                    cell.mustRegisterView.alpha = 1
                    cell.goalsToDisplay = []
                }
                cell.displayingGoalsName.text = "This week's shared goals"
            } else if cellsToDisplay[indexPath.row].name == "Shared Month"{
                if loggedIn {
                    cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count > 1}).filter({($0).period == "Monthly"}))
                } else {
                    cell.isEmptyView.alpha = 1
                    cell.mustRegisterView.alpha = 1
                    cell.goalsToDisplay = []
                }
                cell.displayingGoalsName.text = "This month's shared Goals"
            } else if cellsToDisplay[indexPath.row].name == "Own Today"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count == 1}).filter({($0).period == "Daily"}))
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
                cell.displayingGoalsName.text = "Today's personal goals"
            } else if cellsToDisplay[indexPath.row].name == "Own Week"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count == 1}).filter({($0).period == "Weekly"}))
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
                cell.displayingGoalsName.text = "This week's personal goals"
            } else if cellsToDisplay[indexPath.row].name == "Own Month"{
                cell.goalsToDisplay = Array(realm.objects(Goal.self).filter({($0).progressList.count == 1}).filter({($0).period == "Monthly"}))
                cell.displayingGoalsName.text = "This month's personal goals"
                if cell.goalsToDisplay.count == 0 {
                    cell.isEmptyView.alpha = 1
                    cell.mustAddElementsView.alpha = 1
                }
            }
            
            if indexPath.row == cellsToDisplay.count - 1{
                cell.separator.alpha = 0
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeFileDisplayableTableViewCell.identifier, for: indexPath) as! HomeFileDisplayableTableViewCell
            cell.controller = self
            cell.isEmptyView.alpha = 0
            cell.messageView.alpha = 0
            cell.currentHomeItem = cellsToDisplay[indexPath.row]
            if cellsToDisplay[indexPath.row].name == "Favorites"{
                var documentItemGathering: [FolderItem] = []
                documentItemGathering = Array(realm.objects(Folder.self).filter("isFavorite = 'True'"))
                documentItemGathering.append(contentsOf: Array(realm.objects(Book.self).filter("isFavorite = 'True'")))
                documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self).filter("isFavorite = 'True'")))
                documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self).filter("isFavorite = 'True'")))
                switch cellsToDisplay[indexPath.row].sorting {
                case "Ascending":
					documentItemGathering.sort(by: {($0).name!.lowercased() < ($1).name!.lowercased()})
					break
                case "Descending":
                    documentItemGathering.sort(by: {($0).name!.lowercased() > ($1).name!.lowercased()})
					break
                case "Last Modified":
                    documentItemGathering.sort(by: {($0).lastModified! > ($1).lastModified!})
					break
                case "Last Opened":
					documentItemGathering.sort(by: {(($0) as? FileItem != nil) ? (((($1) as? FileItem) != nil) ? ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ($1).lastModified!) : (((($1) as? FileItem) != nil) ? ($0) .lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ($0).lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!))})
					break
                default:
                    print("error in sorting")
                }
                let maxShowableAmount = ((Int(self.view.frame.width) - 20)/80)
                cell.displayableItems = Array(documentItemGathering[0..<((documentItemGathering.count > maxShowableAmount) ? maxShowableAmount : documentItemGathering.count)])
                if documentItemGathering.count <= maxShowableAmount {
                    cell.moreLabelName.alpha = 0
                }
                cell.displayingSectionName.text = "Favorites"
            } else if cellsToDisplay[indexPath.row].name == "Recents"{
                var documentItemGathering: [FileItem] = []
                documentItemGathering = Array(realm.objects(Book.self))
                documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self)))
                documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self)))
                documentItemGathering.sort(by: {(($0).lastOpened ?? ($0).lastModified!) > (($1).lastOpened ?? ($1).lastModified!)})
				let maxShowableAmount = ((Int(self.view.frame.width) - 20)/80)
                cell.displayableItems = Array(documentItemGathering[0..<((documentItemGathering.count > maxShowableAmount) ? maxShowableAmount : documentItemGathering.count)])
                if documentItemGathering.count <= maxShowableAmount {
                    cell.moreLabelName.alpha = 0
                }
                switch cellsToDisplay[indexPath.row].sorting {
                case "Ascending":
                    cell.displayableItems.sort(by: {(($0) as! FolderItem).name!.lowercased() > (($1) as! FolderItem).name!.lowercased()})
					break
                case "Descending":
                    cell.displayableItems.sort(by: {(($0) as! FolderItem).name!.lowercased() < (($1) as! FolderItem).name!.lowercased()})
					break
                case "Last Modified":
                    cell.displayableItems.sort(by: {(($0) as! FolderItem).lastModified! > (($1) as! FolderItem).lastModified!})
					break
                case "Last Opened":
					documentItemGathering.sort(by: {($0.lastOpened ?? $0.lastModified!) > ($1.lastOpened ?? $1.lastModified!)})
					break
                default:
                    print("error in sorting")
                }
                cell.displayingSectionName.text = "Recent documents"
            } else {
                var pinnedElement: DocumentItem? = realm.objects(FileCollection.self).filter("personalID = '\(cellsToDisplay[indexPath.row].name!)'").first
                var documentItemGathering: [FolderItem] = []
                if pinnedElement == nil{
                    pinnedElement = realm.objects(Folder.self).filter("personalID = '\(cellsToDisplay[indexPath.row].name!)'").first
                    documentItemGathering = Array(realm.objects(Folder.self).filter("parentID = '\(pinnedElement?.personalID ?? "")'"))
                    documentItemGathering.append(contentsOf: Array(realm.objects(Book.self).filter("parentID = '\(pinnedElement?.personalID ?? "")'")))
                    documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self).filter("parentID = '\(pinnedElement?.personalID ?? "")'")))
                    documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self).filter("parentID = '\(pinnedElement?.personalID ?? "")'")))
                    switch cellsToDisplay[indexPath.row].sorting {
                    case "Ascending":
                        documentItemGathering.sort(by: {($0).name!.lowercased() > ($1).name!.lowercased()})
						break
                    case "Descending":
                        documentItemGathering.sort(by: {($0).name!.lowercased() < ($1).name!.lowercased()})
						break
                    case "Last Modified":
                        documentItemGathering.sort(by: {($0).lastModified! > ($1).lastModified!})
						break
                    case "Last Opened":
						documentItemGathering.sort(by: {(($0) as? FileItem != nil) ? (((($1) as? FileItem) != nil) ? ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ($1).lastModified!) : (((($1) as? FileItem) != nil) ? ($0) .lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ($0).lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!))})
						break
                    default:
                        print("error in sorting")
                    }
                    
                } else {
                    for id in (pinnedElement as! FileCollection).childrenIDs{
                        documentItemGathering.append(contentsOf: Array(realm.objects(Book.self).filter("personalID = '\(id.value ?? "")'")))
                        documentItemGathering.append(contentsOf: Array(realm.objects(Notebook.self).filter("personalID = '\(id.value ?? "")'")))
                        documentItemGathering.append(contentsOf: Array(realm.objects(TermSet.self).filter("personalID = '\(id.value ?? "")'")))
                    }
                    switch cellsToDisplay[indexPath.row].sorting {
                    case "Ascending":
                        documentItemGathering.sort(by: {($0).name!.lowercased() > ($1).name!.lowercased()})
						break
                    case "Descending":
                        documentItemGathering.sort(by: {($0).name!.lowercased() < ($1).name!.lowercased()})
						break
                    case "Last Modified":
                        documentItemGathering.sort(by: {($0).lastModified! > ($1).lastModified!})
						break
                    case "Last Opened":
						documentItemGathering.sort(by: {(($0) as? FileItem != nil) ? (((($1) as? FileItem) != nil) ? ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ((($0) as! FileItem).lastOpened ?? $0.lastModified!) > ($1).lastModified!) : (((($1) as? FileItem) != nil) ? ($0) .lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!) : ($0).lastModified! > ((($1) as! FileItem).lastOpened ?? $1.lastModified!))})
						break
                    default:
                        print("error in sorting")
                    }
                }
				let maxShowableAmount = ((Int(self.view.frame.width) - 20)/80)
                cell.displayableItems = Array(documentItemGathering[0..<((documentItemGathering.count > maxShowableAmount) ? maxShowableAmount : documentItemGathering.count)])
                if documentItemGathering.count <= maxShowableAmount {
                    cell.moreLabelName.alpha = 0
                }
                cell.displayingSectionName.text = "\(pinnedElement?.name ?? "")"
                
            }
            if cell.displayableItems.count == 0{
                cell.isEmptyView.alpha = 1
                cell.messageView.alpha = 1
            }
//            print("Wrapping up cell data source")
            return cell
        }
    }
    
}

extension HomeViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        finishedDragging.enter()
        let stringItemProvider = NSItemProvider(object: self.cellsToDisplay[indexPath.row].name! as NSString)
        let dragItem = UIDragItem(itemProvider: stringItemProvider)
        dragItem.previewProvider = {
            let cell = tableView.cellForRow(at: indexPath)!
            let preview = cell.contentView
            preview.frame = cell.contentView.frame
            return UIDragPreview(view: preview)
        }
        return [dragItem]
    }
    
    
}

extension HomeViewController: UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
            let dragItem = coordinator.items.first?.dragItem,
            let item = dragItem.localObject as? String,
            let sourceIndexPath = coordinator.items.first?.sourceIndexPath else {
                return
        }

        tableView.performBatchUpdates({
            do{
                try realm.write({
                    let stringWrapper = realm.objects(HomeItem.self).filter("name == '\(item)'")[0]
                    self.cellsToDisplay.remove(at: sourceIndexPath.row)
                    self.cellsToDisplay.insert(stringWrapper, at: destinationIndexPath.row)
                })
            } catch let error {
                print(error.localizedDescription)
            }
            

            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .none)
        })

        coordinator.drop(dragItem, toRowAt: destinationIndexPath)
        finishedDragging.leave()
    }
}
