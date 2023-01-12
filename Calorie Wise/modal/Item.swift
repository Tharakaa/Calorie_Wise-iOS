//
//  Recipe.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-02.
//

import UIKit

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
}

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
}
