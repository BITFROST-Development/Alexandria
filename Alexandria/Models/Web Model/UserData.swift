//
//  UserData.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/24/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import UIKit
import RealmSwift

struct UserData: Codable{
    let name: String?
    let lastName: String?
    let username: String?
    let email: String?
    let subscription: String?
    let subscriptionStatus: String?
    let daysLeftOnSubscription: Int?
    let googleAccountEmail: String?
	var friendList: [FriendDec]?
    let teamIDs: [String]?
    let alexandria: AlexandriaDataDec?
    let gigantic: GiganticDataDec?
}

struct AlexandriaDataDec: Codable{
    var rootFolderID: String?
    var filesFolderID: String?
    var defaultPaperStyle: String?
    var defaultCoverStyle: String?
    var defaultPaperColor: String?
    var defaultPaperOrientation: String?
	var editorTools: [String]?
	var inkTools: [InkToolDec]?
	var textTools: [TextToolDec]?
	var imageTools: [ImageToolDec]?
	var staticTools: [StaticToolDec]?
    var home: [HomeItemDec]?
    var collections: [FileCollectionDec]?
    var folders: [FolderDec]?
    var books: [BookDec]?
    var notebooks: [NotebookDec]?
    var termSets: [TermSetDec]?
    var goals: [GoalDec]?
    var trophies: [TrophyDec]?
    
    
    init(){}
    
    init(_ forCloud: Bool){
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let user = realm.objects(CloudUser.self)[0]
        
        rootFolderID = user.alexandria?.rootFolderID
        filesFolderID = user.alexandria?.filesFolderID
        defaultPaperStyle = user.alexandria?.defaultPaperStyle
        defaultCoverStyle = user.alexandria?.defaultCoverStyle
        defaultPaperColor = user.alexandria?.defaultPaperColor
        defaultPaperOrientation = user.alexandria?.defaultPaperOrientation
		editorTools = []
		inkTools = []
		textTools = []
		imageTools = []
		staticTools = []
        collections = []
        folders = []
        books = []
        notebooks = []
        termSets = []
        goals = []
        trophies = []
        
		for tool in user.alexandria!.editorTools{
			editorTools!.append(tool.value ?? "")
		}
		
		for tool in user.alexandria!.inkTools{
			inkTools!.append(InkToolDec(tool))
		}
		
		for tool in user.alexandria!.textTools{
			textTools!.append(TextToolDec(tool))
		}
		
		for tool in user.alexandria!.imageTools{
			imageTools!.append(ImageToolDec(tool))
		}
		
		for tool in user.alexandria!.staticTools{
			staticTools!.append(StaticToolDec(tool))
		}
		
        for item in user.alexandria!.home{
            home?.append(HomeItemDec(item))
        }
        
        for collection in user.alexandria!.cloudCollections{
            collections?.append(FileCollectionDec(collection))
        }
        
        for folder in user.alexandria!.cloudFolders{
            folders?.append(FolderDec(folder))
        }
        
        for book in user.alexandria!.cloudBooks{
            books?.append(BookDec(book))
        }
        
        for notebook in user.alexandria!.cloudNotebooks{
            notebooks?.append(NotebookDec(notebook))
        }
        
        for set in user.alexandria!.cloudTermSets{
            termSets?.append(TermSetDec(set))
        }
        
        for goal in user.alexandria!.cloudGoals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandria!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
    }
    
    init(from user: CloudUser) {
        rootFolderID = user.alexandria?.rootFolderID
        filesFolderID = user.alexandria?.filesFolderID
        defaultPaperStyle = user.alexandria?.defaultPaperStyle
        defaultCoverStyle = user.alexandria?.defaultCoverStyle
        defaultPaperColor = user.alexandria?.defaultPaperColor
        defaultPaperOrientation = user.alexandria?.defaultPaperOrientation
		editorTools = []
		inkTools = []
		textTools = []
		imageTools = []
		staticTools = []
        home = []
        collections = []
        folders = []
        notebooks = []
        termSets = []
        goals = []
        trophies = []
        books = []
		
		for tool in user.alexandria!.editorTools{
			editorTools!.append(tool.value ?? "")
		}
		
		for tool in user.alexandria!.inkTools{
			inkTools!.append(InkToolDec(tool))
		}
		
		for tool in user.alexandria!.textTools{
			textTools!.append(TextToolDec(tool))
		}
		
		for tool in user.alexandria!.imageTools{
			imageTools!.append(ImageToolDec(tool))
		}
		
		for tool in user.alexandria!.staticTools{
			staticTools!.append(StaticToolDec(tool))
		}
		
        for item in user.alexandria!.home{
            home?.append(HomeItemDec(item))
        }
        
        for collection in user.alexandria!.cloudCollections{
            collections?.append(FileCollectionDec(collection))
        }
        
        for folder in user.alexandria!.cloudFolders{
            folders?.append(FolderDec(folder))
        }
        
        for book in user.alexandria!.cloudBooks{
            books?.append(BookDec(book))
        }
        
        for notebook in user.alexandria!.cloudNotebooks{
            notebooks?.append(NotebookDec(notebook))
        }
        
        for set in user.alexandria!.cloudTermSets{
            termSets?.append(TermSetDec(set))
        }
        
        for goal in user.alexandria!.cloudGoals{
            goals?.append(GoalDec(storedGoal: goal))
        }
        
        for trophy in user.alexandria!.trophies{
            trophies?.append(TrophyDec(storedTrophy: trophy))
        }
        
    }
    
