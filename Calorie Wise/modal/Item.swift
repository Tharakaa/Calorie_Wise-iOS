//
//  Recipe.swift
//  Calorie Wise
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

// used to create the view
struct Item {
    var _id: String?
    var name: String
    var description: String
    var image: UIImage
    var isBookMarked: Bool = false
    var score: Int
    var calorie: Int
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var fiber: Double
    var calcium: Double
    var ingredients: [IngredientItem]
}

// Use to parse data sent by backend
struct ItemDTO: Codable {
    var _id: String?
    var name: String
    var description: String
    var imagePath: String
    var isBookMarked: Bool = false
    var score: Int
    var calorie: Int
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var fiber: Double
    var calcium: Double
    var ingredients: [IngredientItem]
}

struct IngredientItem: Codable {
    var name: String
    var quantity: String
}
