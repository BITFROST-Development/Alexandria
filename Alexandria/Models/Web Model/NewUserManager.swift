//
//  NewUserManager.swift
//  Merenda
//
//  Created by Waynar Bocangel on 6/6/20.
//  Copyright © 2020 BitFrost. All rights reserved.
//

import Foundation
import RealmSwift
import GTMAppAuth
import GAppAuth

class NewUserManager{
    
    static let realm = try! Realm(configuration: AppDelegate.realmConfig)
    
    static func createNewCloudUser(username: UserData) {
        let logedUser = CloudUser()
        logedUser.name = username.name!
        logedUser.lastname = username.lastName!
        logedUser.username = username.username!
        logedUser.email = username.email!
        logedUser.subscription = username.subscription!
        logedUser.subscriptionStatus = username.subscriptionStatus!
        logedUser.daysLeftOnSubscription.value = username.daysLeftOnSubscription
        logedUser.googleAccountEmail = username.googleAccountEmail!
        for index in 0 ..< (username.teamIDs?.count ?? 0){
            logedUser.teamIDs[index] = username.teamIDs![0]
            
        }
        
        if username.alexandria != nil {
            logedUser.alexandriaData! ^ username.alexandria!
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandriaData != nil{
                
                if unloggedUser[0].alexandriaData!.goals.count != 0{
                    if logedUser.alexandriaData!.goals.count == 0{
                        logedUser.alexandriaData!.goals = unloggedUser[0].alexandriaData!.goals
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.goals.count{
                            logedUser.alexandriaData?.goals.append((unloggedUser[0].alexandriaData?.goals[goal])!)
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.trophies.count != 0{
                    if logedUser.alexandriaData!.trophies.count == 0{
                        logedUser.alexandriaData!.trophies = unloggedUser[0].alexandriaData!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.trophies.count{
                            logedUser.alexandriaData!.trophies.append(unloggedUser[0].alexandriaData!.trophies[goal])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.shelves.count != 0{
                    if logedUser.alexandriaData!.shelves.count == 0{
                        logedUser.alexandriaData!.shelves = unloggedUser[0].alexandriaData!.shelves
                    }
                    else{
                        for shelf in 0..<unloggedUser[0].alexandriaData!.shelves.count{
                            logedUser.alexandriaData!.shelves.append(unloggedUser[0].alexandriaData!.shelves[shelf])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.vaults.count != 0{
                    if logedUser.alexandriaData!.vaults.count == 0{
                        logedUser.alexandriaData!.vaults = unloggedUser[0].alexandriaData!.vaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.vaults.count{
                            logedUser.alexandriaData!.vaults.append(unloggedUser[0].alexandriaData!.vaults[vault])
                        }
                    }
                }
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
                if unloggedUser.count != 0{
                    realm.delete(unloggedUser[0].alexandriaData!)
                    realm.delete(unloggedUser)
                }
            }
        }catch {
            print(error)
        }
    }
    
    static func registerNewCloudUser(username: UserData) -> CloudUser{
        let logedUser = CloudUser()
        logedUser.name = username.name!
        logedUser.lastname = username.lastName!
        logedUser.username = username.username!
        logedUser.email = username.email!
        logedUser.subscription = username.subscription!
        logedUser.subscriptionStatus = username.subscriptionStatus!
        logedUser.daysLeftOnSubscription.value = username.daysLeftOnSubscription
        logedUser.googleAccountEmail = (GoogleSignIn.sharedInstance().email)!
        for index in 0 ..< (username.teamIDs?.count ?? 0){
            logedUser.teamIDs[index] = username.teamIDs![0]
        }
        
        if username.alexandria != nil{
            logedUser.alexandriaData! ^ username.alexandria!
        }
        
        let unloggedUser = realm.objects(UnloggedUser.self)
        
        if unloggedUser.count != 0{
            if unloggedUser[0].alexandriaData != nil{
                
                if unloggedUser[0].alexandriaData!.goals.count != 0{
                    if logedUser.alexandriaData!.goals.count == 0{
                        logedUser.alexandriaData!.goals = unloggedUser[0].alexandriaData!.goals
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.goals.count{
                            logedUser.alexandriaData?.goals.append((unloggedUser[0].alexandriaData?.goals[goal])!)
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.trophies.count != 0{
                    if logedUser.alexandriaData!.trophies.count == 0{
                        logedUser.alexandriaData!.trophies = unloggedUser[0].alexandriaData!.trophies
                    }
                    else{
                        for goal in 0..<unloggedUser[0].alexandriaData!.trophies.count{
                            logedUser.alexandriaData!.trophies.append(unloggedUser[0].alexandriaData!.trophies[goal])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.shelves.count != 0{
                    if logedUser.alexandriaData!.shelves.count == 0{
                        logedUser.alexandriaData!.shelves = unloggedUser[0].alexandriaData!.shelves
                    }
                    else{
                        for shelf in 0..<unloggedUser[0].alexandriaData!.shelves.count{
                            logedUser.alexandriaData!.shelves.append(unloggedUser[0].alexandriaData!.shelves[shelf])
                        }
                    }
                }
                if unloggedUser[0].alexandriaData!.vaults.count != 0{
                    if logedUser.alexandriaData!.vaults.count == 0{
                        logedUser.alexandriaData!.vaults = unloggedUser[0].alexandriaData!.vaults
                    }
                    else{
                        for vault in 0..<unloggedUser[0].alexandriaData!.vaults.count{
                            logedUser.alexandriaData!.vaults.append(unloggedUser[0].alexandriaData!.vaults[vault])
                        }
                    }
                }
            }
        }

        do{
            try realm.write{
                realm.add(logedUser)
                if unloggedUser.count != 0{
                    realm.delete(unloggedUser[0].alexandriaData!)
                    realm.delete(unloggedUser)
                }
            }
        }catch {
            print(error)
        }
        
        return logedUser
    }
    
}
