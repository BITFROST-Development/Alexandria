//
//  InlinePicker.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 1/30/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

@IBDesignable class InlinePicker: UIView {
    @IBInspectable var borderColor: UIColor = .clear
    @IBInspectable var font: UIFont = .systemFont(ofSize: 20)
    
    var delegate: InlinePickerDelegate?
    var typingDelegate: UITextFieldDelegate?{
        get{
            return textField.delegate
        } set (newDelegate){
            textField.delegate = newDelegate
        }
    }
    var pickedItems: [InlinePickerItem] = []
    
    var selectedItemsToDisplay: [InlinePickerSelectedItem] {
        get{
			var returningArray: [InlinePickerSelectedItem] = []
            for item in pickedItems{
                let newSelectedItem = InlinePickerSelectedItem(frame: self.frame)
				newSelectedItem.parentInlinePicker = self
                newSelectedItem.itemTitle = item.name ?? ""
                if let collectionItem = item as? FileCollection{
					let newColor = UIColor(cgColor: CGColor(red: CGFloat(collectionItem.color?.red.value ?? 207), green: CGFloat(collectionItem.color?.green.value ?? 89), blue: CGFloat(collectionItem.color?.blue.value ?? 61), alpha: 1))
                    var cgWhite: CGFloat = 0
                    var alpha: CGFloat = 0
                    newColor.getWhite(&cgWhite, alpha: &alpha)
					newSelectedItem.backgroundColor = newColor
					newSelectedItem.parentInlinePicker = self
					newSelectedItem.itemTitleLable.font = font
					if cgWhite > 0.6{
						newSelectedItem.textColor = .black
					} else {
						newSelectedItem.textColor = .white
					}
					
				} else if let folderItem = item as? Folder{
					let newColor = UIColor(cgColor: CGColor(red: CGFloat(folderItem.color?.red.value ?? 207), green: CGFloat(folderItem.color?.green.value ?? 89), blue: CGFloat(folderItem.color?.blue.value ?? 61), alpha: 1))
					var cgWhite: CGFloat = 0
					var alpha: CGFloat = 0
					newColor.getWhite(&cgWhite, alpha: &alpha)
					newSelectedItem.backgroundColor = newColor
					newSelectedItem.parentInlinePicker = self
					newSelectedItem.itemTitleLable.font = font
					if cgWhite > 0.6{
						newSelectedItem.textColor = .black
					} else {
						newSelectedItem.textColor = .white
					}
				} else if let setItem = item as? TermSet{
					let newColor = UIColor(cgColor: CGColor(red: CGFloat(setItem.color?.red.value ?? 207), green: CGFloat(setItem.color?.green.value ?? 89), blue: CGFloat(setItem.color?.blue.value ?? 61), alpha: 1))
					var cgWhite: CGFloat = 0
					var alpha: CGFloat = 0
					newColor.getWhite(&cgWhite, alpha: &alpha)
					newSelectedItem.backgroundColor = newColor
					newSelectedItem.parentInlinePicker = self
					newSelectedItem.itemTitleLable.font = font
					if cgWhite > 0.6{
						newSelectedItem.textColor = .black
					} else {
						newSelectedItem.textColor = .white
					}
				}
				returningArray.append(newSelectedItem)
            }
            return returningArray
        }
    }
    
