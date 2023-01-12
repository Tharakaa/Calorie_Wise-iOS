//
//  Recipe.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

struct Recipe {
    var _id: String?
    var name: String
    var smallDescription: String
    var description: String
    var image: UIImage
    var isBookMarked: Bool = false
}

struct RecipeDTO: Codable {
    var _id: String?
    var category: String?
    var name: String
    var smallDescription: String
    var description: String
    var imagePath: String
    var isBookMarked: Bool = false
}
