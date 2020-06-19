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
    
    static let sharedInstance = Socket()
    
    let manager = SocketManager(socketURL: URL(string: "https://api.bitfrost.app")!, config: [.log(true), .compress])
    
    var socket:SocketIOClient!
    
    public init() {
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectWithUsername(username: String){
        socket.on("connection"){ (data, ack) -> Void in
            self.socket.emit("join", ["username": username, "source": "\(username)merenda"])
        }
        
//        socket.on("merendaUpdate"){ (data, ack) -> Void in
//            UpdateManager.receiveMerenda(data: data)
//        }
    }
    
}
