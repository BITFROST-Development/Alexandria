//
//  EditorSearchBar.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 4/18/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit

class EditorSearchBar: UIView{
	var controller: EditingViewController?{
		get{
			return editingController
		} set (newController){
			editingController = newController
			setup()
		}
	}
	private var editingController: EditingViewController?
	var searchButton = UIButton()
	var searchBar = UITextField()
	var cancelSearch = UIButton()
	var nextResult = UIButton()
	var previousResult = UIButton()
	
	private func setup(){
		searchButton.addTarget(self, action: #selector(finishSearch), for: .touchUpInside)
		searchBar.delegate = self
		cancelSearch.addTarget(self, action: #selector(searchCancelled), for: .touchUpInside)
		nextResult.addTarget(self, action: #selector(nextSearchResult), for: .touchUpInside)
		previousResult.addTarget(self, action: #selector(previousSearchResult), for: .touchUpInside)
	}
	
	@objc func finishSearch(){
		self.endEditing(true)
	}
	
	@objc func searchCancelled(){
		
	}
	
	@objc func nextSearchResult(){
		
	}
	
	@objc func previousSearchResult(){
		
	}
	
	private func drawBar(){
		
	}
	
}

extension EditorSearchBar: UITextFieldDelegate{
	
}
