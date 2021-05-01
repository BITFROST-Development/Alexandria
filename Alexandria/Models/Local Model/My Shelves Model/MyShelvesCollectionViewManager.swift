////
////  MyShelvesCollectionViewManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/4/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import MobileCoreServices
//
//extension MyShelvesViewController: UICollectionViewDelegate{
//    
//}
//
//extension MyShelvesViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if loggedIn {
//            let user = realm.objects(CloudUser.self)[0]
//            var counter = 0
//            if shelfName.currentTitle != "All my books" {
//                for shelf in user.alexandria!.shelves {
//                    if shelf.name == shelfName.currentTitle {
//                        selectedShelfIndex = counter
//                        self.shelfPrePreferencesTableView.reloadData()
//                        return shelf.books.count + shelf.oppositeBooks.count
//                    }
//                    counter += 1
//                }
//                
//                counter = 0
//                
//                for shelf in user.alexandria!.localShelves {
//                    if shelf.name == shelfName.currentTitle {
//                        selectedShelfIndex = counter
//                        self.shelfPrePreferencesTableView.reloadData()
//                        return shelf.books.count + shelf.oppositeBooks.count
//                    }
//                    counter += 1
//                }
//            }
//        } else {
//            let user = realm.objects(UnloggedUser.self)[0]
//            var counter = 0
//            if shelfName.currentTitle != "All my books" {
//                for shelf in user.alexandria!.localShelves {
//                    if shelf.name == shelfName.currentTitle {
//                        selectedShelfIndex = counter
//                        self.shelfPrePreferencesTableView.reloadData()
//                        return shelf.books.count
//                    }
//                    counter += 1
//                }
//            }
//        }
//        
//        return realm.objects(Book.self).count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = shelfCollectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as! BookCell
//        cell.controller = self
//        if loggedIn {
//            let user = realm.objects(CloudUser.self)[0]
//            if shelfName.currentTitle == "All my books"{
//                let cloudBooks = realm.objects(AlexandriaData.self)[0].cloudBooks
//                let localBooks = realm.objects(AlexandriaData.self)[0].localBooks
//                if indexPath.row < cloudBooks.count{
//                    cell.thumbnailImage.setImage(UIImage(data: (cloudBooks[indexPath.row].thumbnail?.data)!), for: .normal)
//                    cell.bookTitle.text = cloudBooks[indexPath.row].name
//                    var description = "Unknown"
//                    var newLine = false
//                    if cloudBooks[indexPath.row].author != "" {
//                        description = cloudBooks[indexPath.row].author!
//                        newLine = true
//                    }
//                    if  cloudBooks[indexPath.row].year != ""{
//                        if newLine {
//                            description += ", \(cloudBooks[indexPath.row].year!)"
//                        } else {
//                            description = cloudBooks[indexPath.row].year!
//                        }
//                    }
//                    cell.isCloud = true
//                    cell.bookIndex = Double(indexPath.row)
//                    cell.bookDescription.text = description
//                } else {
//                    cell.thumbnailImage.setImage(UIImage(data: (localBooks[indexPath.row - cloudBooks.count].thumbnail?.data)!), for: .normal)
//                    cell.bookTitle.text = localBooks[indexPath.row - cloudBooks.count].name
//                    var description = "Unknown"
//                    var newLine = false
//                    if localBooks[indexPath.row - cloudBooks.count].author != "" {
//                        description = localBooks[indexPath.row - cloudBooks.count].author!
//                        newLine = true
//                    }
//                    if  localBooks[indexPath.row - cloudBooks.count].year != ""{
//                        if newLine {
//                            description += ", \(localBooks[indexPath.row - cloudBooks.count].year!)"
//                        } else {
//                            description = localBooks[indexPath.row - cloudBooks.count].year!
//                        }
//                    }
//                    cell.isCloud = false
//                    cell.bookIndex = Double(indexPath.row - cloudBooks.count)
//                    cell.bookDescription.text = description
//                }
//            } else {
//                if cloudShelf {
//                    if indexPath.row < user.alexandria!.shelves[selectedShelfIndex].books.count {
//                        cell.thumbnailImage.setImage(UIImage(data: (user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].thumbnail?.data)!), for: .normal)
//                        cell.bookTitle.text = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].name
//                        var description = "Unknown"
//                        var comma = false
//                        if user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].author != "" {
//                            description = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].author!
//                            comma = true
//                        }
//                        if user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].year != "" {
//                            if comma {
//                                description += ", \(user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].year!)"
//                            } else {
//                                description = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].books[indexPath.row])].year!
//                            }
//                        }
//                        cell.isCloud = true
//                        cell.bookIndex = Double(indexPath.row)
//                        cell.bookDescription.text = description
//                    } else {
//                        cell.thumbnailImage.setImage(UIImage(data: (user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].thumbnail?.data)!), for: .normal)
//                        cell.bookTitle.text = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].name
//                        var description = "Unknown"
//                        var comma = false
//                        if user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].author != "" {
//                            description = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].author!
//                            comma = true
//                        }
//                        if user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].year != "" {
//                            if comma {
//                                description += ", \(user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].year!)"
//                            } else {
//                                description = user.alexandria!.cloudBooks[Int(user.alexandria!.shelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count])].year!
//                            }
//                        }
//                        cell.isCloud = false
//                        cell.bookIndex = Double(indexPath.row - user.alexandria!.shelves[selectedShelfIndex].books.count)
//                        cell.bookDescription.text = description
//                    }
//                } else {
//                    if indexPath.row < user.alexandria!.localShelves[selectedShelfIndex].books.count {
//                        cell.thumbnailImage.setImage(UIImage(data: (user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].thumbnail?.data)!), for: .normal)
//                        cell.bookTitle.text = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].name
//                        var description = "Unknown"
//                        var comma = false
//                        if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].author != "" {
//                            description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].author!
//                            comma = true
//                        }
//                        if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year != "" {
//                            if comma {
//                                description += ", \(user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year!)"
//                            } else {
//                                description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year!
//                            }
//                        }
//                        cell.isCloud = false
//                        cell.bookIndex = Double(indexPath.row)
//                        cell.bookDescription.text = description
//                    } else {
//                        cell.thumbnailImage.setImage(UIImage(data: (user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].thumbnail?.data)!), for: .normal)
//                        cell.bookTitle.text = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].name
//                        var description = "Unknown"
//                        var comma = false
//                        if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].author != "" {
//                            description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].author!
//                            comma = true
//                        }
//                        if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].year != "" {
//                            if comma {
//                                description += ", \(user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].year!)"
//                            } else {
//                                description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].oppositeBooks[indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count])].year!
//                            }
//                        }
//                        cell.isCloud = true
//                        cell.bookIndex = Double(indexPath.row - user.alexandria!.localShelves[selectedShelfIndex].books.count)
//                        cell.bookDescription.text = description
//                    }
//                }
//                
//            }
//        } else {
//            let user = realm.objects(UnloggedUser.self)[0]
//            if shelfName.currentTitle == "All my books"{
//                let bookList = realm.objects(Book.self)
//                cell.thumbnailImage.setImage(UIImage(data: (bookList[indexPath.row].thumbnail?.data)!), for: .normal)
//                cell.bookTitle.text = bookList[indexPath.row].name
//                var description = "Unknown"
//                var newLine = false
//                if bookList[indexPath.row].author != "" {
//                    description = bookList[indexPath.row].author!
//                    newLine = true
//                }
//                if  bookList[indexPath.row].year != ""{
//                    if newLine {
//                        description += ", \(bookList[indexPath.row].year!)"
//                    } else {
//                        description = bookList[indexPath.row].year!
//                    }
//                }
//                
//                cell.isCloud = false
//                cell.bookIndex = Double(indexPath.row)
//                cell.bookDescription.text = description
//            } else {
//                cell.thumbnailImage.setImage(UIImage(data: (user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].thumbnail?.data)!), for: .normal)
//                cell.bookTitle.text = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].name
//                var description = "Unknown"
//                var comma = false
//                if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].author != "" {
//                    description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].author!
//                    comma = true
//                }
//                if user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year != "" {
//                    if comma {
//                        description += ", \(user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year!)"
//                    } else {
//                        description = user.alexandria!.localBooks[Int(user.alexandria!.localShelves[selectedShelfIndex].books[indexPath.row])].year!
//                    }
//                }
//                cell.isCloud = false
//                cell.bookIndex = Double(indexPath.row)
//                cell.bookDescription.text = description
//            }
//        }
//        return cell
//    }
//}
