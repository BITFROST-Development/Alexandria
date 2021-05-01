//
//  AddItemPickerCarusselTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemPickerCarouselTableViewCell: UITableViewCell {

	static var identifier = "addItemPickerCarouselTableViewCell"
	
	var controller: AddItemPickerSubviewController!
	var currentCarouselContent: [CarouselItem]!
	
	@IBOutlet weak var sectionTitle: UILabel!
	@IBOutlet weak var sectionCollectionView: UICollectionView!
	@IBOutlet weak var separatorView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		sectionCollectionView.delegate = self
		sectionCollectionView.dataSource = self
		sectionCollectionView.register(UINib(nibName: "AddItemPickerCarouselItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AddItemPickerCarouselItemCollectionViewCell.identifier)
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}

extension AddItemPickerCarouselTableViewCell: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return currentCarouselContent.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemPickerCarouselItemCollectionViewCell.identifier, for: indexPath) as! AddItemPickerCarouselItemCollectionViewCell
		cell.controller = controller
		if controller.controller.displayedOrientation == "Portrait"{
			if controller.pickerItem.pickerDetails == "Notebook Cover"{
				cell.itemBackgroundView.widthAnchor.constraint(equalToConstant: 127.59).isActive = true
				cell.itemBackgroundView.heightAnchor.constraint(equalToConstant: 160).isActive = true
			} else if controller.pickerItem.pickerDetails == "Notebook Paper"{
				cell.itemBackgroundView.widthAnchor.constraint(equalToConstant: 126).isActive = true
				cell.itemBackgroundView.heightAnchor.constraint(equalToConstant: 160).isActive = true
			}
		} else {
			if controller.pickerItem.pickerDetails == "Notebook Cover"{
				cell.itemBackgroundView.widthAnchor.constraint(equalToConstant: 160).isActive = true
				cell.itemBackgroundView.heightAnchor.constraint(equalToConstant: 127.59).isActive = true
			} else if controller.pickerItem.pickerDetails == "Notebook Paper"{
				cell.itemBackgroundView.widthAnchor.constraint(equalToConstant: 160).isActive = true
				cell.itemBackgroundView.heightAnchor.constraint(equalToConstant: 126).isActive = true
			}
			
		}
		cell.currentCell = currentCarouselContent[indexPath.row]
		cell.itemImage.image = currentCarouselContent[indexPath.row].image
		cell.itemTitle.text = currentCarouselContent[indexPath.row].itemTitle
		if controller.pickedCarousels.contains(where: {$0.imageName == currentCarouselContent[indexPath.row].imageName}){
			cell.itemBackgroundView.backgroundColor = AlexandriaConstants.alexandriaRed
			controller.pickedCarouselCells.append(cell)
		} else {
			cell.itemBackgroundView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.08))
		}
		
		return cell
	}
	
	
}

extension AddItemPickerCarouselTableViewCell: UICollectionViewDelegate{
	override func prepareForReuse() {
		super.prepareForReuse()
		sectionCollectionView.reloadData()
	}
}

class CarouselSection: Equatable {
	static func == (lhs: CarouselSection, rhs: CarouselSection) -> Bool {
		if lhs.carouselTitle != rhs.carouselTitle || lhs.carouselContent.count != rhs.carouselContent.count{
			return false
		}
		for index in 0..<lhs.carouselContent.count{
			if !(lhs.carouselContent[index] == rhs.carouselContent[index]){
				return false
			}
		}
		
		return true
	}
	
	var carouselTitle: String
	var carouselContent: [CarouselItem]
	
	init(title: String, content: [CarouselItem]) {
		carouselTitle = title
		carouselContent = content
	}
}

