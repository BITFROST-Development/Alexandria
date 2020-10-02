//
//  Socket.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/2/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import SocketIO
import RealmSwift

class Socket {
    let realm = AppDelegate.realm
    let manager = SocketManager(socketURL: URL(string: "https://api.bitfrost.app")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    var delegate: SocketDelegate!
    static let sharedInstance = Socket()
    
    public init() {
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
        socket.on("alexandriaUpdate"){(data, ack) -> Void in
            
        }
        AppDelegate.socketShouldAct = true
    }
    
    func closeConnection() {
        Socket.sharedInstance.manager.disconnect()
        socket.removeAllHandlers()
        socket.disconnect()
        AppDelegate.socketShouldAct = false
    }
    
    func connectWithUsername(username: String){
        socket.on("connection"){ (data, ack) -> Void in
            self.socket.emit("join", ["username": username, "source": "\(username)Alexandria"])
        }
    }
    
    func registerFolders(username: String, rootFolderID: String, booksFolderID: String){
        var emitions = 0
        socket.emit("alexandriaUpdate", ["kind": "update", "username": username, "path": "rootFolderID", "field": "\(rootFolderID)"], completion: {
            emitions += 1
        })
        socket.on("updated", callback: {_,_ in
            if emitions < 2 {
                self.socket.emit("alexandriaUpdate", ["kind": "update", "username": username, "path": "booksFolderID", "field": "\(booksFolderID)"])
                emitions += 1
            }
        })
    }
    
    func updateAlexandriaCloud(username: String, alexandriaInfo: AlexandriaDataDec){
        socket.emit("alexandriaUpdate", ["kind": "update", "username": username, "field": String(data: try! JSONEncoder().encode(alexandriaInfo), encoding: .utf8)])
    }
    
    func uploadShelf(username: String, shelfInfo: ShelfDec, path: String){
        socket.emit("alexandriaUpdate", ["kind": "addition", "username": username, "path": path, "field": String(data: try! JSONEncoder().encode(shelfInfo), encoding: .utf8)])
    }
}
