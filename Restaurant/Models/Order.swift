//
//  Order.swift
//  Restaurant
//
//  Created by doortje on 03/12/2018.
//  Copyright © 2018 Doortje. All rights reserved.
//

import Foundation


// Lijst van gerechten die de gebruiker heeft toegevoegd.

struct Order: Codable {
    var menuItems: [MenuItem]
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
