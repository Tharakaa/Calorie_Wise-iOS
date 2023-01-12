//
//  ApiCall.swift
//  Cook Book
//
//  Created by Tharaka Gamachchi on 2023-01-04.
//

import UIKit

class ApiCall: ObservableObject{
    
    static let baseURL = "https://cook-book-km1g.onrender.com/cookbook"
    static var user: UserDTO? = nil
    
    static var delegate:ListItemDelegate!
    
    static func isLoggedIn() -> Bool {
        return (user != nil && user?._id != nil && user?._id.trimmingCharacters(in: .whitespacesAndNewlines) != "")
    }
    
    static func logout() {
        user = nil
        let userDef:UserDefaults = .standard;
        let dictionary = userDef.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDef.removeObject(forKey: key)
        }
    }
    
    static func loadData() {
        let userDef:UserDefaults = .standard;
        let _id = userDef.string(forKey: "id")
        if (_id != nil && _id?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            let username = userDef.string(forKey: "username")
            let name = userDef.string(forKey: "name")
            user = UserDTO(_id: _id!, username: username!, name: name!, password: "")
        }
    }
    
    static func fetchCategories(completion:@escaping ([CategoryDTO]?) -> ()) {
        let urlPath = (baseURL + "/getCategories")
        let url = URL(string: urlPath)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            let categories:[CategoryDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([CategoryDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func fetchRecipesForCategory(category: String, completion:@escaping ([RecipeDTO]?) -> ()) {
        let urlPath = (baseURL + "/getRecipesForCategory")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["categoryId": category, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let categories:[RecipeDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([RecipeDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func searchRecipes(searchTerm: String, completion:@escaping ([RecipeDTO]?) -> ()) {
        let urlPath = (baseURL + "/searchRecipes")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["searchParam": searchTerm, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let categories:[RecipeDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([RecipeDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func getBookmarkedForUser(completion:@escaping ([RecipeDTO]?) -> ()) {
        let urlPath = (baseURL + "/getBookmarksForUser/" + (user?._id ?? ""))
        let url = URL(string: urlPath)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let categories:[RecipeDTO]?;
            if (data != nil) {
                categories = try? JSONDecoder().decode([RecipeDTO].self, from: data!)
            } else {
                categories = nil
            }
            DispatchQueue.main.async {
                completion(categories)
            }
        }.resume()
        
    }
    
    static func register(parameters: [String:String?], completion:@escaping (Int?) -> ()) {
        let urlPath = (baseURL + "/register")
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse?.statusCode == 400) {
                DispatchQueue.main.async {
                    completion(1)
                }
            } else {
                //self.user = try? JSONDecoder().decode(UserDTO.self, from: data!)
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }.resume()
        
    }
    
    static func login(parameters: [String:String?], completion:@escaping (Int?) -> ()) {
        let urlPath = (baseURL + "/login")
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse?.statusCode == 401) {
                DispatchQueue.main.async {
                    completion(1)
                }
            } else {
                self.user = try? JSONDecoder().decode(UserDTO.self, from: data!)
                let userDef:UserDefaults = .standard;
                userDef.set(self.user?._id, forKey: "id")
                userDef.set(self.user?.username, forKey: "username")
                userDef.set(self.user?.name, forKey: "name")
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }.resume()
        
    }
    
    static func fetchCategoryImage(path: String, completion:@escaping (UIImage) -> ()) {
        let urlPath = (baseURL + "/public/" + path)
        let url = URL(string: urlPath)!
        // Fetch Image Data
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }).resume()
        
    }
    
    static func fetchProductImage(path: String, completion:@escaping (UIImage) -> ()) {
        let urlPath = (baseURL + "/public/img/" + path)
        let url = URL(string: urlPath)!
        // Fetch Image Data
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }).resume()
        
    }
    
    static func addBookmark(recipe: String, completion:@escaping () -> ()) {
        let urlPath = (baseURL + "/saveBookmark")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["recipe": recipe, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    static func removeBookmark(recipe: String, completion:@escaping () -> ()) {
        let urlPath = (baseURL + "/removeBookmark")
        let url = URL(string: urlPath)!
        
        let parameters: [String: String?] = ["recipe": recipe, "username": user?._id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    
    
}
