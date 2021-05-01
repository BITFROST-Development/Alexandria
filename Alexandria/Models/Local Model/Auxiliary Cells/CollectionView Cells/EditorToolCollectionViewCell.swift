//
//  EditorToolCollectionViewCell.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/8/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorToolCollectionViewCell: UICollectionViewCell {
	
	static var identifier = "editorToolCollectionViewCell"
	
	var controller: EditingViewController!
	var collection: EditorFileToolBox!
	var chosen: Bool!
	var kind: String!
	var index: Int!
	@IBOutlet weak var toolIcon: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	@IBAction func toolPressed(_ sender: Any) {
		controller.currentTool = index
		switch kind {
		case "fountain":
			controller.currentWrittingTool = "fountain"
			controller.writingGesture(kind)
			break
		case "pencil":
			controller.currentWrittingTool = "pencil"
			controller.writingGesture(kind)
			break
		case "pen":
			controller.currentWrittingTool = "pen"
			controller.writingGesture(kind)
			break
		case "highlighter":
			controller.currentWrittingTool = "highlighter"
			controller.writingGesture(kind)
			break
		case "eraser":
			controller.currentWrittingTool = "eraser"
			controller.writingGesture(kind)
			break
		case "link":
			controller.linkGesture()
			break
		case "lasso":
			controller.lassoGesture()
			break
		case "drag":
			controller.dragGesture()
			break
		case "box":
			controller.textGesture("box")
			break
		case "line":
			controller.textGesture("line")
		default:
			print("something went wrong with tool selection")
		}
		collection.toolCollection.reloadItems(at: [IndexPath(row: index, section: 0)])
		collection.preferencesCollection.reloadData()
	}
	
}