    var textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
		firstDisplaying()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
		firstDisplaying()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstDisplaying()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
		for item in selectedItemsToDisplay{
			item.layoutSubviews()
		}
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
		firstDisplaying()
    }

    func setup(){
        self.layer.borderColor = borderColor.cgColor
		textField.placeholder = "Pick more"
        textField.font = font
        textField.textAlignment = .left
    }
	
	func firstDisplaying(){
		self.subviews.forEach({ $0.removeFromSuperview() })
		var textRect = self.frame
		var finalTextHeight: CGFloat = 20
		var currentLineHeight: CGFloat = 0
		var currentLineWidth: CGFloat = 0
		for index in 0..<selectedItemsToDisplay.count{
			let item = selectedItemsToDisplay[index]
			item.updateSizes()
			let constraintRect = item.frame.size
			finalTextHeight = constraintRect.height
			if currentLineWidth + constraintRect.width > self.frame.width {
				currentLineHeight += (constraintRect.height) + 10
				currentLineWidth = 0
				item.frame.origin = CGPoint(x: currentLineWidth, y: currentLineHeight)
				currentLineWidth += (constraintRect.width) + 10
			} else {
				item.frame.origin = CGPoint(x: currentLineWidth, y: currentLineHeight)
				currentLineWidth += (constraintRect.width) + 10
				if currentLineWidth > self.frame.width - 30{
					currentLineHeight += (constraintRect.height) + 10
					currentLineWidth = 0
				}
			}
			self.addSubview(item)
		}
		
		if self.frame.width - currentLineWidth < 30{
			textRect.size.height = finalTextHeight
			currentLineHeight += finalTextHeight + 10
			currentLineWidth = 0
			textRect.origin.x = currentLineWidth
			textRect.origin.y = currentLineHeight
			currentLineHeight -= 10
			if currentLineHeight + finalTextHeight > self.frame.height{
				delegate?.needs(currentLineHeight + finalTextHeight)
			}
			currentLineHeight += 20
			currentLineHeight -= finalTextHeight
			
		} else {
			if pickedItems.count == 0{
				textField.textAlignment = .right
			} else {
				textField.textAlignment = .left
			}
			textRect.size.width = self.frame.width - currentLineWidth - 8
			textRect.size.height = finalTextHeight
			textRect.origin.x = currentLineWidth
			textRect.origin.y = currentLineHeight
			delegate?.needs(currentLineHeight + finalTextHeight)
		}
		textField.frame = textRect
		self.frame.size.height = currentLineHeight + finalTextHeight
		self.addSubview(textField)
    }
    
	func refreshPicker(){
		firstDisplaying()
	}
	
    @objc func eliminateItem(_ sender: InlinePickerSelectedItem){
		pickedItems.removeAll(where: {$0.name! == sender.itemTitle})
		delegate?.itemsUpdated(pickedItems)
    }
}



@IBDesignable class InlinePickerSelectedItem: UIView{
    
    @IBInspectable var itemTitle: String{
        get{
            if (itemTitleLable.text == nil){
                itemTitleLable.text = "Item to be added"
            }
            return itemTitleLable.text!
        } set (newValue){
            itemTitleLable.text = newValue
        }
    }
    
    @IBInspectable var textColor: UIColor! = .white
    
