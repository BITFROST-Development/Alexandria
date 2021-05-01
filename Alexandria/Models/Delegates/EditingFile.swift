//
//  BookChangerDelegate.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 7/31/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit

protocol EditingFile {
	var linkMode: Bool {get set}
	var item: FileItem! {get set}
}
