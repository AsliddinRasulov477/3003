//
//  Search.swift
//  3000
//
//  Created by Asliddin Rasulov on 18/09/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit
import Foundation

let color = UIColor(red: 51 / 255.0, green: 196 / 255.0, blue: 129 / 255.0, alpha: 0.5)

extension Array {
    
    func containsStringDoubleArray(searchText: String, existingDoubleArray: [[String]]) -> [String] {
        var array: [String] = []
        var doubleArraytoArray: [String] = []
        let boolDoubleArray = existingDoubleArray.flatMap { $0.map { $0.lowercased().contains(searchText.lowercased()) } }
    
        doubleArraytoArray = existingDoubleArray.flatMap { $0 }
    
        for i in 0..<boolDoubleArray.count {
            if boolDoubleArray[i] {
                array.append(doubleArraytoArray[i])
            }
        }
        return array
    }

    func containsStringArray(searchText: String, existingArray: [String]) -> [String] {
        var array: [String] = []
        let boolDoubleArray = existingArray.map{ $0.lowercased().contains(searchText.lowercased())}
    
        for i in 0..<boolDoubleArray.count {
            if boolDoubleArray[i] {
                array.append(existingArray[i])
            }
        }
        return array
    }
}

extension UIView {
    
    func keepTimer() -> Timer {
        let timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(timerCreatAd),
                                     userInfo: nil,
                                     repeats: true)
        return timer
    }
    
    @objc func creatAd() {
       let _ = keepTimer()
    }
    
    @objc func timerCreatAd(timer: Timer) {
        timer.invalidate()
        let width = self.frame.width
        let height = self.frame.height
        let reclamView = UIView()
        reclamView.frame = CGRect(x: 0, y: height * 0.7 - self.safeAreaInsets.bottom, width: width, height: height * 0.3)
        reclamView.backgroundColor = .systemBlue
        self.addSubview(reclamView)
        let imageView = UIImageView(frame: reclamView.bounds)
        imageView.image = UIImage(named: "ad0")
        imageView.contentMode = .scaleAspectFit
        reclamView.addSubview(imageView)
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
        closeButton.frame = CGRect(x: width - height * 0.05, y: 0, width: height * 0.05, height: height * 0.05)
        closeButton.backgroundColor = .systemRed
        reclamView.addSubview(closeButton)
        
    }
    @objc func closeAd() {
        self.subviews.last?.removeFromSuperview()
    }
}

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
            
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(rect.size)
        
        UIBezierPath(roundedRect: rect, cornerRadius: 15).addClip()
        image?.draw(in: rect)

        image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }

    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: LocalizationSystem.shared.bundle, comment: "")
    }
    
    func removeToSpecifiedIndex(specifiedString: String) -> String {
        var clonString = specifiedString
        let indexOfSpecifiedCharacter = clonString.firstIndex(of: " ")
        clonString.removeSubrange(clonString.startIndex...indexOfSpecifiedCharacter!)
        return clonString
    }
}

extension UISearchBar {
    
    func changeSearchBarColor(color: UIColor) {
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 35)
        UIGraphicsBeginImageContext(frame.size)
        color.setFill()
        UIBezierPath(rect: frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(makeRoundedImage(image: bgImage, radius: 15), for: .normal)
    }
    
    func makeRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageLayer: CALayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageLayer.contents = (image.cgImage as AnyObject)
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = 10
        UIGraphicsBeginImageContext(image.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return roundedImage
    }
}

extension UIViewController {
    func setSearchController(searchController: UISearchController, delegate: UISearchBarDelegate) {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = delegate
        searchController.searchBar.placeholder = "qidiruv".localized
        searchController.searchBar.changeSearchBarColor(color: .white)
        searchController.searchBar.tintColor = .black
    }
}


class EdgeInsetsLabel: UILabel {
    
    var textInsets =  UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
}

extension NSAttributedString {
    func replacing(placeholder:String, with valueString:String) -> NSAttributedString {

        if let range = self.string.range(of: placeholder) {
            let nsRange = NSRange(range, in: valueString)
            let mutableText = NSMutableAttributedString(attributedString: self)
            mutableText.replaceCharacters(in: nsRange, with: valueString)
            return mutableText as NSAttributedString
        }
        return self
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