    var parentInlinePicker: InlinePicker!
    var itemTitleLable: InlineItemLabel = InlineItemLabel()
    var eliminateItemButton: UIButton = UIButton()
	var maxFrame: CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		maxFrame = frame
		backgroundColor = AlexandriaConstants.alexandriaRed
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    func setUpSubviews(){
        itemTitleLable.text = itemTitle
        itemTitleLable.textColor = textColor
        itemTitleLable.translatesAutoresizingMaskIntoConstraints = false
		itemTitleLable.font = UIFont.systemFont(ofSize: 18)
        itemTitleLable.sizeToFit()
        itemTitleLable.frame.size.width += 2
        eliminateItemButton.setTitle("", for: .normal)
        eliminateItemButton.addTarget(self, action: #selector(eliminateItem(_:)), for: .touchUpInside)
        eliminateItemButton.backgroundColor = .clear
        eliminateItemButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func eliminateItem(_ sender: Any){
        parentInlinePicker.eliminateItem(self)
    }
    
    func getSize() -> CGSize{
        return self.frame.size
    }
    
    override func layoutSubviews() {
        updateSizes()
    }
    
    override func prepareForInterfaceBuilder() {
        updateSizes()
    }
    
    
    func updateSizes(){
        
        itemTitleLable.sizeToFit()
        itemTitleLable.frame.size.width += 2
		itemTitleLable.textColor = textColor
        var frameSize = itemTitleLable.frame.size
        frameSize.height = 24
        frameSize.width += 20 + frameSize.height
        
        
		if frameSize.width > maxFrame.size.width - 15{
			itemTitleLable.frame.size.width = maxFrame.size.width - 64
			frameSize = itemTitleLable.frame.size
			frameSize.height = 24
			frameSize.width += 20 + frameSize.height
		}
		self.frame = CGRect(origin: self.frame.origin, size: frameSize)
		self.layer.cornerRadius = 3
		self.clipsToBounds = true
        let xSubview = UIView()
		var backgroundHue: CGFloat = 0
		var backgroundSaturation: CGFloat = 0
		var backgroundBrightness: CGFloat = 0
		backgroundColor?.getHue(&backgroundHue, saturation: &backgroundSaturation, brightness: &backgroundBrightness, alpha: nil)
		xSubview.backgroundColor = UIColor(hue: backgroundHue, saturation: backgroundSaturation - 0.3, brightness: backgroundBrightness, alpha: 1)
        xSubview.translatesAutoresizingMaskIntoConstraints = false
        
        let xView = UIImageView(image: UIImage(systemName: "multiply"))
        xView.tintColor = textColor
        xView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(itemTitleLable)
        self.addSubview(xSubview)
        self.addSubview(xView)
        self.addSubview(eliminateItemButton)
		
        let top = NSLayoutConstraint(item: itemTitleLable, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: itemTitleLable, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        
        xSubview.widthAnchor.constraint(equalToConstant: frameSize.height).isActive = true
        xSubview.heightAnchor.constraint(equalToConstant: frameSize.height).isActive = true
        xSubview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        xView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        xView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        xView.centerXAnchor.constraint(equalTo: xSubview.centerXAnchor).isActive = true
        xView.centerYAnchor.constraint(equalTo: xSubview.centerYAnchor).isActive = true
        
        eliminateItemButton.heightAnchor.constraint(equalTo: xSubview.heightAnchor, multiplier: 1).isActive = true
        eliminateItemButton.widthAnchor.constraint(equalTo: xSubview.widthAnchor, multiplier: 1).isActive = true
        let eliminateButtonAlignHorizontal = NSLayoutConstraint(item: eliminateItemButton, attribute: .centerX, relatedBy: .equal, toItem: xSubview, attribute: .centerX, multiplier: 1, constant: 0)
        let eliminateButtonAlignVertical = NSLayoutConstraint(item: eliminateItemButton, attribute: .centerY, relatedBy: .equal, toItem: xSubview, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraint(top)
        self.addConstraint(left)
        self.addConstraint(eliminateButtonAlignVertical)
        self.addConstraint(eliminateButtonAlignHorizontal)
    }
    
    
}

class InlineItemLabel: UILabel {
    override var intrinsicContentSize: CGSize{
        get{
            var returningSize = self.attributedText?.size() ?? super.intrinsicContentSize
            returningSize.width += 1
            return returningSize
        }
    }
}


class InlinePickerTableManager: UIViewController{
	var itemsToPoblate: [InlinePickerItem] = []
	var controller: AddItemViewController!
	var contentType: String!
	var currentIndex: Int!
	var currentContent: String!
}

extension InlinePickerTableManager: UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row < itemsToPoblate.count{
			tableView.deselectRow(at: indexPath, animated: true)
			switch contentType {
			case "collections":
				controller.collections.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			case "goals":
				controller.goals.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			case "teams":
				controller.teams.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			case "members":
				controller.members.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			case "files":
				controller.childrenItems.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			case "children":
				controller.childrenItems.append(itemsToPoblate[indexPath.row].personalID ?? "")
				break
			default:
				print("something went wrong")
			}
			var cell = (controller.displayingView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as! AddItemInlinePickerTableViewCell)
			cell.picker.pickedItems.append(itemsToPoblate[indexPath.row])
			CATransaction.begin()
			CATransaction.setCompletionBlock({
				cell = (self.controller.displayingView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0)) as! AddItemInlinePickerTableViewCell)
				cell.picker.textField.becomeFirstResponder()
			})
			cell.picker.refreshPicker()
			CATransaction.commit()
		} else {
			controller.view.endEditing(true)
			let cell = (controller.displayingView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as! AddItemInlinePickerTableViewCell)
			cell.refreshKeyboard = false
			switch contentType {
			case "collections":
				controller.subItemClueManager = AddItemClueManager()
				controller.subItemClueManager.controller = controller
				controller.subItemClueManager.addItemKindSelected = "newCollection"
				controller.subItemClueManager.itemNameClue = currentContent
				controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
				break
			case "goals":
				controller.subItemClueManager = AddItemClueManager()
				controller.subItemClueManager.controller = controller
				controller.subItemClueManager.addItemKindSelected = "newGoal"
				controller.subItemClueManager.itemNameClue = currentContent
				controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
				break
			case "teams":
				controller.subItemClueManager = AddItemClueManager()
				controller.subItemClueManager.controller = controller
				controller.subItemClueManager.addItemKindSelected = "newTeam"
				controller.subItemClueManager.itemNameClue = currentContent
				controller.performSegue(withIdentifier: "toNewSubItem", sender: controller)
				break
			case "files":
				controller.handleNewSubItemTrigger()
				break
			case "children":
				controller.handleNewSubItemTrigger()
				break
			default:
				print("something went wrong")
			}
		}
	}
}

