//
//  Category.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

struct Category {
    var id: String
    var name: String
    var image: UIImage
    var fontColor: UIColor
}

struct CategoryDTO: Codable {
    var _id: String
    var name: String
    var imagePath: String
}
