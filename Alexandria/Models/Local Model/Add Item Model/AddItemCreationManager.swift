//
//  AddItemCreationManager.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/21/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import PDFKit

extension AddItemViewController{
	private func randomString(length: Int) -> String {
	  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	  return String((0..<length).map{ _ in letters.randomElement()! })
	}
	
	func saveNewFile(){
		if (toLocal || toDrive) && (finalName != ""){
			let clearedImage = itemImage[0].cropAlpha()
			let thumbnailData = StoredFileDec("\(finalName) Thumbnail", clearedImage.jpegData(compressionQuality: 0.1)!, "image")
			UIView.animate(withDuration: 0.3, animations: {
				self.importingLabel.alpha = 1
				self.progressView.alpha = 1
				self.opacityFilter.alpha = 1
			}){ _ in
				let bookDocument = PDFDocument(url: self.originalURL!)
				do{
					var localAddress: String? = nil
					var driveID: String? = nil
					var booksFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
					booksFolder.appendPathComponent("Files")
					if !FileManager.default.fileExists(atPath: booksFolder.path){
						do{
							try FileManager.default.createDirectory(at: booksFolder, withIntermediateDirectories: true, attributes: nil)
						} catch let error{
							print(error.localizedDescription)
						}
					}
					let newFileCreatorAddress = booksFolder.appendingPathComponent("\(self.finalName)")
					localAddress = "Files/\(self.finalName)"
					try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
					
					
					let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
					try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
					FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: bookDocument?.dataRepresentation(), attributes: nil)
					let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
					try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
					var annotationImageString = ""
					var idTable = Set<String>()
					var pagesString = ""
					for index in 0..<(bookDocument?.pageCount ?? 0){
						var id = self.randomString(length: 30)
						while idTable.contains(id){
							id = self.randomString(length: 30)
						}
						do{
							let currentPageFolder = userDataFolder.appendingPathComponent(id)
							try FileManager.default.createDirectory(at: currentPageFolder, withIntermediateDirectories: true, attributes: nil)
							FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
							FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
							FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
							FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
							FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
						} catch let error{
							print(error.localizedDescription)
						}
						idTable.insert(id)
						pagesString = pagesString + id
						if index + 1 < (bookDocument?.pageCount ?? 0){
							pagesString = pagesString + "\n"
						}
						let currentPage = bookDocument?.page(at: index)
						var currentPageAnnotations: [PDFAnnotation] = []
						for annotation in currentPage?.annotations ?? []{
							currentPageAnnotations.append(annotation)
							currentPage?.removeAnnotation(annotation)
						}
						autoreleasepool(invoking: {
							UIGraphicsBeginImageContextWithOptions(currentPage!.bounds(for: .mediaBox).size, false, 0.0)
							let currentContext = UIGraphicsGetCurrentContext()!
							currentContext.translateBy(x: 0.0, y: currentPage!.bounds(for: .mediaBox).height)
							currentContext.scaleBy(x: 1.0, y: -1.0)
							for annotation in currentPageAnnotations{
								annotation.draw(with: .cropBox, in: currentContext)
							}
							let image = UIGraphicsGetImageFromCurrentImageContext()
							UIGraphicsEndImageContext()
							annotationImageString = "\(annotationImageString)/page/\(index)/begin/\n\(image!.pngData()!.base64EncodedString())\n/page/\(index)/end/\n"
							self.progressView.setProgress(Float(index) * 0.85 / Float(bookDocument!.pageCount), animated: true)
						})
					}
					try annotationImageString.write(to: attachmentsFolder.appendingPathComponent("top"), atomically: false, encoding: .utf8)
					try pagesString.write(to: userDataFolder.appendingPathComponent("pages"), atomically: false, encoding: .utf8)
					self.progressView.setProgress(0.9, animated: true)
					if self.toDrive{
						self.uploadFileToDrive(address: newFileCreatorAddress){(success, id) in
							if !self.toLocal{
								do{
									try FileManager.default.removeItem(at: newFileCreatorAddress)
								} catch let error {
									print(error.localizedDescription)
								}
							}
							driveID = id
							let trackerIDs = RealmSwift.List<ItemIDWrapper>()
							let teamIDs = RealmSwift.List<ItemIDWrapper>()
							for goal in self.goals{
								trackerIDs.append(self.controller.realm.objects(ItemIDWrapper.self).filter({$0.value == goal}).first!)
							}
							
							for team in self.teams{
								teamIDs.append(self.controller.realm.objects(ItemIDWrapper.self).filter({$0.value == team}).first!)
							}
							let personalCollection = FileCollection("\(self.finalName)", self.toDrive)
							do{
								try self.controller.realm.write({
									self.controller.realm.add(personalCollection)
								})
							} catch let error {
								print(error.localizedDescription)
							}
							let newBook = Book(self.folder, self.collections, driveID, self.finalName, self.itemAuthor, self.itemYear, thumbnailData, trackerIDs, teamIDs, bookPersonalCollectionID: personalCollection.personalID, self.isFavorite ? "True" : "False", self.toDrive, localAddress, Date(), nil)
							do{
								try self.controller.realm.write({
									self.controller.realm.add(newBook)
									personalCollection.childrenIDs.append(ItemIDWrapper(newBook.personalID))
									for team in self.teams{
										let currentTeam = self.controller.realm.objects(Team.self).filter({$0.personalID == team}).first!
										currentTeam.sharedFileIDs.append(ListWrapperForString(newBook.personalID))
									}
								})
								self.controller.refreshView()
								Socket.sharedInstance.updateAlexandriaCloud(username: self.controller.realm.objects(CloudUser.self).first!.username, alexandriaInfo: AlexandriaDataDec(true))
								self.dismiss(animated: true, completion: nil)
							} catch let error {
								print(error.localizedDescription)
							}
						}
					} else {
						let trackerIDs = RealmSwift.List<ItemIDWrapper>()
						for goal in self.goals{
							trackerIDs.append(self.controller.realm.objects(ItemIDWrapper.self).filter({$0.value == goal}).first!)
						}
						let personalCollection = FileCollection("\(self.finalName)", self.toDrive)
						do{
							try self.controller.realm.write({
								self.controller.realm.add(personalCollection)
							})
						} catch let error {
							print(error.localizedDescription)
						}
						let newBook = Book(self.folder, self.collections, driveID, self.finalName, self.itemAuthor, self.itemYear, thumbnailData, trackerIDs, nil, bookPersonalCollectionID: personalCollection.personalID, self.isFavorite ? "True" : "False", self.toDrive, localAddress, Date(), nil)
						do{
							try self.controller.realm.write({
								self.controller.realm.add(newBook)
								personalCollection.childrenIDs.append(ItemIDWrapper(newBook.personalID))
							})
							self.controller.refreshView()
							self.dismiss(animated: true, completion: nil)
						} catch let error {
							print(error.localizedDescription)
						}
					}
				} catch let error {
					print(error.localizedDescription)
				}
			}
		}  else if finalName != ""{
			let alert = UIAlertController(title: "Error in File Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to import a new file.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Notebook Creation", message: "You must give your new file a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	
	
	func saveNewNotebook(){
		if (toLocal || toDrive) && (finalName != ""){
			do{
				let notebookFile = PDFDocument()
				let pageDoc = PDFDocument(data: NSDataAsset(name: selectedPaperName + "/\(displayedOrientation)/\(displayedPaperColor)pdf")!.data)
				let startingPage = pageDoc!.page(at: 0)!
				notebookFile.insert(startingPage, at: 0)
				var localAddress: String? = nil
				var driveID: String? = nil
				var booksFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
				booksFolder.appendPathComponent("Files")
				if !FileManager.default.fileExists(atPath: booksFolder.path){
					do{
						try FileManager.default.createDirectory(at: booksFolder, withIntermediateDirectories: true, attributes: nil)
					} catch let error{
						print(error.localizedDescription)
					}
				}
				let newFileCreatorAddress = booksFolder.appendingPathComponent("\(self.finalName)")
				localAddress = "Files/\(self.finalName)"
				try FileManager.default.createDirectory(at: newFileCreatorAddress, withIntermediateDirectories: true, attributes: nil)
				
				
				let attachmentsFolder = newFileCreatorAddress.appendingPathComponent("attachments")
				try FileManager.default.createDirectory(at: attachmentsFolder, withIntermediateDirectories: true, attributes: nil)
				FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("root").path, contents: notebookFile.dataRepresentation(), attributes: nil)
				FileManager.default.createFile(atPath: attachmentsFolder.appendingPathComponent("top").path, contents: nil, attributes: nil)
				
				let userDataFolder = newFileCreatorAddress.appendingPathComponent("userData")
				try FileManager.default.createDirectory(at: userDataFolder, withIntermediateDirectories: true, attributes: nil)
				let id = self.randomString(length: 30)
				let currentPageFolder = userDataFolder.appendingPathComponent(id)
				try FileManager.default.createDirectory(at: currentPageFolder, withIntermediateDirectories: true, attributes: nil)
				FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("layer").path, contents: nil, attributes: nil)
				FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("ink").path, contents: nil, attributes: nil)
				FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("image").path, contents: nil, attributes: nil)
				FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("link").path, contents: nil, attributes: nil)
				FileManager.default.createFile(atPath: currentPageFolder.appendingPathComponent("text").path, contents: nil, attributes: nil)
				try id.write(to: userDataFolder.appendingPathComponent("pages"), atomically: false, encoding: .utf8)
				if self.toDrive{
					uploadFileToDrive(address: newFileCreatorAddress, completion: {(success, id) in
						if !self.toLocal{
							localAddress = nil
							do{
								try FileManager.default.removeItem(at: newFileCreatorAddress)
							} catch let error {
								print(error.localizedDescription)
							}
						}
						driveID = id
						let personalCollection = FileCollection("\(self.finalName)", self.toDrive)
						do{
							try self.controller.realm.write({
								self.controller.realm.add(personalCollection)
							})
						} catch let error {
							print(error.localizedDescription)
						}
						let newNotebook = Notebook(self.collections, self.folder, driveID, Date(), self.finalName, self.itemAuthor, self.itemYear, nil, self.selectedCoverName, self.selectedPaperName, self.displayedPaperColor, self.displayedOrientation, [self.displayedPaperStyle], [Double(self.selectedPaperName[self.selectedPaperName.index(before:self.selectedPaperName.index(before: self.selectedPaperName.endIndex))...self.selectedPaperName.index(before: self.selectedPaperName.endIndex)])!], self.goals, self.teams, personalCollection.personalID, 0, self.isFavorite ? "True" : "False", self.toDrive, localAddress)
						do{
							try self.controller.realm.write({
								self.controller.realm.add(newNotebook)
								personalCollection.childrenIDs.append(ItemIDWrapper(newNotebook.personalID))
								for team in self.teams{
									let currentTeam = self.controller.realm.objects(Team.self).filter({$0.personalID == team}).first!
									currentTeam.sharedFileIDs.append(ListWrapperForString(newNotebook.personalID))
								}
							})
							self.controller.refreshView()
							Socket.sharedInstance.updateAlexandriaCloud(username: self.controller.realm.objects(CloudUser.self).first!.username, alexandriaInfo: AlexandriaDataDec(true))
							self.dismiss(animated: true, completion: nil)
						} catch let error {
							print(error.localizedDescription)
						}
					})
				} else {
					let personalCollection = FileCollection("\(self.finalName)", self.toDrive)
					do{
						try self.controller.realm.write({
							self.controller.realm.add(personalCollection)
						})
					} catch let error {
						print(error.localizedDescription)
					}
					let newNotebook = Notebook(self.collections, self.folder, driveID, Date(), self.finalName, self.itemAuthor, self.itemYear, nil, self.selectedCoverName, self.selectedPaperName, self.displayedPaperColor, self.displayedOrientation, [self.displayedPaperStyle], [Double(self.selectedPaperName[self.selectedPaperName.index(before:self.selectedPaperName.index(before: self.selectedPaperName.endIndex))...self.selectedPaperName.index(before: self.selectedPaperName.endIndex)])!], self.goals, nil, personalCollection.personalID, 0, self.isFavorite ? "True" : "False", self.toDrive, localAddress)
					do{
						try self.controller.realm.write({
							self.controller.realm.add(newNotebook)
							personalCollection.childrenIDs.append(ItemIDWrapper(newNotebook.personalID))
						})
						self.controller.refreshView()
						self.dismiss(animated: true, completion: nil)
					} catch let error {
						print(error.localizedDescription)
					}
				}
			} catch let error {
				print(error.localizedDescription)
			}
			
		} else if finalName != ""{
			let alert = UIAlertController(title: "Error in Notebook Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new notebook.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Notebook Creation", message: "You must give your new notebook a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	func saveNewTermset(){
		if (toLocal || toDrive) && (finalName != ""){
			do {
				var newColorSet = IconColorDec()
				newColorSet.colorName = iconColor
				var red: CGFloat = 0
				var green: CGFloat = 0
				var blue: CGFloat = 0
				
				switch iconColor {
				case "Black":
					AlexandriaConstants.iconBlack.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Blue":
					AlexandriaConstants.iconBlue.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Green":
					AlexandriaConstants.iconGreen.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Grey":
					AlexandriaConstants.iconGrey.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Orange":
					AlexandriaConstants.iconOrange.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Pink":
					AlexandriaConstants.iconPink.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Purple":
					AlexandriaConstants.iconPurple.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Red":
					AlexandriaConstants.iconRed.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Turquoise":
					AlexandriaConstants.iconTurquoise.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Yellow":
					AlexandriaConstants.iconYellow.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				default:
					print("error")
				}
				newColorSet.red = Double(red)
				newColorSet.green = Double(green)
				newColorSet.blue = Double(blue)
				
				let personalCollection = FileCollection("\(self.finalName)", self.toDrive)
				try self.controller.realm.write({
					self.controller.realm.add(personalCollection)
				})
				var newSet: TermSet!
				if toDrive{
					newSet = TermSet(collections, folder, Date(), finalName, itemAuthor, itemYear, nil, newColorSet, [], goals, teams, personalCollection.personalID, self.isFavorite ? "True" : "False", toDrive)
				} else {
					newSet = TermSet(collections, folder, Date(), finalName, itemAuthor, itemYear, nil, newColorSet, [], goals, nil, personalCollection.personalID, self.isFavorite ? "True" : "False", toDrive)
				}
				 
				try self.controller.realm.write({
					self.controller.realm.add(newSet)
					personalCollection.childrenIDs.append(ItemIDWrapper(newSet.personalID))
					if toDrive{
						for team in self.teams{
							let currentTeam = self.controller.realm.objects(Team.self).filter({$0.personalID == team}).first!
							currentTeam.sharedFileIDs.append(ListWrapperForString(newSet.personalID))
						}
					}
				})
				self.controller.refreshView()
				if toDrive{
					Socket.sharedInstance.updateAlexandriaCloud(username: self.controller.realm.objects(CloudUser.self).first!.username, alexandriaInfo: AlexandriaDataDec(true))
				}
				self.dismiss(animated: true, completion: nil)
			} catch let error {
				print (error.localizedDescription)
			}
		} else if finalName != ""{
			let alert = UIAlertController(title: "Error in Flashcard Set Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new flashcard set.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Flashcard Set Creation", message: "You must give your new flashcard set a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	func saveNewFolder(){
		if (toLocal || toDrive) && (finalName != ""){
			do {
				var newColorFolder = IconColorDec()
				newColorFolder.colorName = iconColor
				var red: CGFloat = 0
				var green: CGFloat = 0
				var blue: CGFloat = 0
				
				switch iconColor {
				case "Black":
					AlexandriaConstants.iconBlack.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Blue":
					AlexandriaConstants.iconBlue.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Green":
					AlexandriaConstants.iconGreen.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Grey":
					AlexandriaConstants.iconGrey.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Orange":
					AlexandriaConstants.iconOrange.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Pink":
					AlexandriaConstants.iconPink.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Purple":
					AlexandriaConstants.iconPurple.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Red":
					AlexandriaConstants.iconRed.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Turquoise":
					AlexandriaConstants.iconTurquoise.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Yellow":
					AlexandriaConstants.iconYellow.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				default:
					print("error")
				}
				newColorFolder.red = Double(red)
				newColorFolder.green = Double(green)
				newColorFolder.blue = Double(blue)
				
				var newFolder: Folder!
				if toDrive{
					newFolder = Folder(folder, Date(), childrenItems, newColorFolder, folderName: finalName, self.isFavorite ? "True" : "False", teams, toDrive)
				} else {
					newFolder = Folder(folder, Date(), childrenItems, newColorFolder, folderName: finalName, self.isFavorite ? "True" : "False", nil, toDrive)
				}
				try self.controller.realm.write({
					self.controller.realm.add(newFolder)
					if toDrive{
						for team in self.teams{
							let currentTeam = self.controller.realm.objects(Team.self).filter({$0.personalID == team}).first!
							currentTeam.sharedFileIDs.append(ListWrapperForString(newFolder.personalID))
						}
					}
				})
				self.controller.refreshView()
				if toDrive{
					Socket.sharedInstance.updateAlexandriaCloud(username: self.controller.realm.objects(CloudUser.self).first!.username, alexandriaInfo: AlexandriaDataDec(true))
				}
				self.dismiss(animated: true, completion: nil)
			} catch let error {
				print (error.localizedDescription)
			}
		} else if finalName != ""{
			let alert = UIAlertController(title: "Error in Folder Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new folder.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Folder Creation", message: "You must give your new folder a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	func saveNewCollection(){
		if (toLocal || toDrive) && (finalName != ""){
			do{
				var newColorCollection = IconColorDec()
				newColorCollection.colorName = iconColor
				var red: CGFloat = 0
				var green: CGFloat = 0
				var blue: CGFloat = 0
				
				switch iconColor {
				case "Black":
					AlexandriaConstants.iconBlack.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Blue":
					AlexandriaConstants.iconBlue.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Green":
					AlexandriaConstants.iconGreen.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Grey":
					AlexandriaConstants.iconGrey.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Orange":
					AlexandriaConstants.iconOrange.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Pink":
					AlexandriaConstants.iconPink.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Purple":
					AlexandriaConstants.iconPurple.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Red":
					AlexandriaConstants.iconRed.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Turquoise":
					AlexandriaConstants.iconTurquoise.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				case "Yellow":
					AlexandriaConstants.iconYellow.getRed(&red, green: &green, blue: &blue, alpha: nil)
					break
				default:
					print("error")
				}
				newColorCollection.red = Double(red)
				newColorCollection.green = Double(green)
				newColorCollection.blue = Double(blue)
				let newCollection = FileCollection(finalName, childrenItems, newColorCollection, toDrive)
				try self.controller.realm.write({
					self.controller.realm.add(newCollection)
				})
				self.controller.refreshView()
				if toDrive{
					Socket.sharedInstance.updateAlexandriaCloud(username: self.controller.realm.objects(CloudUser.self).first!.username, alexandriaInfo: AlexandriaDataDec(true))
				}
				self.dismiss(animated: true, completion: nil)
			} catch let error {
				print(error.localizedDescription)
			}
		} else if finalName != ""{
			let alert = UIAlertController(title: "Error in Collection Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new collection.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Collection Creation", message: "You must give your new collection a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	func saveNewGoal(){
//		if (toLocal || toDrive) && (finalName != ""){
//			do{
//				
//			} catch let error {
//				print(error.localizedDescription)
//			}
//		} else if finalName != ""{
//			let alert = UIAlertController(title: "Error in Goal Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new goal.", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//			self.present(alert, animated: true)
//		} else {
//			let alert = UIAlertController(title: "Error in Goal Creation", message: "You must give your new goal a title.", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//			self.present(alert, animated: true)
//		}
	}
	
	func saveNewTeam(){
		if (toLocal || toDrive) && (finalName != ""){
			
		} else if finalName != ""{
			let alert = UIAlertController(title: "Error in Team Creation", message: "You must chose to at least have either a Local Copy or let your file Store in Cloud to create a new team.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		} else {
			let alert = UIAlertController(title: "Error in Team Creation", message: "You must give your new team a title.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	func uploadFileToDrive(address: URL?, completion: @escaping(Bool, String) -> Void){
		if address != nil {
			GoogleDriveTools.uploadFileToDrive(name: finalName, fileURL: address!, thumbnail: (controller.addItemKindSelected == "newFile") ? nil : itemImage[0], mimeType: "application/alexandria", parent: controller.realm.objects(CloudUser.self).first!.alexandria!.filesFolderID!, service: GoogleDriveTools.service, completion: {(id, success) in
				completion(success, id)
			})
		}
	}
}
