//
//  AddItemClueDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/25/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddItemClueDelegate {
	var realm: Realm {get set}
	var loggedIn: Bool {get set}
	var addItemKindSelected: String! {get set}
	var itemNameClue: String? {get set}
	var itemAuthorClue: String? {get set}
	var itemYearClue: String? {get set}
	var itemImageClue: [UIImage] {get set}
	var isEditingClue: Bool {get set}
	var itemOriginalLocationClue: URL? {get set}
	var folderClue: String? {get set}
	var collectionClues: [String]? {get set}
	var pinClue: Bool? {get set}
	var favoriteClue: Bool? {get set}
	var goalCategoryClue: String? {get set}
	var teamClues: [String]? {get set}
	var selectedCoverName: String! {get set}
	var selectedPaperName: String! {get set}
	var displayedPaperColor: String! {get set}
	var displayedOrientation: String! {get set}
	
	func refreshView()
}