    static func == (lhs: AlexandriaDataDec, rhs: AlexandriaDataDec) -> Bool {
		if lhs.rootFolderID != rhs.rootFolderID || lhs.filesFolderID != rhs.filesFolderID || lhs.defaultPaperStyle != rhs.defaultPaperStyle || lhs.defaultCoverStyle != rhs.defaultCoverStyle || lhs.defaultPaperColor != rhs.defaultPaperColor || lhs.defaultPaperOrientation == rhs.defaultPaperOrientation || lhs.editorTools != rhs.editorTools || lhs.home != rhs.home || lhs.collections != rhs.collections || lhs.goals != rhs.goals || lhs.trophies != rhs.trophies || lhs.folders != rhs.folders || lhs.books != rhs.books || lhs.inkTools != rhs.inkTools || lhs.textTools != rhs.textTools || lhs.imageTools != rhs.imageTools || lhs.staticTools != rhs.staticTools{
            return false
        }
        
        return true
    }
    
}

struct InkToolDec: Codable, Equatable{
	var toolID: String?
	var kind: String?
	var colors: [IconColorDec]?
	var thicknesses: [Double]?
	
	init(){}
	
	init(_ storedInkTool: InkTool){
		self.toolID = storedInkTool.toolID
		self.kind = storedInkTool.kind
		self.colors = []
		for color in storedInkTool.colors{
			self.colors?.append(IconColorDec(color))
		}
		self.thicknesses = []
		for value in storedInkTool.thicknesses{
			self.thicknesses!.append(value.value.value ?? 0)
		}
	}
}

struct TextToolDec: Codable, Equatable{
	var toolID: String?
	var kind: String?
	var fontName: String?
	var fontSize: Double?
	var fontStyle: String?
	var textAlignment: Double?
	var spacing: Double?
	var color: IconColorDec?
	
	init(){}
	
	init(_ storedTextTool: TextTool){
		self.toolID = storedTextTool.toolID
		self.kind = storedTextTool.kind
		self.fontSize = storedTextTool.fontSize.value
		self.fontStyle = storedTextTool.fontStyle
		self.textAlignment = storedTextTool.textAlignment.value
		self.spacing = storedTextTool.spacing.value
		self.color = IconColorDec(storedTextTool.color!)
	}
}

struct ImageToolDec: Codable, Equatable{
	var toolID: String?
	var wrapping: String?
	var colorParameters: [Double]?
	
	init(){}
	
	init(_ storedImageTool: ImageTool){
		self.toolID = storedImageTool.toolID
		self.wrapping = storedImageTool.wrapping
		for value in storedImageTool.colorParameters{
			self.colorParameters?.append(value.value.value ?? 0)
		}
	}
}

struct StaticToolDec: Codable, Equatable{
	var toolID: String?
	var kind: String?
	
	init(){}
	
	init(_ storedStaticTool: StaticTool){
		self.toolID = storedStaticTool.toolID
		self.kind = storedStaticTool.kind
	}
}

struct HomeItemDec: Codable, Equatable {
    var type: String?
    var name: String?
    var sorting: String?
    
    init(){}
    
    init(_ storedHomeItem: HomeItem){
        self.type = storedHomeItem.type
        self.name = storedHomeItem.name
        self.sorting = storedHomeItem.sorting
    }
}

struct FileCollectionDec: Codable, Equatable {
    var personalID: String?
    var childrenIDs: [String]?
    var name: String?
    var color: IconColorDec?
    
    init(){}
    
    init(_ storedCollection: FileCollection){
        self.personalID = storedCollection.personalID
        self.childrenIDs = []
        self.name = storedCollection.name
        self.color = IconColorDec(storedCollection.color!)
        for id in storedCollection.childrenIDs{
            self.childrenIDs?.append(id.value ?? "")
        }
    }
}

struct FolderDec: Codable, Equatable{
    var personalID: String?
    var parentID: String?
    var childrenIDs: [String]?
    var name: String?
    var color: IconColorDec?
    var lastModified: Date?
    var isFavorite: String?
    var sharingIDs: [String]?
    
    init() {}
    
