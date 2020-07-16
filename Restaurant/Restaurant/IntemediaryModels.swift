//
//  IntemediaryModels.swift
//  Restaurant
//
//  Created by Павел on 6/10/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct Categories: Codable{
    let categories: [String]
}

struct PreparationTime: Codable{
    let prepTime: Int
    
     enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
