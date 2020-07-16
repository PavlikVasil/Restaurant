//
//  Order.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct Order: Codable{
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []){
        self.menuItems = menuItems
    }
    
}