    init(_ storedFolder: Folder){
        self.personalID = storedFolder.personalID
        self.parentID = storedFolder.parentID
        self.childrenIDs = []
        self.name = storedFolder.name
        self.color = IconColorDec(storedFolder.color!)
        self.lastModified = storedFolder.lastModified
        self.isFavorite = storedFolder.isFavorite
        self.sharingIDs = []
        for id in storedFolder.childrenIDs{
            self.childrenIDs?.append(id.value ?? "")
        }
        
        for id in storedFolder.sharingIDs{
            self.sharingIDs?.append(id.value ?? "")
        }
    }
}

struct BookDec: Codable, Equatable{
    var personalID: String?
    var collectionIDs: [String]?
    var parentID: String?
    var driveID: String?
    var lastModified: Date?
    var name: String?
    var author: String?
    var year: String?
    var lastOpened: Date?
    var thumbnail: StoredFileDec?
    var trackerIDs: [String]?
    var sharingIDs: [String]?
    var personalCollectionID: String?
    var currentPage: Double?
    var isFavorite: String?
	var bookmarkedPages: [Double]?
	
    init (){}
    
    init (_ storedBook: Book){
        self.personalID = storedBook.personalID
        self.collectionIDs = []
        for id in storedBook.collectionIDs{
            collectionIDs?.append(id.value ?? "")
        }
        self.parentID = storedBook.parentID
        self.driveID = storedBook.driveID
        self.lastModified = storedBook.lastModified
        self.name = storedBook.name
        self.author = storedBook.author
        self.year = storedBook.year
        self.lastOpened = storedBook.lastOpened
        self.thumbnail = StoredFileDec(storedBook.thumbnail!.name!, storedBook.thumbnail!.data!, storedBook.thumbnail!.contentType!)
        self.trackerIDs = []
        for id in storedBook.trackerIDs{
            trackerIDs?.append(id.value ?? "")
        }
        self.sharingIDs = []
        for id in storedBook.sharingIDs{
            sharingIDs?.append(id.value ?? "")
        }
        self.personalCollectionID = storedBook.personalCollectionID
        self.currentPage = storedBook.currentPage.value
        self.isFavorite = storedBook.isFavorite
    }
}

struct NotebookDec: Codable, Equatable{
    var personalID: String?
    var collectionIDs: [String]?
    var parentID: String?
    var driveID: String?
    var lastModified: Date?
    var name: String?
    var author: String?
    var year: String?
    var lastOpened: Date?
    var coverStyle: String?
    var sheetDefaultStyle: String?
    var sheetDefaultColor: String?
    var sheetDefaultOrientation: String?
    var sheetStyleGroup: [String]?
    var sheetIndexInStyleGroup: [Double]?
    var trackerIDs: [String]?
    var sharingIDs: [String]?
    var personalCollectionID: String?
    var currentPage: Double?
    var isFavorite: String?
	var bookmarkedPages: [Double]?
    
    init(){}
    
    init(_ storedNote: Notebook){
        self.personalID = storedNote.personalID
        self.collectionIDs = []
        for id in storedNote.collectionIDs{
            collectionIDs?.append(id.value ?? "")
        }
        self.parentID = storedNote.parentID
        self.driveID = storedNote.driveID
        self.lastModified = storedNote.lastModified
        self.name = storedNote.name
        self.author = storedNote.author
        self.year = storedNote.year
        self.lastOpened = storedNote.lastOpened
        self.coverStyle = storedNote.coverStyle
        self.sheetDefaultStyle = storedNote.sheetDefaultStyle
        self.sheetDefaultColor = storedNote.sheetDefaultColor
        self.sheetDefaultOrientation = storedNote.sheetDefaultOrientation
        self.sheetStyleGroup = []
        for style in storedNote.sheetStyleGroup{
            self.sheetStyleGroup?.append(style.value ?? "")
        }
        self.sheetIndexInStyleGroup = []
        for index in storedNote.sheetIndexInStyleGroup{
            self.sheetIndexInStyleGroup?.append(index.value.value ?? 0.0)
        }
        self.trackerIDs = []
        for id in storedNote.trackerIDs{
            trackerIDs?.append(id.value ?? "")
        }
        self.sharingIDs = []
        for id in storedNote.sharingIDs{
            sharingIDs?.append(id.value ?? "")
        }
        self.personalCollectionID = storedNote.personalCollectionID
        self.currentPage = storedNote.currentPage.value
        self.isFavorite = storedNote.isFavorite
    }
}

struct TermSetDec: Codable, Equatable{
    var personalID: String?
    var collectionIDs: [String]?
    var parentID: String?
    var lastModified: Date?
    var name: String?
    var author: String?
    var year: String?
    var lastOpened: Date?
    var color: IconColorDec?
    var terms: [TermDec]?
    var trackerIDs: [String]?
    var sharingIDs: [String]?
    var personalCollectionID: String?
    var isFavorite: String?
    
