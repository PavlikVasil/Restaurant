//
//  MenuItem.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct MenuItem: Codable{
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.detailText = try valueContainer.decode(String.self, forKey: CodingKeys.detailText)
        self.price = try valueContainer.decode(Double.self, forKey: CodingKeys.price)
        self.category = try valueContainer.decode(String.self, forKey: CodingKeys.category)
        self.imageURL = try valueContainer.decode(
            URL.self, forKey: CodingKeys.imageURL)
    }
}

struct MenuItems: Codable{
    let items: [MenuItem]
}
