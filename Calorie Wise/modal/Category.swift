//
//  Category.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

// Used to pass into Category view to display details.
struct Category {
    var id: String
    var name: String
    var image: UIImage
    var fontColor: UIColor
    var maxCalorie: Int
    var minCalorie: Int
}

// Object structure sent by the backend
struct CategoryDTO: Codable {
    var _id: String
    var name: String
    var imagePath: String
    var maxCalorie: Int
    var minCalorie: Int
}
