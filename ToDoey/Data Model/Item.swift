//
//  Item.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/21/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