extension InlinePickerTableManager: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		tableView.frame.size.height = 40 * (CGFloat(itemsToPoblate.count) + 1)
		tableView.layer.cornerRadius = 5
		tableView.backgroundColor = .blue
		if contentType == "members"{
			return itemsToPoblate.count
		}
		return itemsToPoblate.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		if indexPath.row < itemsToPoblate.count{
			let cell = tableView.dequeueReusableCell(withIdentifier: InlinePickerFilterTableViewCell.identifier, for: indexPath) as! InlinePickerFilterTableViewCell
			let currentBackgroundColor = UIColor(cgColor: CGColor(red: CGFloat((itemsToPoblate[indexPath.row] as? FileCollection)?.color?.red.value ?? 0), green: CGFloat((itemsToPoblate[indexPath.row] as? FileCollection)?.color?.green.value ?? 0), blue: CGFloat((itemsToPoblate[indexPath.row] as? FileCollection)?.color?.blue.value ?? 0), alpha: 1))
			var cgWhite: CGFloat = 0
			var alpha: CGFloat = 0
			currentBackgroundColor.getWhite(&cgWhite, alpha: &alpha)
			if cgWhite > 0.6{
				cell.itemTitle.textColor = .black
				cell.itemKind.textColor = .black
				cell.selectedIndicator.tintColor = .black
			} else {
				cell.itemTitle.textColor = .white
				cell.itemKind.textColor = .white
				cell.selectedIndicator.tintColor = .white
			}
			let checkedImage = UIImage(systemName: "checkmark.circle.fill")
			let uncheckedImage = UIImage(systemName: "circle")
			if cell.isPicked{
				cell.selectedIndicator.image = checkedImage
			} else {
				cell.selectedIndicator.image = uncheckedImage
			}
			cell.backgroundColor = currentBackgroundColor
			
			cell.itemTitle.text = itemsToPoblate[indexPath.row].name
			cell.itemKind.text = (itemsToPoblate[indexPath.row] as? FileCollection != nil) ? "Collection" : (itemsToPoblate[indexPath.row] as? Goal != nil) ? "Goal" : (itemsToPoblate[indexPath.row] as? Team != nil) ? "Team" : (itemsToPoblate[indexPath.row] as? Friend != nil) ? "User" : (itemsToPoblate[indexPath.row] as? Book != nil) ? "Book" : (itemsToPoblate[indexPath.row] as? Notebook != nil) ? "Notebook" : (itemsToPoblate[indexPath.row] as? TermSet != nil) ? "Flashcard Set" : "Folder"
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: InlinePickerFilterNewItemTableViewCell.identifier, for: indexPath) as! InlinePickerFilterNewItemTableViewCell
			cell.itemTitle.text = currentContent
			return cell
		}
	}
}

