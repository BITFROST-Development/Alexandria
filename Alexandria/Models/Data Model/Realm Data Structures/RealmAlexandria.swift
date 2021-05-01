//
//  RealmDataStructure.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/7/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import UIKit
import RealmSwift


/**

 # Related Classes:
    * Object
    * RealmOptionalType
 
 # Description:
    The base object containing all user data related to alexandria.
 
 
 # Static Methods:
    ==
 
    equals
 
    ^
 
    instantiateDefaults
 
    copyDefaults
 
 
 # Instance Methods:
    isEmpty
 
 # Instance Variables:
    * rootFolderID:
        * ID of the root folder for the app in Google Drive
    * filesFolderID:
        * ID of the folder where all files will be saved in Drive
    * home:
        * List of ordered sections in the home view
    * cloudCollections:
        * Collections synced with the cloud
    * localCollections:
        * Collections being stored localy
    * cloudFolders:
        * Folders synced with the cloud
    * localFolders:
        * Folders being stored localy
    * cloudBooks:
        * Books stored in Google Drive
    * localBooks:
        * Books stored localy
    * cloudNotebooks:
        * Notebooks stored in Google Drive
    * localNotebooks:
        * Notebooks stored localy
    * cloudTermSets:
        * Sets synced with the cloud
    * localTermSets:
        * Sets stored localy
    * cloudGoals:
        * Goals synced with the cloud
    * localGoals:
        * Goals stored localy
    * trophies:
        * Trophies
 
 # Default Editing Values
    * defaultPaperStyle
    * defaultCoverStyle
    * defaultPaperColor
    * defaultPaperOrientation
    * defaultWritingToolThickness01
    * defaultWritingToolThickness02
    * defaultWritingToolThickness03
    * defaultWritingToolColor01
    * defaultWritingToolColor02
    * defaultWritingToolColor03
    * defaultEraserToolThickness01
    * defaultEraserToolThickness02
    * defaultEraserToolThickness03
    * defaultHighlighterToolThickness01
    * defaultHighlighterToolThickness02
    * defaultHighlighterToolThickness03
    * defaultHighlighterToolColor01
    * defaultHighlighterToolColor02
    * defaultHighlighterToolColor03
    * defaultTextToolFont
    
 
 */
class AlexandriaData: Object, RealmOptionalType{
    @objc dynamic var rootFolderID: String?
    @objc dynamic var filesFolderID: String?
    @objc dynamic var defaultPaperStyle: String?
    @objc dynamic var defaultCoverStyle: String?
    @objc dynamic var defaultPaperColor: String?
    @objc dynamic var defaultPaperOrientation: String?
	var editorTools = RealmSwift.List<ItemIDWrapper>()
	var inkTools = RealmSwift.List<InkTool>()
	var textTools = RealmSwift.List<TextTool>()
	var imageTools = RealmSwift.List<ImageTool>()
	var staticTools = RealmSwift.List<StaticTool>()
    var home = RealmSwift.List<HomeItem>()
    var cloudCollections = RealmSwift.List<FileCollection>()
    var localCollections = RealmSwift.List<FileCollection>()
    var cloudFolders = RealmSwift.List<Folder>()
    var localFolders = RealmSwift.List<Folder>()
    var cloudBooks = RealmSwift.List<Book>()
    var localBooks = RealmSwift.List<Book>()
    var cloudNotebooks = RealmSwift.List<Notebook>()
    var localNotebooks = RealmSwift.List<Notebook>()
    var cloudTermSets = RealmSwift.List<TermSet>()
    var localTermSets = RealmSwift.List<TermSet>()
    var cloudGoals = RealmSwift.List<Goal>()
    var localGoals = RealmSwift.List<Goal>()
    var trophies = RealmSwift.List<Trophy>()
    
    static func == (lhs: AlexandriaData, rhs: AlexandriaData) -> Bool {
		if lhs.rootFolderID != rhs.rootFolderID || lhs.home != rhs.home || lhs.filesFolderID != rhs.filesFolderID || lhs.cloudGoals != rhs.cloudGoals || lhs.localGoals != rhs.localGoals || lhs.trophies != rhs.trophies || lhs.cloudCollections != rhs.cloudCollections || lhs.cloudFolders != rhs.cloudFolders || lhs.localCollections != rhs.localCollections || lhs.localFolders != rhs.localFolders || lhs.cloudBooks != rhs.cloudBooks || lhs.localBooks != rhs.localBooks || lhs.cloudNotebooks != rhs.cloudNotebooks || lhs.localNotebooks != rhs.localNotebooks || lhs.cloudTermSets != rhs.cloudTermSets || lhs.localTermSets != rhs.localTermSets || lhs.defaultPaperStyle != rhs.defaultPaperStyle || lhs.defaultCoverStyle != rhs.defaultCoverStyle || lhs.defaultPaperColor != rhs.defaultPaperColor || lhs.defaultPaperOrientation != rhs.defaultPaperOrientation || lhs.editorTools != rhs.editorTools || lhs.inkTools != rhs.inkTools || lhs.textTools != rhs.textTools || lhs.imageTools != rhs.imageTools || lhs.staticTools != rhs.staticTools{
            return false
        }
        
        return true
    }
    