    init() {}
    
    init(_ storedSet: TermSet){
        personalID = storedSet.personalID
        collectionIDs = []
        for id in storedSet.collectionIDs{
            collectionIDs?.append(id.value ?? "")
        }
        parentID = storedSet.parentID
        lastModified = storedSet.lastModified
        name = storedSet.name
        author = storedSet.author
        year = storedSet.year
        lastOpened = storedSet.lastOpened
        color = IconColorDec(storedSet.color!)
        terms = []
        for term in storedSet.terms{
            terms?.append(TermDec(storedTerm: term))
        }
        trackerIDs = []
        for id in storedSet.trackerIDs{
            trackerIDs?.append(id.value ?? "")
        }
        sharingIDs = []
        for id in storedSet.sharingIDs{
            sharingIDs?.append(id.value ?? "")
        }
        personalCollectionID = storedSet.personalCollectionID
        self.isFavorite = storedSet.isFavorite
    }
}

struct TermDec: Codable, Equatable{
    var value: String?
    var definition: String?
    
    init() {}
    
    init(storedTerm: Term){
        value = storedTerm.value
        definition = storedTerm.definition
    }
}

struct GoalDec: Codable, Equatable{
    var personalID: String?
    var name: String?
    var achieved: String?
    var valueToHit: Double?
    var progressList: [GoalContributorDec]?
    var trophyIDs: [String]?
    var type: String?
    var endDate: Date?
	var period: String?
    
    init(){}
    
    init(storedGoal: Goal){
        personalID = storedGoal.personalID
        name = storedGoal.name
        achieved = storedGoal.achieved
        valueToHit = storedGoal.valueToHit.value
        endDate = storedGoal.endDate
		period = storedGoal.period
        progressList = []
        for contribution in storedGoal.progressList {
            progressList?.append(GoalContributorDec(storedGoalContributor: contribution))
        }
        trophyIDs = []
        for id in storedGoal.trophyIDs{
            trophyIDs?.append(id.value ?? "")
        }
        type = storedGoal.type
    }
}

struct GoalContributorDec: Codable, Equatable{
    var contributor: String?
    var progress: Double?
    
    init(){}
    
    init(storedGoalContributor: GoalContributor){
        contributor = storedGoalContributor.contributor
        progress = storedGoalContributor.progress.value
    }
}

struct TrophyDec: Codable, Equatable{
    var personalID: String?
    var name: String?
    var earned: String?
    var progress:Double?
    var type: String?
    
    init() {}
    
    init(storedTrophy: Trophy){
        personalID = storedTrophy.personalID
        name = storedTrophy.name
        earned = storedTrophy.earned
        progress = storedTrophy.progress.value
        type = storedTrophy.type
    }
}

struct IconColorDec: Codable, Equatable{
    var red: Double?
    var green: Double?
    var blue: Double?
    var colorName: String?
    
    init(){
        var cgRed: CGFloat = 0
        var cgGreen: CGFloat = 0
        var cgBlue: CGFloat = 0
        var cgAlpha :CGFloat = 0
        
        UIColor.lightGray.getRed(&cgRed, green: &cgGreen, blue: &cgBlue, alpha: &cgAlpha)
        
        red = Double(cgRed)
        green = Double(cgGreen)
        blue = Double(cgBlue)
        colorName = "light gray"
    }
    
    init(_ storedIcon: IconColor){
        red = storedIcon.red.value
        green = storedIcon.green.value
        blue = storedIcon.blue.value
        colorName = storedIcon.colorName
    }
}

struct StoredFileDec: Codable, Equatable{
    
    var name: String?
    var data: BufferDec?
    var contentType: String?
    
    init(){}
    
    init (_ label: String,_ file: Data,_ type: String) {
        name = label
        data = BufferDec("Buffer", file)
        contentType = type
    }
}

struct BufferDec: Codable, Equatable{
    static func == (lhs: BufferDec, rhs: BufferDec) -> Bool {
        if lhs.type == rhs.type && lhs.data == rhs.data{
            return true
        }
        return false
    }
    
    init (_ kind: String, _ info: Data){
        self.type = kind
        self.data = [UInt8](info)
    }
    
    var type: String?
    var data: [UInt8]?
}

struct FriendDec: Codable, Equatable{
	var personalID: String?
	var name: String?
	
	init(_ storedFriend: Friend){
		self.personalID = storedFriend.personalID
		self.name = storedFriend.name
	}
	
	static func == (lhs: FriendDec, rhs: FriendDec) -> Bool{
		if lhs.personalID == rhs.personalID {
			return true
		}
		return false
	}
}

struct GiganticDataDec: Codable{
    var avatar: StoredFileDec?
}

