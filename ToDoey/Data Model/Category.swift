//
//  Category.swift
//  ToDoey
//
//  Created by Andrew Freire on 6/21/20.
//  Copyright © 2020 Andrew Freire. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
