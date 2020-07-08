//
//  loginManager.swift
//  Merenda
//
//  Created by Waynar Bocangel on 5/23/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import SocketIO

class RequestManager{
    
    let socket = Socket.sharedInstance
    let bitfrosturl = "https://api.bitfrost.app/?a=940845649127513"
    var result:UserData? = nil
    let sem = DispatchSemaphore.init(value: 0)
    
    func loginUser(username: String, password: String) -> UserData? {
        
        let pass = formatString(message: password)
        let user = formatString(message: username)
        let urlstring = "\(bitfrosturl)&h=true&u=\(user)&p=\(pass)"
        let returnData = performRequest(urlString: urlstring)
        socket.establishConnection()
        socket.connectWithUsername(username: username)
        return returnData
    }
    
    func registerUser(username: String, password: String, name: String, last: String, email: String, gmail: String) -> UserData?{
        
        let pass = formatString(message: password)
        let user = formatString(message: username)
        let firstName = formatString(message: name)
        let lastName = formatString(message: last)
        let mail = formatString(message: email)
        let googleMail = formatString(message: gmail)
        
        let urlstring = "\(bitfrosturl)&x=true&u=\(user)&p=\(pass)&r=\(firstName)&n=\(lastName)&q=\(mail)&j=\(googleMail)"
        
        let returnData = performRequest(urlString: urlstring)
        socket.establishConnection()
        socket.connectWithUsername(username: username)
        return returnData
        
    }
    
    func logOut() {
        socket.closeConnection()
        Socket.sharedInstance.socket.leaveNamespace()
    }
    
    func checkForUsername(username: String) -> Bool {
        
        let user = formatString(message: username)
        
        let urlstring = "\(bitfrosturl)&u=\(user)"
        
        if performRequest(urlString: urlstring)?.username != nil {
            return false
        }
        
        return true
        
    }
    
    func performRequest(urlString: String)->UserData?{
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data{
                    self.result = self.parseJSON(userData: safeData)
                    self.sem.signal()
                }
            }
            
            task.resume()
            
            sem.wait()
            
            return result
        }
        
        return nil
    }
    
    func parseJSON(userData: Data)->UserData?{
        let decoder = JSONDecoder()
        do{
            let user = try decoder.decode(UserData.self, from: userData)

            return user
            
        }catch{
            print(error)
            return nil
        }
    }
    
    func formatString(message: String) -> String {
        var msg = ""
        for letter in message{
            switch letter {
            case "$":
                msg = msg + "%24"
            case "&":
                msg = msg + "%26"
            case "+":
                msg = msg + "%2B"
            case ",":
                msg = msg + "%2C"
            case "/":
                msg = msg + "%2F"
            case ":":
                msg = msg + "%3A"
            case ";":
                msg = msg + "%3B"
            case "=":
                msg = msg + "%3D"
            case "?":
                msg = msg + "%3F"
            case "@":
                msg = msg + "%40"
            case " ":
                msg = msg + "%20"
            case "\"":
                msg = msg + "%22"
            case "<":
                msg = msg + "%3C"
            case ">":
                msg = msg + "%3E"
            case "#":
                msg = msg + "%23"
            case "%":
                msg = msg + "%25"
            case "{":
                msg = msg + "%7B"
            case "}":
                msg = msg + "%7D"
            case "|":
                msg = msg + "%5C"
            case "\\":
                msg = msg + "%5C"
            case "^":
                msg = msg + "%5E"
            case "~":
                msg = msg + "%7E"
            case "[":
                msg = msg + "%5B"
            case "]":
                msg = msg + "%5D"
            case "`":
                msg = msg + "%60"
            default:
                msg = msg + String(letter)
            }
        }
        return msg
    }
}