    static func equals(_ localAlexandria: AlexandriaData, _ decodedAlexandria: AlexandriaDataDec) -> Bool {
		if localAlexandria.rootFolderID != decodedAlexandria.rootFolderID || localAlexandria.home.count != decodedAlexandria.home?.count || localAlexandria.filesFolderID != decodedAlexandria.filesFolderID || localAlexandria.defaultPaperStyle != decodedAlexandria.defaultPaperStyle || localAlexandria.defaultCoverStyle != decodedAlexandria.defaultCoverStyle || localAlexandria.defaultPaperColor != decodedAlexandria.defaultPaperColor || localAlexandria.cloudGoals.count != decodedAlexandria.goals?.count || localAlexandria.trophies.count != decodedAlexandria.trophies?.count || localAlexandria.cloudBooks.count != decodedAlexandria.books?.count || localAlexandria.cloudNotebooks.count != decodedAlexandria.notebooks?.count || localAlexandria.cloudTermSets.count != decodedAlexandria.termSets?.count || localAlexandria.cloudCollections.count != decodedAlexandria.collections?.count || localAlexandria.cloudFolders.count != decodedAlexandria.folders?.count || localAlexandria.defaultPaperOrientation != decodedAlexandria.defaultPaperOrientation || localAlexandria.editorTools.count != decodedAlexandria.editorTools?.count || localAlexandria.inkTools.count != decodedAlexandria.inkTools?.count || localAlexandria.textTools.count != decodedAlexandria.textTools?.count || localAlexandria.imageTools.count != decodedAlexandria.imageTools?.count || localAlexandria.staticTools.count != decodedAlexandria.staticTools?.count{
            return false
        } else {
			
			for index in 0..<(decodedAlexandria.editorTools?.count ?? 0){
				if localAlexandria.editorTools[index].value != decodedAlexandria.editorTools![index]{
					return false
				}
			}
			
			for index in 0..<(decodedAlexandria.inkTools?.count ?? 0){
				if localAlexandria.inkTools[index] != decodedAlexandria.inkTools![index]{
					return false
				}
			}
			
			for index in 0..<(decodedAlexandria.textTools?.count ?? 0){
				if localAlexandria.textTools[index] != decodedAlexandria.textTools![index]{
					return false
				}
			}
			
			for index in 0..<(decodedAlexandria.imageTools?.count ?? 0){
				if localAlexandria.imageTools[index] != decodedAlexandria.imageTools![index]{
					return false
				}
			}
			
			for index in 0..<(decodedAlexandria.staticTools?.count ?? 0){
				if localAlexandria.staticTools[index] != decodedAlexandria.staticTools![index]{
					return false
				}
			}
			
			for index in 0..<(decodedAlexandria.home?.count ?? 0){
                if localAlexandria.home[index] != decodedAlexandria.home![index]{
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.goals?.count ?? 0){
                if !Goal.equals(lhs: localAlexandria.cloudGoals[index], rhs: decodedAlexandria.goals?[index]) {
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.trophies?.count ?? 0){
                if !Trophy.equals(lhs: localAlexandria.trophies[index], rhs: decodedAlexandria.trophies?[index]){
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.collections?.count ?? 0){
                if localAlexandria.cloudCollections[index].personalID != decodedAlexandria.collections![index].personalID ||
                localAlexandria.cloudCollections[index].name != decodedAlexandria.collections![index].name{
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.folders?.count ?? 0){
                if localAlexandria.cloudFolders[index] != decodedAlexandria.folders![index]{
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.books?.count ?? 0){
                if !Book.equals(lhs: localAlexandria.cloudBooks[index], rhs: decodedAlexandria.books![index]){
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.notebooks?.count ?? 0){
                if  localAlexandria.cloudNotebooks[index] != decodedAlexandria.notebooks![index]{
                    return false
                }
            }
            
            for index in 0..<(decodedAlexandria.termSets?.count ?? 0){
                if TermSet.equals(localAlexandria.cloudTermSets[index], decodedAlexandria.termSets![index]){
                    return false
                }
            }
            
            return true
        }
    }
    
    static func ^ (lhs: AlexandriaData, rhs: AlexandriaDataDec){
        
        lhs.rootFolderID = rhs.rootFolderID
        lhs.filesFolderID = rhs.filesFolderID
		lhs.defaultPaperStyle = rhs.defaultPaperStyle
		lhs.defaultCoverStyle = rhs.defaultCoverStyle
		lhs.defaultPaperOrientation = rhs.defaultPaperOrientation
		
		if lhs.editorTools.count != 0 {
			var tools = Array(lhs.editorTools)
			do{
				try AppDelegate.realm.write({
					lhs.editorTools.removeAll()
					while tools.count > 0{
						let tool = tools[0]
						tools.removeFirst()
						AppDelegate.realm.delete(tool)
					}
				})
			} catch let error {
				print(error.localizedDescription)
				return
			}
		}
		
		if lhs.inkTools.count != 0 {
			var tools = Array(lhs.inkTools)
			do{
				try AppDelegate.realm.write({
					lhs.inkTools.removeAll()
					while tools.count > 0{
						let tool = tools[0]
						tools.removeFirst()
						AppDelegate.realm.delete(tool)
					}
				})
			} catch let error {
				print(error.localizedDescription)
				return
			}
		}
		
		if lhs.textTools.count != 0 {
			var tools = Array(lhs.textTools)
			do{
				try AppDelegate.realm.write({
					lhs.textTools.removeAll()
					while tools.count > 0{
						let tool = tools[0]
						tools.removeFirst()
						AppDelegate.realm.delete(tool)
					}
				})
			} catch let error {
				print(error.localizedDescription)
				return
			}
		}
		
		if lhs.imageTools.count != 0 {
			var tools = Array(lhs.imageTools)
			do{
				try AppDelegate.realm.write({
					lhs.imageTools.removeAll()
					while tools.count > 0{
						let tool = tools[0]
						tools.removeFirst()
						AppDelegate.realm.delete(tool)
					}
				})
			} catch let error {
				print(error.localizedDescription)
				return
			}
		}
		
		if lhs.staticTools.count != 0 {
			var tools = Array(lhs.staticTools)
			do{
				try AppDelegate.realm.write({
					lhs.staticTools.removeAll()
					while tools.count > 0{
						let tool = tools[0]
						tools.removeFirst()
						AppDelegate.realm.delete(tool)
					}
				})
			} catch let error {
				print(error.localizedDescription)
				return
			}
		}
		
		if lhs.cloudGoals.count != 0 {
            var goals = Array(lhs.cloudGoals)
            do{
                try AppDelegate.realm.write({
					lhs.cloudGoals.removeAll()
					while goals.count > 0{
						let goal = goals[0]
						goals.removeFirst()
                        AppDelegate.realm.delete(goal)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.trophies.count != 0 {
            var trophies = Array(lhs.trophies)
            do{
                try AppDelegate.realm.write({
					lhs.trophies.removeAll()
					while trophies.count > 0{
						let trophy = trophies[0]
						trophies.removeFirst()
                        AppDelegate.realm.delete(trophy)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.cloudBooks.count != 0 {
            var books = Array(lhs.cloudBooks)
            do{
                try AppDelegate.realm.write({
					lhs.cloudBooks.removeAll()
					while books.count > 0{
						let book = books[0]
						books.removeFirst()
                        AppDelegate.realm.delete(book)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.cloudNotebooks.count != 0 {
            var notebooks = Array(lhs.cloudNotebooks)
            do{
                try AppDelegate.realm.write({
					lhs.cloudNotebooks.removeAll()
					while notebooks.count > 0{
						let notebook = notebooks[0]
						notebooks.removeFirst()
                        AppDelegate.realm.delete(notebook)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.cloudTermSets.count != 0 {
            var termSets = Array(lhs.cloudTermSets)
            do{
                try AppDelegate.realm.write({
					lhs.cloudTermSets.removeAll()
					while termSets.count > 0{
						let termSet = termSets[0]
						termSets.removeFirst()
                        AppDelegate.realm.delete(termSet)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.cloudFolders.count != 0 {
            var folders = Array(lhs.cloudFolders)
            do{
                try AppDelegate.realm.write({
					lhs.cloudFolders.removeAll()
					while folders.count > 0{
						let folder = folders[0]
						folders.removeFirst()
                        AppDelegate.realm.delete(folder)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.cloudCollections.count != 0 {
            var collections = Array(lhs.cloudCollections)
            do{
                try AppDelegate.realm.write({
					lhs.cloudCollections.removeAll()
					while collections.count > 0{
						let collection = collections[0]
						collections.removeFirst()
                        AppDelegate.realm.delete(collection)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if lhs.home.count != 0 {
            var homeList = Array(lhs.home)
            do{
                try AppDelegate.realm.write({
					lhs.home.removeAll()
					while homeList.count > 0{
						let item = homeList[0]
						homeList.removeFirst()
                        AppDelegate.realm.delete(item)
                    }
                })
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
		
		for tool in rhs.editorTools ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.editorTools.append(ItemIDWrapper(tool))
				})
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		for tool in rhs.inkTools ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.inkTools.append(InkTool(tool))
				})
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		for tool in rhs.textTools ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.textTools.append(TextTool(tool))
				})
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		for tool in rhs.imageTools ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.imageTools.append(ImageTool(tool))
				})
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		for tool in rhs.staticTools ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.staticTools.append(StaticTool(tool))
				})
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		for item in rhs.home ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.home.append(HomeItem(item))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for goal in rhs.goals ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudGoals.append(Goal(goal))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for trophy in rhs.trophies ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.trophies.append(Trophy(trophy))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for book in rhs.books ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudBooks.append(Book(book))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for note in rhs.notebooks ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudNotebooks.append(Notebook(note))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for set in rhs.termSets ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudTermSets.append(TermSet(set))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for folder in rhs.folders ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudFolders.append(Folder(folder))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
        for collection in rhs.collections ?? []{
			do{
				try AppDelegate.realm.write({
					lhs.cloudCollections.append(FileCollection(collection))
				})
			} catch let error {
				print(error.localizedDescription)
			}
        }
        
    }
    
    static func instantiateDefaults(lhs: AlexandriaData, rhs: AlexandriaData){
		lhs.editorTools = rhs.editorTools
        lhs.defaultPaperStyle = rhs.defaultPaperStyle
        lhs.defaultCoverStyle = rhs.defaultCoverStyle
        lhs.defaultPaperColor = rhs.defaultPaperColor
        lhs.defaultPaperOrientation = rhs.defaultPaperOrientation
    }
    
    static func copyDefaults(lhs: AlexandriaData, rhs: AlexandriaDataDec){
		lhs.editorTools.removeAll()
		for tool in rhs.editorTools ?? []{
			lhs.editorTools.append(ItemIDWrapper(tool))
		}
		lhs.inkTools.removeAll()
		for tool in rhs.inkTools ?? []{
			lhs.inkTools.append(InkTool(tool))
		}
		lhs.textTools.removeAll()
		for tool in rhs.textTools ?? []{
			lhs.textTools.append(TextTool(tool))
		}
		lhs.imageTools.removeAll()
		for tool in rhs.imageTools ?? []{
			lhs.imageTools.append(ImageTool(tool))
		}
		lhs.staticTools.removeAll()
		for tool in rhs.staticTools ?? []{
			lhs.staticTools.append(StaticTool(tool))
		}
        lhs.defaultPaperStyle = rhs.defaultPaperStyle
        lhs.defaultCoverStyle = rhs.defaultCoverStyle
        lhs.defaultPaperColor = rhs.defaultPaperColor
    }
    
    func isEmpty() -> Bool{
        if self.cloudGoals.count == 0 && self.localGoals.count == 0 && self.trophies.count == 0 && self.cloudCollections.count == 0 && self.localCollections.count == 0 && self.cloudFolders.count == 0 && self.localFolders.count == 0 && self.cloudNotebooks.count == 0 && self.localNotebooks.count == 0 && self.cloudTermSets.count == 0 && self.localTermSets.count == 0 && self.cloudBooks.count == 0 && self.localBooks.count == 0{
            return true
        }
        
        return false
        
    }
}


class HomeItem: Object {
    @objc dynamic var type: String?
    @objc dynamic var name: String?
    @objc dynamic var sorting: String?
    
    convenience init(_ itemType: String?, _ itemName: String?, _ itemSorting: String?) {
        self.init()
        type = itemType
        name = itemName
        sorting = itemSorting
    }
    
    convenience init(_ decHome: HomeItemDec) {
        self.init()
        type = decHome.type
        name = decHome.name
        sorting = decHome.sorting
    }
    
    static func != (_ lhs: HomeItem, _ rhs: HomeItemDec?) -> Bool{
        if lhs.type != rhs?.type || lhs.name != rhs?.name || lhs.sorting != rhs?.sorting{
            return true
        }
        return false
    }
}


