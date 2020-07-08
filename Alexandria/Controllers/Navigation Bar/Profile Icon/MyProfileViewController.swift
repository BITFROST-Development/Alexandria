//
//  ViewController.swift
//  Alexandria
//
//  Created by Waynar Bocangel on 6/15/20.
//  Copyright © 2020 BITFROST. All rights reserved.
//

import UIKit
import RealmSwift

class MyProfileViewController: UIViewController {
    
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
    
    func logoutPressed(){
        let realm = try! Realm()
        let sem = DispatchSemaphore.init(value: 0)
        let logoutRequest = RequestManager()
        let unloggedUser = UnloggedUser()
        let cloudUser = realm.objects(CloudUser.self)[0]
        
        unloggedUser.alexandriaData = cloudUser.alexandriaData
        do{
            try realm.write(){
                realm.add(unloggedUser)
                realm.delete(cloudUser)
                sem.signal()
            }
        } catch {
            let alert = UIAlertController(title: "Error Loging Out", message: "We weren't able to log you out. Close the application and try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        sem.wait()
        logoutRequest.logOut()
        RegisterLoginViewController.loggedIn = false
        self.dismiss(animated: true, completion: nil)
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

