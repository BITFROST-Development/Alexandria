//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift
import GTMAppAuth
import GAppAuth

class MyProfileViewController: UIViewController {
    var controller: AuthenticationSource!
    var currentUser: CloudUser?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MyProfileLogoCell", bundle: nil), forCellReuseIdentifier: "logoCell")
        tableView.register(UINib(nibName: "MyProfileNameCell", bundle: nil), forCellReuseIdentifier: "nameCell")
        tableView.register(UINib(nibName: "MyProfileContentCell", bundle: nil), forCellReuseIdentifier: "contentCell")
        tableView.register(UINib(nibName: "MyProfileLogoutCell", bundle: nil), forCellReuseIdentifier: "logoutCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Socket.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let myShelves = controller as? MyShelvesViewController{
            myShelves.refreshView()
        } else if let myVaults = controller as? MyVaultsViewController{
            myVaults.refreshView()
        } else if let metrics = controller as? MetricsViewController{
            metrics.refreshView()
        } else if let myTeams = controller as? MyTeamsViewController{
            myTeams.refreshView()
        }
    }
    
    func logoutPressed(){
        let realm = try! Realm(configuration: AppDelegate.realmConfig)
        let logoutRequest = RequestManager()
        let unloggedUser = UnloggedUser()
        let cloudUser = realm.objects(CloudUser.self)[0]
        let overalAlert = UIAlertController(title: "Keep Data", message: "You're loggin out of Alexandria, and some of your data comes from your account, would you like to keep your data on your phone or delete all cloud data", preferredStyle: .alert)
        overalAlert.addAction(UIAlertAction(title: "Keep Data", style: .cancel, handler: {_ in
            do{
                try realm.write(){
                    let hashMap = realm.objects(BookToListMap.self)
                    for book in 0..<cloudUser.alexandriaData!.cloudBooks.count{
                        cloudUser.alexandriaData!.cloudBooks[book].cloudVar.value = false
                        let shelves = hashMap[1].keys[book].values
                        for shelf in shelves {
                            shelf.value?.books[shelf.indexInShelf.value!] = Double(cloudUser.alexandriaData!.localBooks.count)
                            shelf.value?.oppositeBooks.removeAll()
                            hashMap[0].append(key: Double(cloudUser.alexandriaData!.localBooks.count), value: shelf.value!, isCloud: true)
                        }
                        cloudUser.alexandriaData!.localBooks.append(cloudUser.alexandriaData!.cloudBooks[book])
                    }
                    cloudUser.alexandriaData!.cloudBooks.removeAll()
                    for shelf in cloudUser.alexandriaData!.shelves{
                        shelf.cloudVar.value = false
                        cloudUser.alexandriaData!.localShelves.append(shelf)
                    }
                    cloudUser.alexandriaData!.shelves.removeAll()
                    unloggedUser.alexandriaData = cloudUser.alexandriaData
                    realm.add(unloggedUser)
                    realm.delete(hashMap[1])
                    realm.delete(cloudUser)
                    logoutRequest.logOut()
                    GoogleSignIn.sharedInstance().signOut()
                    RegisterLoginViewController.loggedIn = false
                    self.controller.loggedIn = false
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                let alert = UIAlertController(title: "Error Loging Out", message: "We weren't able to log you out. Close the application and try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }))
        overalAlert.addAction(UIAlertAction(title: "Delete Data", style: .destructive, handler: {_ in
            do{
                try realm.write(){
                    let hashMap = realm.objects(BookToListMap.self)
                    for shelf in cloudUser.alexandriaData!.localShelves{
                        shelf.oppositeBooks.removeAll()
                    }
                    for book in cloudUser.alexandriaData!.cloudBooks{
                        book.deleteInformation()
                        realm.delete(book.thumbnail!)
                        realm.delete(book)
                    }
                    cloudUser.alexandriaData?.cloudBooks.removeAll()
                    for shelf in cloudUser.alexandriaData!.shelves{
                        realm.delete(shelf)
                    }
                    cloudUser.alexandriaData?.shelves.removeAll()
                    unloggedUser.alexandriaData = cloudUser.alexandriaData
                    realm.add(unloggedUser)
                    realm.delete(hashMap[1])
                    realm.delete(cloudUser)
                    logoutRequest.logOut()
                    GoogleSignIn.sharedInstance().signOut()
                    RegisterLoginViewController.loggedIn = false
                    self.controller.loggedIn = false
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                let alert = UIAlertController(title: "Error Loging Out", message: "We weren't able to log you out. Close the application and try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }))
        
        present(overalAlert, animated: true)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MyProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell", for: indexPath) as! MyProfileLogoCell
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! MyProfileNameCell
            cell.name.text = "\(currentUser!.name) \(currentUser!.lastname)"
            return cell
        } else if indexPath.row < 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! MyProfileContentCell
            switch indexPath.row {
                case 2:
                    cell.field.text = "Username:"
                    cell.content.text = currentUser!.username
                case 3:
                    cell.field.text = "Drive Account:"
                    cell.content.text = currentUser!.googleAccountEmail
                case 4:
                    cell.field.text = "Subscription:"
                    cell.content.text = currentUser!.subscription
                case 5:
                    cell.field.text = "Subscription Status:"
                    if currentUser!.subscriptionStatus == "1"{
                        cell.content.text = "Active"
                    } else {
                        cell.content.text = "Not Active"
                    }
                case 6:
                    cell.field.text = "Days Left:"
                    if currentUser!.daysLeftOnSubscription.value == nil{
                        cell.content.text = "Infinite"
                    } else {
                        cell.content.text = "\(currentUser!.daysLeftOnSubscription) days"
                    }
                default:
                    print("there was an error rendering")

            }
                
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath) as! MyProfileLogoutCell
            cell.presentingView = self
            return cell
        }
    }
}

extension MyProfileViewController: SocketDelegate{
    func refreshView() {
        tableView.reloadData()
        if let myShelves = controller as? MyShelvesViewController{
            myShelves.refreshView()
        } else if let myVaults = controller as? MyVaultsViewController{
            myVaults.refreshView()
        } else if let metrics = controller as? MetricsViewController{
            metrics.refreshView()
        } else if let myTeams = controller as? MyTeamsViewController{
            myTeams.refreshView()
        }
    }
}

