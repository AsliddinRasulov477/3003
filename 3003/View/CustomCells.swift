//
//  CustomCells.swift
//  3003
//
//  Created by Asliddin Rasulov on 28/10/20.
//

import Foundation
import UIKit

class CustomTableCell: UITableViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        descriptionLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        if self.reuseIdentifier == "cell" {
            numLabel.font = UIFont.boldSystemFont(ofSize: self.frame.width / 28)
            descriptionLabel.font = UIFont.boldSystemFont(ofSize: self.frame.width / 28)
        } else {
            numLabel.font = UIFont.systemFont(ofSize: self.frame.width / 28)
            descriptionLabel.font = UIFont.systemFont(ofSize: self.frame.width / 28)
        }
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 4, height: 4)
    
    }

    override var frame: CGRect {
        get {
            return super.frame
        } set (newFrame) {
            textLabel?.numberOfLines = 0
            var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 20
            frame.origin.y += 7
            frame.size.height -= 14
            super.frame = frame
        }
    }
}

class AnotherAppsCell: UITableViewCell {
    @IBOutlet weak var imageApp: UIImageView!
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var descriptionApp: UILabel!
    
    
    override var frame: CGRect {
        get {
            return super.frame
        } set (newFrame) {
            var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 20
            frame.origin.y += 5
            frame.size.height -= 10
            super.frame = frame
        }
    }
}
