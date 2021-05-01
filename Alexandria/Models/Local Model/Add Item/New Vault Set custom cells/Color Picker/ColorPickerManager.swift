////
////  ColorPickerManager.swift
////  Alexandria
////
////  Created by Waynar Bocangel on 8/22/20.
////  Copyright © 2020 BITFROST. All rights reserved.
////
//
//import UIKit
//
//class DisplayedColor: Equatable {
//
//    var red: CGFloat
//    var green: CGFloat
//    var blue: CGFloat
//    var colorName: String
//
//    init(){
//        red = 0.0
//        green = 0.0
//        blue = 0.0
//        colorName = ""
//    }
//
//    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, named: String){
//        self.red = red / 255
//        self.green = green / 255
//        self.blue = blue / 255
//        self.colorName = named
//    }
//
//    static func == (lhs: DisplayedColor, rhs: DisplayedColor) -> Bool {
//        if lhs.red != rhs.red || lhs.green != rhs.green || lhs.blue != rhs.blue {
//            return false
//        }
//        return true
//    }
//}
//
//extension ColorPickerViewController: UICollectionViewDelegate{
//
//}
//
//extension ColorPickerViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultColorCell.identifier, for: indexPath) as! DefaultColorCell
//        cell.controller = self
//        switch indexPath.row {
//        case 0:
//            let color = DisplayedColor(137, 179, 231, named: "Blue")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 1:
//            let color = DisplayedColor(161, 137, 231, named: "Purple")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 2:
//            let color = DisplayedColor(231, 137, 221, named: "Pink")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 3:
//            let color = DisplayedColor(231, 137, 137, named: "Red")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 4:
//            let color = DisplayedColor(231, 185, 137, named: "Orange")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 5:
//            let color = DisplayedColor(231, 225, 137, named: "Yellow")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 6:
//            let color = DisplayedColor(148, 231, 137, named: "Green")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 7:
//            let color = DisplayedColor(137, 231, 207, named: "Turquoise")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 8:
//            let color = DisplayedColor(201, 201, 201, named: "Grey")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        case 9:
//            let color = DisplayedColor(51, 51, 51, named: "Black")
//            cell.colorView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 1))
//            cell.highlightView.backgroundColor = UIColor(cgColor: CGColor(srgbRed:  color.red, green: color.green, blue: color.blue, alpha: 0.5))
//            cell.color = color
//            cell.colorName = color.colorName
//            if pickedColor == color{
//                currentCell = cell
//                cell.highlightView.alpha = 1.0
//            }
//        default:
//            print("something went wrong")
//        }
//        return cell
//    }
//
//
//}
//
//extension ColorPickerViewController{
//
//    @IBAction func dismissView(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func donePicking(_ sender: Any) {
//        controller.selectedColor = pickedColor
//        controller.colorName = pickedColorName
//        controller.tableView.reloadData()
//        dismiss(animated: true, completion: nil)
//    }
//
//}
