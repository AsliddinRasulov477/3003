//
//  Data.swift
//  3000
//
//  Created by Asliddin Rasulov on 05.10.2020.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var allDocsName: String = ""
    @objc dynamic var bookmarked: String = ""
    let bookmarks = List<String>()
    convenience init(bookmark: String) {
        self.init()
        self.allDocsName.append(bookmark)
    }
}
