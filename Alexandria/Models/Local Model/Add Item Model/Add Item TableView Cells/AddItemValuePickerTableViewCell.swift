//
//  AddItemValuePickerTableViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 2/2/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class AddItemValuePickerTableViewCell: UITableViewCell {
	
	static var identifier = "addItemValuePickerTableViewCell"
	
	var controller: AddItemViewController!
	
	@IBOutlet weak var sectionTitle: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!
	// 123 110
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
		datePicker.date = Date()
		datePicker.preferredDatePickerStyle = .compact
		datePicker.minimumDate = Date()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@objc func dateChanged(_ sender: UIDatePicker!){
//		self.layoutSubviews()
		controller.goalEndDate = sender.date
	}
    
}
