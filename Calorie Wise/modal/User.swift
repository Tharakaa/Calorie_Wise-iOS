//
//  User.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-05.
//

import Foundation

// Used to parse data sent by backend
struct UserDTO: Codable {
    var _id: String
    var username: String
    var name: String
    var password: String
}
