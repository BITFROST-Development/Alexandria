//
//  Socket.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/2/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import SocketIO

class Socket {
    
    
    
    let manager = SocketManager(socketURL: URL(string: "https://api.bitfrost.app")!, config: [.log(false), .compress])
    var socket:SocketIOClient!
    static let sharedInstance = Socket()
    
    public init() {
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
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
            self.socket.emit("join", ["username": username, "source": "\(username)merenda"])
        }
    }
    
}
